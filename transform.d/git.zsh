## git clone -> git clone --recursive
_dwim_prepend_transform '^git clone' \
  '_dwim_sed "s/git clone /git clone --recursive /"'

## git rm -> git rm -f (on failure)
_dwim_prepend_transform '^git rm' \
  '_dwim_sed "s/git rm /git rm -f /"' \
  1

## git rm -f -> git rm -rf (on failure)
_dwim_prepend_transform '^git rm -f' \
  '_dwim_sed "s/git rm -f /git rm -rf /"' \
  1
