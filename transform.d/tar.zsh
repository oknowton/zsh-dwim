## tar ft -> tar fx
_dwim_prepend_transform '^tar (ft|tf)' \
  '_dwim_sed "s/^tar (ft|tf)/tar fx/"'

## tar xf -> cd # using tarball contents
_dwim_prepend_transform '^tar [A-Za-z0-9\-]*x[A-Za-z0-9]* ' \
  'local tarball
  _dwim_sed "s/^tar [A-Za-z]+ //"
  tarball=$BUFFER
  tarball=${(Q)tarball}
  if [[ -e "$tarball" ]]; then
    local newpath
    newpath=$(tar ft $tarball | head -1)
    BUFFER="cd $newpath"
  fi'

