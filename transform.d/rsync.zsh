## rsync -> rsync -aHAXS -> rsync -axHAXS
_dwim_prepend_transform '^rsync -aHAXS' \
  '_dwim_sed "s/^rsync -aHAXS/rsync -axHAXS/"'

_dwim_prepend_transform '^rsync -axHAXS' \
  '_dwim_sed "s/^rsync -axHAXS/rsync/"'

_dwim_prepend_transform '^rsync ' \
  '_dwim_sed "s/^rsync /rsync -aHAXS /"'
