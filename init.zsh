typeset -gA _dwim_data_regex
typeset -gA _dwim_data_sed
typeset -gA _dwim_data_exitstatus

_dwim_sed() {
  BUFFER=$(echo $BUFFER | sed -re "$1")
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

  ## apt-cache search -> sudo apt-get install
  _dwim_add_transform '^apt-cache (search|show)' \
    '_dwim_sed "s/^apt-cache (search|show)/sudo apt-get install/"'

  ## sudo apt-get update -> sudo apt-get upgrade
  _dwim_add_transform '^sudo apt-get update' \
    '_dwim_sed "s/^sudo apt-get update/sudo apt-get upgrade/"'
  
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

  ## mkdir -> cd
  _dwim_add_transform '^mkdir ' \
    '_dwim_sed "s/^mkdir /cd /"'

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
  
  if [[ $CURSOR == $#ORIGINAL_BUFFER ]]; then
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

