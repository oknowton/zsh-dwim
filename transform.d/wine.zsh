## wine -> WINDEBUG="-all" wine
_dwim_prepend_transform '^wine ' \
  '_dwim_sed "s/^wine /WINEDEBUG=\"-all\" wine /"'

