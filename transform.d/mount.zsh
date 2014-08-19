## mount -> umount
_dwim_prepend_transform '^sudo mount' \
  '_dwim_sed "s/^sudo mount/sudo umount/"'
  
## umount -> mount
_dwim_prepend_transform '^sudo umount' \
  '_dwim_sed "s/^sudo umount/sudo mount/"'

