typeset -ga _dwim_data_regex
typeset -ga _dwim_data_sed
typeset -ga _dwim_data_exitstatus

_dwim_transform_dir=${0:a:h}/transform.d

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

_dwim_prepend_transform() {
  _dwim_data_regex[$(($#_dwim_data_regex+1))]=$1
  _dwim_data_sed[$(($#_dwim_data_sed+1))]=$2

  if [[ "$3" != "" ]]; then
    _dwim_data_exitstatus[$(($#_dwim_data_exitstatus+1))]=$3
  else
    _dwim_data_exitstatus[$(($#_dwim_data_exitstatus+1))]="any"
  fi
  
  return
}

_dwim_add_transform() {
  local regex_tmp
  local sed_tmp
  local exitstatus_tmp
  local i

  typeset -a regex_tmp
  typeset -a sed_tmp
  typeset -a exitstatus_tmp
  
  for i in {1..${#_dwim_data_regex}}; do
    regex_tmp[$i]="$_dwim_data_regex[$i]"
  done

  for i in {1..${#_dwim_data_sed}}; do
    sed_tmp[$i]="$_dwim_data_sed[$i]"
  done

  for i in {1..${#_dwim_data_exitstatus}}; do
    exitstatus_tmp[$i]="$_dwim_data_exitstatus[$i]"
  done

  _dwim_data_regex=()
  _dwim_data_regex[1]="$1"
  for i in {1..${#regex_tmp}}; do
    _dwim_data_regex[$(($i+1))]="$regex_tmp[$i]"
  done

  _dwim_data_sed=()
  _dwim_data_sed[1]="$2"
  for i in {1..${#sed_tmp}}; do
    _dwim_data_sed[$(($i+1))]="$sed_tmp[$i]"
  done

  _dwim_data_exitstatus=()
  for i in {1..${#exitstatus_tmp}}; do
    _dwim_data_exitstatus[$(($i+1))]="$exitstatus_tmp[$i]"
  done

  if [[ "$3" != "" ]]; then
    _dwim_data_exitstatus[1]=$3
  else
    _dwim_data_exitstatus[1]="any"
  fi
  
  return
}

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
      
source ${0:a:h}/config.zsh
