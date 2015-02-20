## chattr - -> +
_dwim_prepend_transform '^chattr.*-' \
  '_dwim_sed "s/-([acdeijstuACDST]+)/+\1/g"'

## chattr + -> =
_dwim_prepend_transform '^chattr.*+' \
  '_dwim_sed "s/\+([acdeijstuACDST]+)/=\1/g"'

## chattr = -> -
_dwim_prepend_transform '^chattr.*+' \
  '_dwim_sed "s/=([acdeijstuACDST]+)/-\1/g"'
