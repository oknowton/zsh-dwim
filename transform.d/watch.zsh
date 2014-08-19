## watch -> watch -n 10 -> watch -n 30
_dwim_prepend_transform '^(sudo watch |watch )-n 10' \
  '_dwim_sed "s/ -n 10/ -n 30/"'

_dwim_prepend_transform '^(sudo watch |watch )-n 30' \
  '_dwim_sed "s/ -n 30//"'

_dwim_prepend_transform '^(sudo watch |watch )' \
  '_dwim_sed "s/watch/watch -n 10/"'

