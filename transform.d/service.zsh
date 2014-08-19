## service <> stop -> service <> start
_dwim_prepend_transform '^sudo (service |\/etc\/init.d\/)[a-zA-Z0-9]+ stop' \
  '_dwim_sed "s/stop/start/"'

## service <> start -> service <> stop
_dwim_prepend_transform '^sudo (service |\/etc\/init.d\/)[a-zA-Z0-9]+ start' \
  '_dwim_sed "s/start/stop/"'

