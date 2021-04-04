#!/bin/bash
set -e

xcode-select --install || true

SRC_DIR=~/Developer/src
DEV_PLAYBOOK_URL=https://github.com/geerlingguy/mac-dev-playbook.git
DEV_PLAYBOOK_PATH=${SRC_DIR}/github.com/geerlingguy/mac-dev-playbook
DOTFILES_URL=https://github.com/h-hirokawa/dotfiles.git
DOTFILES_PATH=${SRC_DIR}/github.com/h-hirokawa/dotfiles
PYTHON_VERSION=$(python3 --version | awk '{sub("\\.[0-9]+$", "", $2); print $2}')

mkdir -p "$DEV_PLAYBOOK_PATH"
git clone "$DEV_PLAYBOOK_URL" "$DEV_PLAYBOOK_PATH" 2> /dev/null \
  || (cd "$DEV_PLAYBOOK_PATH" ; git pull)

mkdir -p "$DOTFILES_PATH"
git clone "$DOTFILES_URL" "$DOTFILES_PATH" 2> /dev/null \
  || (cd "$DOTFILES_PATH" ; git pull)

curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
python3 /tmp/get-pip.py

cd "$DEV_PLAYBOOK_PATH"
python3 -m pip install --user ansible
~/Library/Python/3.8/bin/ansible-galaxy install -r requirements.yml
ln -fs "$DOTFILES_PATH/config.yml" "$DEV_PLAYBOOK_PATH/config.yml"
~/Library/Python/${PYTHON_VERSION}/bin/ansible-playbook main.yml -i inventory --ask-become-pass
