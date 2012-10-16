dwim() {
  local ORIGINAL_BUFFER
  
  if [[ ! -n $BUFFER ]]; then
    (( HISTNO -= 1 ))
  fi

  ORIGINAL_BUFFER=$BUFFER
  
  BUFFER=$($HOME/.zprezto/modules/dwim/dwim.pl "$BUFFER")

  if [[ $CURSOR == $#ORIGINAL_BUFFER ]]; then
    CURSOR=$#BUFFER
  elif [[ $CURSOR == 0 ]]; then
    CURSOR=0
  elif [[ $#ORIGINAL_BUFFER -gt $#BUFFER ]]; then
    echo bigger: $CURSOR >> /tmp/debug
    (( CURSOR -= $#ORIGINAL_BUFFER - $#BUFFER ))
    echo $CURSOR $#ORIGINAL_BUFFER $#BUFFER >> /tmp/debug
  elif [[ $#ORIGINAL_BUFFER -lt $#BUFFER ]]; then
    echo smaller: $CURSOR >> /tmp/debug
    (( CURSOR += $#BUFFER - $#ORIGINAL_BUFFER ))
    echo $CURSOR $#ORIGINAL_BUFFER $#BUFFER >> /tmp/debug
  fi
}
      
zle -N dwim
bindkey "^U" dwim
