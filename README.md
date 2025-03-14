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

## VIM

I use the [Ultimate Vim Configuration](https://github.com/amix/vimrc)

After setting this up (installed globally), it automatically places a `.vimrc` file into my profile. Then I copy my custom config into the `vim_runtime` directory.

```shell
sudo cp ~/dotfiles/my_configs.vim /opt/vim_runtime/
```

## Contributing

If you have any suggestions or find any bugs, please open an issue or pull request on GitHub.
