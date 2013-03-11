# zsh-dwim - A "Do What I Mean" Key

`zsh-dwim` attempts to predict what you will want to do next.  It provided a key binding (control-u) that will replace the current (or previous) command line with the command you will want to run next.

## Some examples

 * `apt-cache show zsh` becomes `sudo apt-get install zsh`
 * `tar ft RandomFile.tar.bz2` becomes `tar fx RandomFile.tar.bz2`
 * `sudo service apache stop` becomes `sudo service apache start`
 * `mkdir new_directory` becomes `cd new_directory`
 * If `ssh user@hostwithnewip` fails it becomes `ssh-keygen -R hostwithnewip`
 * If `mkdir more/than/one/path` fails it becomes `mkdir -p more/than/one/path`
 * If `cd /some/path` failes it becomes `mkdir /some/path`

There is a short screencast demonstrating `zsh-dwim` [on my blog](http://blog.patshead.com/2012/10/cleanup-of-zsh-dwim.html).

## Installation

Since I am using [Prezto](https://github.com/sorin-ionescu/prezto) to manage my `zsh` configuration this repository is set up to work with it.  `zsh-dwim` is a simple enough script, though, so it should be easily loaded into any `zsh` configuration.

### Installing under [Prezto](https://github.com/sorin-ionescu/prezto)

    cd .zprezto
    git submodule add https://github.com/oknowton/zsh-dwim.git modules/dwim

Add `dwim` to your `.zpreztorc` file:

    # Set the Prezto modules to load (browse modules).
    # The order matters.
    zstyle ':prezto:load' pmodule \
      'environment' \
      'terminal' \
      'editor' \
      'history' \
      'directory' \
      'spectrum' \
      'utility' \
      'completion' \
      'prompt' \
      'dwim'

### Installing under oh-my-zsh

You should be able to install the `zsh-dwim` script under `oh-my-zsh` with the following command:

    wget https://raw.github.com/oknowton/zsh-dwim/master/init.zsh -O $HOME/.oh-my-zsh/custom/zsh-dwim.zsh

It should start working the next time you open a new shell.

### Installing using [Antigen](https://github.com/zsh-users/antigen)

If you use [Antigen](https://github.com/zsh-users/antigen), I am told that adding the following line to your `.zshrc` will work:

    antigen-bundle oknowton/zsh-dwim
    
### Using `zsh-dwim` anywhere else

Anyone running `zsh` should only need to `source` the `init.zsh` file (run `source init.zsh`).  If you want to permentantly "install" `zsh-dwim` just add the proper `source` command to your `.zshrc`.

## Usage

Type a command and hit `control-u` and `zsh-dwim` will attempt to transform your command.  Typing `control-u` at an empty command prompt will recall the previous command from your history and then attempt to transform it.

## Creating your own transformations

You can add your own transformations by calling the `_dwim_add_transform` function.  This function takes up to three parameters, the third being optional.

    _dwim_add_transform <pattern to match> <code to run> [exit status of previous command]
    
Here's a simple example:

    ## tar ft -> tar fx (a.k.a. list -> extract)
    _dwim_add_transform '^tar (ft|tf)' \
      '_dwim_sed "s/^tar (ft|tf)/tar fx/"'

The `_dwim_sed` function is a little helped function that applies a `sed` regex to the current command.
