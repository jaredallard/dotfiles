# @jaredallard does dotfiles

These are my dotfiles. There are many like them, but these are mine. My dotfiles
are my best friend. They are my life. I must master them as I must master my
life. My dotfiles, without me, are useless. Without my dotfiles, I am useless.

![make it yours](http://i.giphy.com/Vc5x1pG5RFH3O.gif)

## Install

**Note**: The below script will install the 1Password CLI and chezmoi temporarily, and
then remove them. This is to make it easier to install the dotfiles, chezmoi and
the post-install script will permanently install them later.

```
bash -c "$(curl -fsLS https://raw.githubusercontent.com/jaredallard/dotfiles/main/setup.sh)"
```

### WSL2

Sadly I haven't automated the following:

```bash
# Fixes git signing
sudo ln -s /mnt/c/Users/<user>/AppData/Local/1Password/app/8/op-ssh-sign.exe /usr/local/bin/op-ssh-sign

# ssh-agent
# Do the stuff here: https://github.com/albertony/npiperelay
# For PATH, put it in the bad place :wink:
```

## License

GPL-3.0 
