#!/bin/bash

###
# title             : NWI MacOS bootstrapper
# file              : shell script
# created           : 2017-11
# modified          : ----------
# www-site          : http://www.nebulaworks.com
# description       : Nebulaworks Mac OS configuration script
# 										run script in terminal as standard user
# executor-version  : bash
###

###
# Nebulaworks Mac OS configuration script
# run script in terminal as a priviliged user
###

set -e

###
# Common tool source list for base systems
###

# base conmmon cli tools
base_cli=(
	'coreutils' 'diffutils' 'gnu-indent --with-default-names' 'gnu-sed --with-default-names'
	'gnu-tar --with-default-names' 'gnu-which --with-default-names' 'ed --with-default-names'
	'findutils --with-default-names' 'grep --with-default-names' 'wdiff --with-gettext'
	'ccat' 'gawk' 'gnutls' 'gzip' 'unzip' 'watch' 'wget' 'bash' 'less' 'most' 'make'
	'git'
);

# base common cask tools
base_cask=(
	'slack' 'google-drive-file-stream' 'google-chrome' '1password' 'zoom'
);

###
# Engineering tool source list for base systems
###

# engineering cli tools
eng_cli=(
	'shellcheck' 'file-formula' 'rsync' 'jq' 'httpie' 'htop-osx' 'nmap' 'tmux' 'openssh'
	'vim --with-override-system-vi --with-lua --without-perl' 'zsh' 'kubectl' 'awscli'
);

# engineering cask tools
eng_cask=(
	'docker' 'iterm2' 'tunnelblick' 'atom' 'firefox'
);

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

brew_install() {
	brew install "$@"
}

brew_cask_install() {
	brew cask install "$@"
}

prereq_prep (){
	echo " checking for system prerequisites...."
	if ! command_exists 'brew'; then
	  echo "Info: brew is not installed." >&2
	  echo "Installing HomeBrew package manager.... "
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
	echo " continuing to configure system for $@...."
}

# install oh-my-zsh framework
# curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh


#custom vimrc

# sudo -u ubuntu tee /home/ubuntu/.vimrc <<SQRL
# syntax on
# set autoindent
# set expandtab
# set number
# set shiftwidth=2
# set softtabstop=2
# SQRL
if [ -z "$1" ]
then
  echo "Usage:  $0 COMMAND"
  echo ""
  echo "minikube installer"
  echo ""
  echo "Commands:"
  echo "  engineer   installs the minikube software stack"
  echo "  sales      uninstalls the minikuve software stack"
  exit $E_ARG_ERR
fi

prereq_prep $1
