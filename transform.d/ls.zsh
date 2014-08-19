## TODO: ls matches not very accurate
## ls -<flags> <dir> -> cd <dir>
_dwim_prepend_transform '^ls -[A-Za-z0-9]+ .+' \
  'local filename
  _dwim_sed "s/^ls -[A-Za-z0-9]+ //"
  filename=$BUFFER
  filename=${(Q)filename}
  if [[ -d "$filename" ]]; then
    BUFFER="cd $filename"
  fi'

## ls <dir> -> cd <dir>
_dwim_prepend_transform '^ls [^-].*' \
  'local filename
  _dwim_sed "s/^ls //"
  filename=$BUFFER
  filename=${(Q)filename}
  if [[ -d "$filename" ]]; then
    BUFFER="cd $filename"
  fi'

