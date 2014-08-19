## mkdir -> mkdir -p (on failure)
_dwim_prepend_transform '^mkdir (-p){0}' \
  '_dwim_sed "s/mkdir /mkdir -p /"' \
  1

## mkdir -p -> cd
_dwim_prepend_transform '^mkdir -p' \
  '_dwim_sed "s/mkdir -p /cd /"'
  
## mkdir -> cd
_dwim_prepend_transform '^mkdir ' \
  '_dwim_sed "s/^mkdir /cd /"'

## cd -> mkdir on failure
_dwim_prepend_transform '^cd ' \
  '_dwim_sed "s/cd /mkdir /"' \
  1
  
