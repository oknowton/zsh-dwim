## rm -> rm -f (on failure)
_dwim_add_transform '^rm' \
  '_dwim_sed "s/^rm /rm -f /"' \
  1

## rm -f -> rm -rf (on failure)
_dwim_add_transform '^rm -f' \
  '_dwim_sed "s/^rm -f /rm -rf /"' \
  1

## rm -rf -> sudo rm -rf (on failure)
_dwim_add_transform '^rm -rf' \
  '_dwim_sed "s/^rm -rf /sudo rm -rf /"' \
  1

## rmdir -> rm -rf (on failure)
_dwim_add_transform '^rmdir ' \
  '_dwim_sed "s/^rmdir /rm -rf /"' \
  1
