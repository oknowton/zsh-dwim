## apt-cache search -> sudo apt-get install
_dwim_prepend_transform '^apt-cache (search|show)' \
  '_dwim_sed "s/^apt-cache (search|show)/sudo apt-get install/"'

## sudo apt-get update -> sudo apt-get upgrade
_dwim_prepend_transform '^sudo apt-get update' \
  '_dwim_sed "s/^sudo apt-get update/sudo apt-get upgrade/"'

## failed dpkg --install -> apt-get -f install
_dwim_prepend_transform '^sudo dpkg --install' \
  'BUFFER="sudo apt-get -f install"' \
  1
  
_dwim_prepend_transform '^which ' \
  'BUFFER="dpkg -S \$(/usr/bin/$BUFFER)"'

_dwim_prepend_transform '^dpkg -S ' \
  'BUFFER="apt-cache show \$($BUFFER | cut -d : -f 1 )"'

_dwim_prepend_transform '^sudo add-apt-repository' \
  'BUFFER="sudo apt-get update"
     _dwim_cursor=$#BUFFER'
_dwim_prepend_transform '^add-apt-repository' \
  'BUFFER="sudo $BUFFER"'
