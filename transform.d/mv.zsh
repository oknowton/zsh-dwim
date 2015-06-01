## mv <src> <target> -> cd <target>
_dwim_prepend_transform '^mv [a-zA-Z0-9/_-]+ ' \
  'local filename
  _dwim_sed "s/^mv [a-zA-Z0-9/_-]+ //"
  filename=$BUFFER
  filename=${(Q)filename}
  if [[ -d "$filename" ]]; then
    BUFFER="cd $filename"
  fi'
