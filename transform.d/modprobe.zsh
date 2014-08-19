## modprobe -> modprobe -r -> modprobe
_dwim_prepend_transform '^(sudo modprobe |modprobe )-r' \
  '_dwim_sed "s/ -r//"'

_dwim_prepend_transform '^(sudo modprobe |modprobe )' \
  '_dwim_sed "s/modprobe/modprobe -r/"'

