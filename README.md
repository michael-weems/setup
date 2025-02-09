# Setup

Configuration files and scripts, .dotfiles, and other odds and ends for setting up my personal developer environment. 

## Usage

To copy all dotfiles, scripts, and configurations from this repo to the proper places on the computer, run the below command. Overwrites whatever existed there before.

```bash
./dev-env # please run with --help first
```

To install applications and setup application specific configurations, like for neovim or ghostty, run the below command.

```bash
./run # please run with --help first
```

### Utility scripts

```bash
# all live under $HOME/.local/scripts/
# all are put on the path for convenient usage
scripts # run this command to list the utility scripts under $HOME/.local/scripts
reload  # run this command to reload the i3 config
headphones  # run this command to connect bluetooth headphones
screen  # run this command to manage monitor setup
```

## Overview

- `.config/` contains config files for various applications (for `./dev-env`)
- `.local/` contains utility scripts for general usage (for `./dev-env`)
- `.*` files at the root are config files to go in the $HOME directory (for `./dev-env`)
- `runs/` contains specific installation instructions for various applications (for `./run`)

## Incidental benefit / pain point

Note that since this does not use symlinks, if you go to modify a script / config file outside of the `setup` repo, it will be overwritten the next time this repo's scripts are run. This is good when you are aware this is the behavior, bad when you are not. In general, change your configs in this repo and then run the scripts to apply them to your computer. If you want to test out changes, you can modify them outside this repo and see how they work - if they don't work the way you want, you can always just re-run these scripts to reset. Just make sure to copy your working test configs back into this repo when you're done!
