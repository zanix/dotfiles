# dotfiles

This repository contains my personal configuration files and scripts for optimizing my development environment. Includes settings for Zsh, Tmux, Vim, and more.

![Terminal Preview](terminal.png)

## Usage

Install required depenencies on your system.

Arch

```shell
sudo pacman -Sy git stow zsh ifstat bat yq
```

```shell
yay oh-my-posh-bin
```

Ubuntu/Debian

```shell
sudo apt install git stow zsh ifstat bat yq
```

```shell
curl -s https://ohmyposh.dev/install.sh | sudo bash -s -- -d ~/usr/local/bin
```

> I have oh-my-posh installed globally

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
stow .
```

Dotfiles are now ready to use.

## Software Info

- [Zinit](https://github.com/zdharma-continuum/zinit) - Flexible and fast ZSH plugin manager.
- [Oh My Posh](https://ohmyposh.dev) - A prompt theme engine for any shell.
- [Nerd Fonts](https://www.nerdfonts.com) - Patched fonts with glyphs (icons).
- [tmux-powerline](https://github.com/erikw/tmux-powerline) - Status bar consisting of dynamic & beautiful looking powerline segments, written purely in bash.
- [bat](https://github.com/sharkdp/bat) - A cat(1) clone with wings.

### VIM

I use the [Ultimate Vim Configuration](https://github.com/amix/vimrc)

> I use the [Install for multiple users](https://github.com/amix/vimrc#install-for-multiple-users) option

After setting this up, it automatically places a `.vimrc` file into my profile. Then I copy my custom config into the `vim_runtime` directory.

```shell
sudo cp ~/dotfiles/my_configs.vim /opt/vim_runtime/
```

## Inspiration

I used these dotfile repos as a start to create my own.

- [dreamsofcode-io](https://github.com/dreamsofcode-io/dotfiles)
- [codeopshq](https://github.com/codeopshq/dotfiles)

## Contributing

If you have any suggestions or find any bugs, please open an issue or pull request on GitHub.
