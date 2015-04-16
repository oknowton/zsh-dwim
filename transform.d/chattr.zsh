## chmattr failure -> sudo chattr
_dwim_prepend_transform '^chattr.*\+' \
  '_dwim_sed "s/chattr/sudo chattr/"' \
  1

## chattr - -> +
_dwim_prepend_transform '^chattr.*-' \
  '_dwim_sed "s/-([acdeijstuACDST]+)/+\1/g"'

## chattr + -> =
_dwim_prepend_transform '^chattr.*\+' \
  '_dwim_sed "s/\+([acdeijstuACDST]+)/=\1/g"'

## chattr = -> -
_dwim_prepend_transform '^chattr.*\=' \
  '_dwim_sed "s/=([acdeijstuACDST]+)/-\1/g"'

## sudo chattr - -> +
_dwim_prepend_transform '^sudo chattr.*-' \
  '_dwim_sed "s/-([acdeijstuACDST]+)/+\1/g"'

## sudo chattr + -> =
_dwim_prepend_transform '^sudo chattr.*\+' \
  '_dwim_sed "s/\+([acdeijstuACDST]+)/=\1/g"'

## sudo chattr = -> -
_dwim_prepend_transform '^sudo chattr.*\+' \
  '_dwim_sed "s/=([acdeijstuACDST]+)/-\1/g"'
