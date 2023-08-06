# @jaredallard does dotfiles

These are my dotfiles. There are many like them, but these are mine. My dotfiles
are my best friend. They are my life. I must master them as I must master my
life. My dotfiles, without me, are useless. Without my dotfiles, I am useless.

![make it yours](http://i.giphy.com/Vc5x1pG5RFH3O.gif)

## Install

**Note**: The below script will install chezmoi temporarily, and then remove it.
This is to make it easier to install the dotfiles the post-install script will
permanently install it later.

```bash
bash -c "$(curl -fsLS https://raw.githubusercontent.com/jaredallard/dotfiles/main/setup.sh)"
```

### Remote Tunnel (VSCode)

**Status**: `Alpha` (not all volume mounts have been configured)

Run `create-tunnel-host.sh` to create a VSCode tunnel with these
dotfiles on your current machine. This will be accessible at
[vscode.dev/tunnel/<hostname>](https://vscode.dev/tunnel).

**Note**: Make sure to look at the container logs on the first run. This
will contain a Github device token you'll need to exchange for Github
credentials through the provided link. Once this has been done, you
won't need to do it again!

## Customization

There are a few ways to customize the dotfiles. You can add files into the following directories:

* `$DOTFILES_HOME/zshrc.d/`:
  * `pre-zgenom-load/` - Files in this directory will be sourced before zgenom is loaded.
  * `post-zgenom-load/` - Files in this directory will be sourced after zgenom is loaded.

### zgenom plugins

You can load zgenom plugins by adding them to `~/.local/share/dotfiles/config`.

Example:

```bash
# ~/.local/share/dotfiles/config
EXTRA_ZGENOM_PLUGINS=(
  "zsh-users/zsh-autosuggestions"
  "zsh-users/zsh-syntax-highlighting"
)

# Load extensions from a git repo. These support the same paths as described
# in "Customization" above.
EXTRA_EXTENSION_REPOS=(
  "your-git-repo-url-here"
)
```

## License

GPL-3.0
