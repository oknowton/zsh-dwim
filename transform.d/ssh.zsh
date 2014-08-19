## ssh -> ssh-keygen
_dwim_prepend_transform '^ssh ' \
  'if [[ $BUFFER =~ "^ssh .*[A-Za-z0-9]+@([A-Za-z0-9.]+).*" ]]; then
    _dwim_sed "s/^ssh\s+[A-Za-z0-9]+@([A-Za-z0-9.\-]+).*/ssh-keygen -R \1/"
  else
    _dwim_sed "s/^ssh /ssh-keygen -R /"
  fi' \
  255
  
## scp hostname: -> scp hostname:<newest file>
### Long winded, assuming no zsh on remote side
_dwim_prepend_transform '^scp .+:$' \
  'local HOST
   local FILE
   HOST=$(echo $BUFFER | sed -re "s/^scp (.+):/\1/")
   FILE=$(ssh $HOST "ls -tpb" | grep -v / | head -1)
   BUFFER="$BUFFER\"$FILE\" "'

## ssh hostname -> scp hostname:
_dwim_prepend_transform '^ssh .+' \
  '_dwim_sed "s/^ssh (.+)/scp \1:/"'
  
## scp -> mv 
_dwim_prepend_transform '^scp .+:' \
  '_dwim_sed "s/^scp /mv /"; _dwim_sed "s/ [A-Za-z0-9@\-\.]+:.*//"'

