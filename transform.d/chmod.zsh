## chmod - -> +
_dwim_prepend_transform '^chmod.*-' \
  '_dwim_sed "s/([ ugo]+)-([rwxXst]+)/\1+\2/"'

## chmod + -> -
_dwim_prepend_transform '^chmod.*+' \
  '_dwim_sed "s/([ ugo]+)\+([rwxXst]+)/\1-\2/"'


