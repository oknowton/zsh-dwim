zle -N dwim
bindkey "^U" dwim

## Import configuration for various transformations
## Order of import may be important, so be careful

## Checks exist to make sure inappropriate transformations aren't
## offered when the zsh-dwim key is pressed

[[ -e "$(which apt-get)" ]] &&
  source "$_dwim_transform_dir/apt.zsh"

source "$_dwim_transform_dir/cd.zsh"

[[ -e "$(which dstat)" ]] &&
  source "$_dwim_transform_dir/dstat.zsh"

source "$_dwim_transform_dir/echo.zsh"

source "$_dwim_transform_dir/find.zsh"

source "$_dwim_transform_dir/ls.zsh"

[[ -e "$(which modprobe)" ]] &&
  source "$_dwim_transform_dir/modprobe.zsh"

[[ -e "$(which mount)" ]] &&
  source "$_dwim_transform_dir/mount.zsh"

[[ -e "$(which rsync)" ]] &&
  source "$_dwim_transform_dir/rsync.zsh"

[[ -e "$(which ssh)" ]] &&
  source "$_dwim_transform_dir/ssh.zsh"

[[ -e "$(which service)" ]] &&
  source "$_dwim_transform_dir/service.zsh"

source "$_dwim_transform_dir/tar.zsh"

[[ -e "$(which wine)" ]] &&
  source "$_dwim_transform_dir/wine.zsh"

