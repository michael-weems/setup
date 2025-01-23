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

## Overview

- `.config/` contains config files for various applications (for `./dev-env`)
- `.local/` contains utility scripts for general usage (for `./dev-env`)
- `.*` files at the root are config files to go in the $HOME directory (for `./dev-env`)
- `runs/` contains specific installation instructions for various applications (for `./run`)

