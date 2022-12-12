# My dotfiles

Always evolving...

## Quick Start

```bash
git clone https://git.schauenburg.me/fernando/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
gpg -d --output - <(base64 -d .key) | git crypt unlock -
./install.sh
```
## Prerequisites

[git-crypt][] and [gpg][] are needed to decrypt sensitive information
in the repository.

[git-crypt]: https://github.com/AGWA/git-crypt
[gpg]: https://gnupg.org

