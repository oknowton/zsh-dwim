# zsh-dwim - A "Do What I Mean" Key

`zsh-dwim` attempts to predict what you will want to do next.  It provided a key binding (control-u) that will replace the current (or previous) command line with the command you will want to run next.

## Some Examples

 * `apt-cache show zsh` becomes `sudo apt-get install zsh`
 * `tar ft RandomFile.tar.bz2` becomes `tar fx RandomFile.tar.bz2`
 * `ssh user@hostwithnewip` becomes `ssh-keygen -R hostwithnewip`

## No more Perl helper

The Perl helper has been ported to zsh+sed.  All the transformations have been moved out of big 'spaghetti if' into a hash.  This will make it easy to add your own custom transformations without needing to modify the original source.

## Installation

So far it only "supports" [zprezto][https://github.com/sorin-ionescu/prezto].  It is really simple, though.  I'm sure it can easily be made to work just about anywhere.

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

## Usage

Type a command and hit `control-u` and `zsh-dwim` will attempt to transform your command.  Typing `control-u` at an empty command prompt will recall the previous command from your history and then attempt to transform it.
