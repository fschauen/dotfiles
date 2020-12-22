# Prerequisites

Only [ansible][] is required for installing the dotfiles.

_NOTE:_ [git-crypt][] and [gpg][] are needed to decrypt sensitive information
in the repository, but these are installed by the [ansible
playbook](local.yml).

[ansible]: https://www.ansible.com
[git-crypt]: https://github.com/AGWA/git-crypt
[gpg]: https://gnupg.org

## Install ansible on Linux

```bash
sudo apt install -y python3
pyhton3 -m pip install ansible
```

## Install ansible on macOS

```bash
brew install ansible
```

# Installation

Steps:
1. Create an SSH key with (e.g. with
   `ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)"`) and register it.
1. Add a preliminary `~/.ssh/config` to reach `git.schauenburg.me` at the correct port.
1. Clone the repo.
1. Play the `local.yml` ansible playbook.
1. Decrypt key & initialize git-crypt to access sensitive data.


Gimme the code:
```bash
ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)"
echo -e "Host git.schauenburg.me\nUser git\nPort 587" >>~/.ssh/config
git clone git@git.schauenburg.me:fernando/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
ansible-playbook local.yml
gpg -d --output - <(base64 -d .key) | git crypt unlock -
```

