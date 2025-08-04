# dotfiles

This repository contains my personal configuration files and scripts for optimizing my development environment. Includes settings for Zsh, Tmux, Vim, and more.

![Terminal Preview](terminal.png)

## Software

### Shell (Linux)

- [ZSH](https://zsh.sourceforge.io)
- [Zinit](https://github.com/zdharma-continuum/zinit) - Flexible and fast ZSH plugin manager
- [Oh My Posh](https://ohmyposh.dev) - A prompt theme engine for any shell
- [Nerd Fonts](https://www.nerdfonts.com) - Patched fonts with glyphs (icons)
- [fzf](https://github.com/junegunn/fzf) - Interactive filtering

### Tmux

- Tmux >= **1.9**
- [Tmux plugin manager](https://github.com/tmux-plugins/tpm) - Installs and loads `tmux` plugins
- [tokyo-night-tmux](https://github.com/janoamaral/tokyo-night-tmux) - A clean, dark Tmux theme and status bar that celebrates the lights of Downtown Tokyo at night.

### Neovim

- [Neovim](https://github.com/neovim/neovim) >= **0.10.0** (needs to be built with **LuaJIT**)
- Git >= **2.19.0**
- [LazyVim](https://www.lazyvim.org)
- a **C** compiler for `nvim-treesitter`. See [requirements](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
- for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) **_(optional)_**
  - **find files**: [fd](https://github.com/sharkdp/fd)
- a terminal that supports true color and _undercurl_: (I use Ghostty)
  - [Ghostty](https://github.com/ghostty-org/ghostty) **_(Linux & MacOS)_**
    - [config tool](https://ghostty.zerebos.com)
  - [kitty](https://github.com/kovidgoyal/kitty) **_(Linux & MacOS)_**
  - [wezterm](https://github.com/wez/wezterm) **_(Linux, MacOS & Windows)_**
  - [alacritty](https://github.com/alacritty/alacritty) **_(Linux, MacOS & Windows)_**
  - [iterm2](https://iterm2.com) **_(MacOS)_**

### Vim

A `.vimrc` configuration is available for systems where NeoVim is not available.

#### Ultimate Vim Configuration

> [!NOTE]
> I use this for systems where I haven't updated to Neovim yet

I use the [Ultimate Vim Configuration](https://github.com/amix/vimrc) for a quick and decent setup

> [!IMPORTANT]
> I use the [Install for multiple users](https://github.com/amix/vimrc#install-for-multiple-users) option

After setting this up, it automatically places a `.vimrc` file into my profile. Then I copy my custom config into the `vim_runtime` directory.

```shell
sudo cp ~/dotfiles/my_configs.vim /opt/vim_runtime/
```

### Others

- [bat](https://github.com/sharkdp/bat) - A cat(1) clone with wings
- [Btop](https://github.com/aristocratos/btop) - A monitor of resources
- [eza](https://github.com/eza-community/eza) - A modern alternative to ls
- [Fastfetch](https://github.com/fastfetch-cli/fastfetch) - A maintained, feature-rich and performance oriented, neofetch like system information tool
- [Lazydocker](https://github.com/jesseduffield/lazydocker) - The lazier way to manage everything docker
- [Lazygit](https://github.com/jesseduffield/lazygit) - A simple terminal UI for git commands
- [nvm](https://github.com/nvm-sh/nvm) - Node Version Manager - POSIX-compliant bash script to manage multiple active node.js versions
- [phpenv](https://github.com/phpenv/phpenv) - Simple PHP version management
  - [php-build](https://github.com/php-build/php-build) - Builds PHP so that multiple versions can be used side by side
- [zoxide](https://github.com/ajeetdsouza/zoxide) - A smarter cd command. Supports all major shells.

## Requirements

Install dependencies on your system.

### Arch

```shell
sudo pacman -Sy fd fzf git neovim stow tmux wl-clipboard yq zsh
```

Install `ifstat` and `oh-my-posh` from the AUR

```shell
yay ifstat oh-my-posh-bin
```

#### Optional Arch packages

```shell
sudo pacman -Sy bat btop chafa eza fastfetch lazydocker lazygit
```

### Ubuntu/Debian

> [!WARNING]
> The default behavior for Zsh in Ubuntu is to initialize `compinit` for every session.
> This causes the prompt to load very slowly unless it is disabled.
> The `.zshenv` file with the `skip_global_compinit=1` fixes this.

```shell
sudo apt install fd-find git ifstat python3-venv stow tmux wl-clipboard zsh
```

Install fzf via git

```shell
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --no-fish --no-update-rc
```

Neovim needs to be installed via the appimage package

```shell
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
```

Install for all users or for the current user

```shell
mv nvim-linux-x86_64.appimage ~/.local/bin/nvim
```

```shell
mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
```

`yq` needs to be installed manually

```shell
wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq && chmod +x /usr/local/bin/yq
```

Install `oh-my-posh` using the official install script

Install for all users or for the current user

```shell
curl -s https://ohmyposh.dev/install.sh | sudo bash -s -- -d /usr/local/bin
```

```shell
curl -s https://ohmyposh.dev/install.sh | bash -s
```

#### Optional Ubuntu Packages

```shell
sudo apt install bat btop chafa
```

> [!NOTE]
> `btop` needs to be installed via snap on Ubuntu 22.04 and older

```shell
sudo snap install btop
```

`eza` needs to be installed via ppa

```shell
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza
```

Or manually

```shell
wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar xz
sudo chmod +x eza
sudo chown root:root eza
sudo mv eza /usr/local/bin/eza
```

`fastfetch` needs to be installed via ppa

```shell
add-apt-repository -y ppa:zhangsongcui3371/fastfetch
```

```shell
sudo apt install fastfetch
```

`lazydocker` needs to be installed manually

```shell
DIR=/usr/local/bin/
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | sudo bash
```

`lazygit` needs to be installed manually

```shell
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
```

### Other Software

#### Node Version Manager

Node Version Manager - POSIX-compliant bash script to manage multiple active node.js versions

> [!IMPORTANT]
> Node is required for Mason in Nvim, and NVM is how I install Node

```shell
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
```

Install default version of node

```shell
nvm install node
```

#### PHPEnv

PHP multi-version installation and management for humans

> [!NOTE]
> This is optional and only needed for PHP development

```shell
git clone https://github.com/phpenv/phpenv.git ~/.phpenv
```

> Path and init are in `~/.zshrc` when `~/.phpenv` directory exists

Add php-build

```shell
git clone https://github.com/php-build/php-build $(phpenv root)/plugins/php-build
```

Install required php version

```shell
phpenv install <php-version>
```

Rebuild php shim binaries after installing a new php version

```shell
phpenv rehash
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
stow .
```

Set the default shell to ZSH

```shell
chsh -s $(which zsh)
```

Change shell now

```shell
zsh
```

Or logout, log back in to launch zsh

Dotfiles are now ready to use.

## Inspiration

I used these dotfile repos as a start to create my own.

- [dreamsofcode-io](https://github.com/dreamsofcode-io/dotfiles)
- [codeopshq](https://github.com/codeopshq/dotfiles)
- [craftzdog](https://github.com/craftzdog/dotfiles-public)

## Contributing

If you have any suggestions or find any bugs, please open an issue or pull request on GitHub.
