# Dotfiles

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io/).

## What's tracked

| File | Description |
|------|-------------|
| `.bashrc` | Bash shell config |
| `.zshrc` | Zsh shell config |
| `.vimrc` | Vim editor config |
| `.gitconfig` | Git configuration |
| `.config/tmux/tmux.conf` | Tmux (minimal, plugin-free, Nord theme) |
| `.config/alacritty/alacritty.toml` | Alacritty terminal (optimized for Intel HD 2000) |
| `.config/nvim/init.lua` | Neovim config |
| `.config/claude/CLAUDE.md` | Claude Code instructions |
| `.config/htop/htoprc` | htop process monitor |
| `.config/btop/btop.conf` | btop process monitor |
| `.config/cmus/rc` | cmus music player |
| `.config/flameshot/flameshot.ini` | Flameshot screenshot tool |
| `.config/copyq/copyq.conf` | CopyQ clipboard manager |
| `Nextcloud/.sync-exclude.lst` | Nextcloud sync exclusions |

## Setup on a new machine

```bash
# Install chezmoi
brew install chezmoi   # or: sh -c "$(curl -fsLS chezmoi.io/l)"

# Apply dotfiles
chezmoi init --apply git@github.com:wojtek108/dotfiles.git
```

## Secrets

Secrets are encrypted with GPG. Encrypted files are stored with the `encrypted_` prefix in the source repo.

To add a secret:
```bash
chezmoi add --template ~/.some-secret-file
# or encrypt an existing file:
chezmoi encrypt ~/.secret-file
```

## Structure

```
~/.local/share/chezmoi/     # Source state (this repo)
~/.config/chezmoi/           # chezmoi config (chezmoi.toml)
```

## License

Personal use.
