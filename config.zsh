zle -N dwim
bindkey "^U" dwim

## Import configuration for various transformations
## Order of import may be important, so be careful

## Checks exist to make sure inappropriate transformations aren't
## offered when the zsh-dwim key is pressed

hash apt-get &>/dev/null &&
  source "$_dwim_transform_dir/apt.zsh"

source "$_dwim_transform_dir/cd.zsh"

source "$_dwim_transform_dir/cp.zsh"

source "$_dwim_transform_dir/chmod.zsh"

source "$_dwim_transform_dir/chattr.zsh"

hash dstat &>/dev/null &&
  source "$_dwim_transform_dir/dstat.zsh"

source "$_dwim_transform_dir/echo.zsh"

source "$_dwim_transform_dir/find.zsh"

hash git &>/dev/null &&
  source "$_dwim_transform_dir/git.zsh"

source "$_dwim_transform_dir/ls.zsh"

hash modprobe &>/dev/null &&
  source "$_dwim_transform_dir/modprobe.zsh"

hash mount &>/dev/null &&
  source "$_dwim_transform_dir/mount.zsh"

source "$_dwim_transform_dir/mv.zsh"

hash rsync &>/dev/null &&
  source "$_dwim_transform_dir/rsync.zsh"

source "$_dwim_transform_dir/rm.zsh"

hash ssh &>/dev/null &&
  source "$_dwim_transform_dir/ssh.zsh"

hash service &>/dev/null &&
  source "$_dwim_transform_dir/service.zsh"

source "$_dwim_transform_dir/tar.zsh"

hash wine &>/dev/null &&
  source "$_dwim_transform_dir/wine.zsh"

