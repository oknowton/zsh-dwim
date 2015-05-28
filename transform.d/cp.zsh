# cp -> cp -R on failure
_dwim_prepend_transform '^cp ' \
  '_dwim_sed "s/^cp /cp -R /"' \
  1
