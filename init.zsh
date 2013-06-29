typeset -gA _dwim_data_regex
typeset -gA _dwim_data_sed
typeset -gA _dwim_data_exitstatus

if [[ $DWIM_REGEX_CMD == "" ]]; then
  if (( $+commands[gsed] )); then
    DWIM_REGEX_CMD='gsed -re'       # use gsed if it exists, for BSDs
  else
    echo | sed -re '' &> /dev/null 
    if [[ $? == 0 ]]; then
      DWIM_REGEX_CMD='sed -re'      # use sed if it supports the -r option
    else
      DWIM_REGEX_CMD='perl -pe'     # otherwise, use perl
    fi
  fi
fi

_dwim_sed(){
  BUFFER=$(echo $BUFFER | ${=DWIM_REGEX_CMD} "$1")
}

_dwim_add_transform(){
  _dwim_data_regex[$(($#_dwim_data_regex+1))]=$1
  _dwim_data_sed[$(($#_dwim_data_sed+1))]=$2

  if [[ "$3" != "" ]]; then
    _dwim_data_exitstatus[$(($#_dwim_data_exitstatus+1))]=$3
  else
    _dwim_data_exitstatus[$(($#_dwim_data_exitstatus+1))]="any"
  fi
  
  return
}

_dwim_build_data() {

  ## modprobe -> modprobe -r -> modprobe
  _dwim_add_transform '^(sudo modprobe |modprobe )-r' \
    '_dwim_sed "s/ -r//"'

    _dwim_add_transform '^(sudo modprobe |modprobe )' \
    '_dwim_sed "s/modprobe/modprobe -r/"'

  ## watch -> watch -n 10 -> watch -n 30
  _dwim_add_transform '^(sudo watch |watch )-n 10' \
    '_dwim_sed "s/ -n 10/ -n 30/"'

  _dwim_add_transform '^(sudo watch |watch )-n 30' \
    '_dwim_sed "s/ -n 30//"'

  _dwim_add_transform '^(sudo watch |watch )' \
    '_dwim_sed "s/watch/watch -n 10/"'

  ## apt-cache search -> sudo apt-get install
  _dwim_add_transform '^apt-cache (search|show)' \
    '_dwim_sed "s/^apt-cache (search|show)/sudo apt-get install/"'

  ## sudo apt-get update -> sudo apt-get upgrade
  _dwim_add_transform '^sudo apt-get update' \
    '_dwim_sed "s/^sudo apt-get update/sudo apt-get upgrade/"'

  ## failed dpkg --install -> apt-get -f install
  _dwim_add_transform '^sudo dpkg --install' \
    'BUFFER="sudo apt-get -f install"' \
    1
  
  ## scp hostname: -> scp hostname:<newest file>
  ### Long winded, assuming no zsh on remote side
  _dwim_add_transform '^scp .+:$' \
    'local HOST
     local FILE
     HOST=$(echo $BUFFER | sed -re "s/^scp (.+):/\1/")
     FILE=$(ssh $HOST "ls -tpb" | grep -v / | head -1)
     BUFFER="$BUFFER\"$FILE\" "'

  ## ssh hostname -> scp hostname:
  _dwim_add_transform '^ssh .+' \
    '_dwim_sed "s/^ssh (.+)/scp \1:/"'
  
  ## scp -> mv 
  _dwim_add_transform '^scp .+:' \
    '_dwim_sed "s/^scp /mv /"; _dwim_sed "s/ [A-Za-z0-9@\-\.]+:.*//"'

  ## tar ft -> tar fx
  _dwim_add_transform '^tar (ft|tf)' \
    '_dwim_sed "s/^tar (ft|tf)/tar fx/"'

  ## tar xf -> cd # using tarball contents
  _dwim_add_transform '^tar [A-Za-z0-9\-]*x[A-Za-z0-9]* ' \
    'local tarball
    _dwim_sed "s/^tar [A-Za-z]+ //"
    tarball=$BUFFER
    tarball=${(Q)tarball}
    if [[ -e "$tarball" ]]; then
      local newpath
      newpath=$(tar ft $tarball | head -1)
      BUFFER="cd $newpath"
    fi'

  ## ssh -> ssh-keygen
  _dwim_add_transform '^ssh ' \
    'if [[ $BUFFER =~ "^ssh .*[A-Za-z0-9]+@([A-Za-z0-9.]+).*" ]]; then
      _dwim_sed "s/^ssh\s+[A-Za-z0-9]+@([A-Za-z0-9.\-]+).*/ssh-keygen -R \1/"
    else
      _dwim_sed "s/^ssh /ssh-keygen -R /"
    fi' \
    255
  
  ## wine -> WINDEBUG="-all" wine
  _dwim_add_transform '^wine ' \
    '_dwim_sed "s/^wine /WINEDEBUG=\"-all\" wine /"'

  ## service <> stop -> service <> start
  _dwim_add_transform '^sudo (service |\/etc\/init.d\/)[a-zA-Z0-9]+ stop' \
    '_dwim_sed "s/stop/start/"'

  ## service <> start -> service <> stop
  _dwim_add_transform '^sudo (service |\/etc\/init.d\/)[a-zA-Z0-9]+ start' \
    '_dwim_sed "s/start/stop/"'

  ## mkdir -> mkdir -p (on failure)
  _dwim_add_transform '^mkdir (-p){0}' \
    '_dwim_sed "s/mkdir /mkdir -p /"' \
    1

  ## mkdir -p -> cd
  _dwim_add_transform '^mkdir -p' \
    '_dwim_sed "s/mkdir -p /cd /"'
  
  ## mkdir -> cd
  _dwim_add_transform '^mkdir ' \
    '_dwim_sed "s/^mkdir /cd /"'

  ## cd -> mkdir on failure
  _dwim_add_transform '^cd ' \
    '_dwim_sed "s/cd /mkdir /"' \
    1
  
  ## mount -> umount
  _dwim_add_transform '^sudo mount' \
    '_dwim_sed "s/^sudo mount/sudo umount/"'
  
  ## umount -> mount
  _dwim_add_transform '^sudo umount' \
    '_dwim_sed "s/^sudo umount/sudo mount/"'

  ## TODO: ls matches not very accurate
  ## ls -<flags> <dir> -> cd <dir>
  _dwim_add_transform '^ls -[A-Za-z0-9]+ .+' \
    'local filename
    _dwim_sed "s/^ls -[A-Za-z0-9]+ //"
    filename=$BUFFER
    filename=${(Q)filename}
    if [[ -d "$filename" ]]; then
      BUFFER="cd $filename"
    fi'

  ## ls <dir> -> cd <dir>
  _dwim_add_transform '^ls [^-].*' \
    'local filename
    _dwim_sed "s/^ls //"
    filename=$BUFFER
    filename=${(Q)filename}
    if [[ -d "$filename" ]]; then
      BUFFER="cd $filename"
    fi'

  ## vmstat -> dstat -f -> vmstat
  _dwim_add_transform '^vmstat' \
    '_dwim_sed "s/^vmstat/dstat -f/"'

  _dwim_add_transform '^dstat -f' \
    '_dwim_sed "s/^dstat -f/vmstat/"'

  ## rsync -> rsync -aHAXS -> rsync -axHAXS
  _dwim_add_transform '^rsync -aHAXS' \
    '_dwim_sed "s/^rsync -aHAXS/rsync -axHAXS/"'

  _dwim_add_transform '^rsync -axHAXS' \
    '_dwim_sed "s/^rsync -axHAXS/rsync/"'

  _dwim_add_transform '^rsync ' \
    '_dwim_sed "s/^rsync /rsync -aHAXS /"'

  ## find -> find -exec echo {} \; -> find -exec {} \; -> find -print0 | xargs -0
  _dwim_add_transform '^find .*-exec echo' \
    '_dwim_sed "s/-exec echo/-exec/"'

  _dwim_add_transform '^find .*-exec' \
    '_dwim_sed "s/-exec/-print0 | xargs -0/"
     _dwim_sed "s/\{\} \\\;//"'

  _dwim_add_transform '^find .*' \
    'BUFFER="$BUFFER -exec echo {} \;"
    (( _dwim_cursor = $#BUFFER - 5))'

  _dwim_add_transform '^which ' \
    'BUFFER="dpkg -S \$(/usr/bin/$BUFFER)"'

  _dwim_add_transform '^dpkg -S ' \
    'BUFFER="apt-cache show \$($BUFFER | cut -d : -f 1 )"'

  _dwim_add_transform '^sudo add-apt-repository' \
    'BUFFER="sudo apt-get update"
     _dwim_cursor=$#BUFFER'

  _dwim_add_transform '^add-apt-repository' \
    'BUFFER="sudo $BUFFER"'
}

_dwim_build_data

_dwim_transform() {
  local regex
  local oldbuffer
  oldbuffer=$BUFFER
  
  for i in {1..${#_dwim_data_regex}}; do
    if [[ "$BUFFER" =~ "$_dwim_data_regex[$i]" ]]; then
      if [[ "$_dwim_data_exitstatus[$i]" == "$_dwim_exit_status" ||
            "$_dwim_data_exitstatus[$i]" == "any" ]]; then
        eval "$_dwim_data_sed[$i]"
      fi
    fi

    if [[ "$oldbuffer" != "$BUFFER" ]]; then
      return
    fi
  done

  ## TODO: rework dwim hash to eliminate this special case
  if [[ $BUFFER =~ '^sudo ' ]]; then
    _dwim_sed "s/^sudo //"
  else
    BUFFER="sudo $BUFFER"
  fi

  return
}

dwim() {
  _dwim_exit_status=$?        ## Must be stored immediately...
  local ORIGINAL_BUFFER

  if [[ ! -n $BUFFER ]]; then
    (( HISTNO -= 1 ))
  fi

  ORIGINAL_BUFFER=$BUFFER

  _dwim_transform

  if [[ $_dwim_cursor -gt 0 ]]; then
    CURSOR=$_dwim_cursor
    _dwim_cursor=0
  elif [[ $CURSOR == $#ORIGINAL_BUFFER ]]; then
    CURSOR=$#BUFFER
  elif [[ $CURSOR == 0 ]]; then
    CURSOR=0
  elif [[ $#ORIGINAL_BUFFER -gt $#BUFFER ]]; then
    (( CURSOR -= $#ORIGINAL_BUFFER - $#BUFFER ))
  elif [[ $#ORIGINAL_BUFFER -lt $#BUFFER ]]; then
    (( CURSOR += $#BUFFER - $#ORIGINAL_BUFFER ))
  fi
}
      
zle -N dwim
bindkey "^U" dwim

