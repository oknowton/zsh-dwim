## cat /proc/sys/* or /sys/* -> echo _ | sudo tee /proc/sys/*
_dwim_prepend_transform '^cat ' \
   'if [[ $PWD =~ "(/proc/sys/|/sys/)" ]]; then
      _dwim_sed "s/cat (.*)/echo  | sudo tee \1/"
    else
      _dwim_sed "s/cat ((\/proc)?\/sys\/.*)/echo  | sudo tee \1/"
    fi
    _dwim_cursor=5'

## echo _ > -> echo _ | sudo tee 
_dwim_prepend_transform '^echo.*\> ' \
   '_dwim_sed "s/>/|sudo tee /"'
  
