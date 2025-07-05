# Setup

Configuration files and scripts, .dotfiles, and other odds and ends for setting up my personal developer environment. 

## Usage

### "One command" from fresh install

```bash
curl -s https://raw.githubusercontent.com/michael-weems/setup/refs/heads/master/remote/fresh-install | bash
```

### From local clone

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
reload  # run this command to reload the hypr + other configs
headphones  # run this command to connect bluetooth headphones
screen  # manage monitor setup
theme   # select a theme to apply
```

## Overview

- `.config/` contains config files for various applications (for `./dev-env`)
- `.local/` contains utility scripts for general usage (for `./dev-env`)
- `home/` contains files to go in the $HOME directory (for `./dev-env`)
- `runs/` contains specific installation instructions for various applications (for `./run`)

## Incidental benefit / pain point

Note that since this does not use symlinks, if you go to modify a script / config file outside of the `setup` repo, it will be overwritten the next time this repo's scripts are run. This is good when you are aware this is the behavior, bad when you are not. In general, change your configs in this repo and then run the scripts to apply them to your computer. If you want to test out changes, you can modify them outside this repo and see how they work - if they don't work the way you want, you can always just re-run these scripts to reset. Just make sure to copy your working test configs back into this repo when you're done!

## Once Setup

### Waybar

- Volume: (+) right-click (-) left-click
- Brightness: scroll to change (I'd prefer click but we'll figure that out another day)

## Links

- [UTF-8 Icons](https://www.nerdfonts.com/cheat-sheet)
    - waybar workspaces icons

## Connect to new network

```bash
iwctl
device list # most likely looking for 'wlan0', will use that in the rest of the example
station wlan0 power on
station wlan0 get-networks # to find the network SSID to connect to
station wlan0 connect <SSID> # if you already k
exit
```
