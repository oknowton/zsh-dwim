typeset -gA hash _dwim_data

_dwim_sed() {
  BUFFER=$(echo $BUFFER | sed -re "$1")
}

_dwim_add_transform(){
  _dwim_data[$1]="$2";

  return
}

_dwim_build_data() {

  ## apt-cache search -> sudo apt-get install
  _dwim_add_transform '^apt-cache (search|show)' \
    '_dwim_sed "s/^apt-cache (search|show)/sudo apt-get install/"'

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
    fi'

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

  ## remove sudo
  _dwim_add_transform '^sudo ' \
    '_dwim_sed "s/^sudo //"'

}

_dwim_build_data

_dwim_transform() {
  local regex
  local oldbuffer
  oldbuffer=$BUFFER
  
  for regex in ${(k)_dwim_data}; do
    if [[ "$BUFFER" =~ "$regex" ]]; then
      eval "${_dwim_data[$regex]}"
    fi

    if [[ "$oldbuffer" != "$BUFFER" ]]; then
      return
    fi
  done

  BUFFER="sudo $BUFFER"

  return
}

dwim() {
  local ORIGINAL_BUFFER
  
  if [[ ! -n $BUFFER ]]; then
    (( HISTNO -= 1 ))
  fi

  ORIGINAL_BUFFER=$BUFFER
  
  #BUFFER=$($HOME/.zprezto/modules/dwim/dwim.pl "$BUFFER")
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
