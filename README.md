# Prerequisites

* [ansible][]: for installing the dofiles.
* [git-crypt][]: for handling sensitive data in the repo
  _(installed via ansible cookbook)_.
* [gpg][]: for decrypting the key used by `git-crypt` 
  _(installed via ansible cookbook)_.

# Installation

Steps:
1. Install [ansible][].
1. Create an SSH key with (e.g. with
   `ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)"`) and register it.
1. Clone the repo.
1. Play the `dotfiles.yml` ansible playbook.
1. Decrypt key & initialize git-crypt to access sensitive data.

Cookbook:
```bash
sudo apt-get install ansible
git clone git@git.schauenburg.me:fernando/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
ansible-playbook -i hosts.ini dotfiles.yml
gpg -d --output - <(base64 -d .key) | git crypt unlock -
```

[ansible]: https://www.ansible.com
[git-crypt]: https://github.com/AGWA/git-crypt
[gpg]: https://gnupg.org

