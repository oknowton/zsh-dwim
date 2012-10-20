_dwim_transform() {

  if [[ $BUFFER =~ '^apt-cache (search|show)' ]]; then
    BUFFER=$(echo $BUFFER | sed -re 's/^apt-cache (search|show)/sudo apt-get install/')
    return;
  fi

  if [[ $BUFFER =~ '^scp .+:' ]]; then
    BUFFER=$(echo $BUFFER | sed -re 's/^scp /mv /')
    BUFFER=$(echo $BUFFER | sed -re 's/ [A-Za-z0-9@\-\.]+:.*//')
    return;
  fi

  if [[ $BUFFER =~ '^tar (ft|tf)' ]]; then
    BUFFER=$(echo $BUFFER | sed -re 's/^tar (ft|tf)/tar fx/')
    return;
  fi

  if [[ $BUFFER =~ '^ssh ' ]]; then
    if [[ $BUFFER =~ '^ssh .*[A-Za-z0-9]+@([A-Za-z0-9.]+).*' ]]; then
      BUFFER=$(echo $BUFFER | sed -re 's/^ssh\s+[A-Za-z0-9]+@([A-Za-z0-9.\-]+).*/ssh-keygen -R \1/')
    else
      BUFFER=$(echo $BUFFER | sed -re 's/^ssh /ssh-keygen -R /')
    fi

    return;
  fi

  if [[ $BUFFER =~ '^wine ' ]]; then
    BUFFER=$(echo $BUFFER | sed -re 's/^wine /WINEDEBUG="-all" wine /')
    return;
  fi

  if [[ $BUFFER =~ '^sudo (service |\/etc\/init.d\/)[a-zA-Z0-9]+ stop' ]]; then
    BUFFER=$(echo $BUFFER | sed -re 's/stop/start/')
    return;
  fi

  if [[ $BUFFER =~ '^sudo (service |\/etc\/init.d\/)[a-zA-Z0-9]+ start' ]]; then
    BUFFER=$(echo $BUFFER | sed -re 's/start/stop/')
    return;
  fi

  if [[ $BUFFER =~ '^mkdir ' ]]; then
    BUFFER=$(echo $BUFFER | sed -re 's/^mkdir /cd /')
    return;
  fi

  if [[ $BUFFER =~ '^sudo ' ]]; then
    BUFFER=$(echo $BUFFER | sed -re 's/^sudo //')
    return;
  fi

  BUFFER="sudo $BUFFER"
  
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
