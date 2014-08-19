## vmstat -> dstat -f -> vmstat
_dwim_prepend_transform '^vmstat' \
  '_dwim_sed "s/^vmstat/dstat -f/"'

_dwim_prepend_transform '^dstat -f' \
  '_dwim_sed "s/^dstat -f/vmstat/"'

