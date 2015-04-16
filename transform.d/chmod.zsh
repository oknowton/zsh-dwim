## chmod failure -> sudo chmod
_dwim_prepend_transform '^chmod.*\+' \
  '_dwim_sed "s/chmod/sudo chmod/"' \
  1

## chmod - -> +
_dwim_prepend_transform '^chmod.*-' \
  '_dwim_sed "s/([ ugo]+)-([rwxXst]+)/\1+\2/g"'

## chmod + -> -
_dwim_prepend_transform '^chmod.*\+' \
  '_dwim_sed "s/([ ugo]+)\+([rwxXst]+)/\1-\2/g"'

## sudo chmod - -> +
_dwim_prepend_transform '^sudo chmod.*-' \
  '_dwim_sed "s/([ ugo]+)-([rwxXst]+)/\1+\2/g"'

## sudo chmod + -> -
_dwim_prepend_transform '^sudo chmod.*\+' \
  '_dwim_sed "s/([ ugo]+)\+([rwxXst]+)/\1-\2/g"'


