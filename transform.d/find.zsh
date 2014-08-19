## find -> find -exec echo {} \; -> find -exec {} \; -> find -print0 | xargs -0
_dwim_prepend_transform '^find .*-exec echo' \
  '_dwim_sed "s/-exec echo/-exec/"'

_dwim_prepend_transform '^find .*-exec' \
  '_dwim_sed "s/-exec/-print0 | xargs -0/"
   _dwim_sed "s/\{\} \\\;//"'

_dwim_prepend_transform '^find .*' \
  'BUFFER="$BUFFER -exec echo {} \;"
  (( _dwim_cursor = $#BUFFER - 5))'

