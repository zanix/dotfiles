# dotfiles

This repository contains my personal configuration files and scripts for optimizing my development environment. Includes settings for Bash, Vim, ZSH, Tmux, and more.

## Usage

Install Git, Stow, and Zsh on your system.

Arch

```shell
sudo pacman -Sy git stow zsh
```

Ubuntu/Debian

```shell
sudo apt install git stow zsh
```

## Installation

Clone this repository.

```shell
git clone https://github.com/zanix/dotfiles.git
```

Once cloned, navigate to the desired directory.

```shell
cd dotfiles
```

Run `stow` to install the dotfiles.

```shell
stow ~/dotfiles
```

Dotfiles are now ready to use.

## Contributing

If you have any suggestions or find any bugs, please open an issue or pull request on GitHub.
