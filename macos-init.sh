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
	'vim --with-override-system-vi --with-lua --without-perl' 'zsh' 'kubectl' 'terraform'
	'awscli' 'azure-cli' 'tree'
);

# engineering cask tools
eng_cask=(
	'docker' 'iterm2' 'tunnelblick' 'atom' 'firefox'
);

eng_apm=(
	'git-plus' 'ex-mode' 'markdown-preview-plus' 'markdown-pdf' 'vim-mode-plus'
	'linter-shellcheck' 'terraform-fmt' 'linter-terraform-syntax'
);

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

brew_install() {
	brew install "$@"
	# echo "$@"
}

brew_cask_install() {
	brew cask install "$@"
	# echo "$@"
}

apm_install() {
	apm install "$@"
}

prereq_prep (){
	echo " checking for system prerequisites...."
	if ! command_exists 'brew'; then
	  echo "Info: brew is not installed." >&2
	  echo "Installing HomeBrew package manager.... "
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
	echo " continuing to configure system for $*...."
}

base_install (){
	for app in "${base_cli[@]}"; do
		brew_install "$app"
	done
	for app in "${base_cask[@]}"; do
		brew_install "$app"
	done
}

if [ -z "$1" ]
then
  # echo "Usage:  $0 COMMAND"
	echo "Usage:  macos-init COMMAND"
  echo ""
  echo "macos system initializer"
  echo ""
  echo "Commands:"
  echo "  sales      configure system for sales role"
  echo "  engineer   configure system for engineering role"
  exit $E_ARG_ERR
fi

case $1 in
	sales)
		echo " heck I'm in sales so I don't need all that engineering tools junk!"
		# install base apps
		prereq_prep $1
		base_install
		;;
	engineer)
		echo " time to powerup! gimme all that sweet sweet tool luv!!!"
		# install base apps
		prereq_prep $1
		base_install
		# install engineering apps
		for app in "${eng_cli[@]}"; do
			brew_install "$app"
		done
		for app in "${eng_cask[@]}"; do
			brew_install "$app"
		done
		for app in "${eng_apm[@]}"; do
			apm_install "$app"
		done
		# configure vim with custom vimrc
		if [ ! -f "$HOME/.vimrc" ]; then
			touch "$HOME/.vimrc"
			tee $HOME/.vimrc <<-EOF
			syntax on
			set autoindent
			set expandtab
			set number
			set shiftwidth=2
			set softtabstop=2
			EOF
		fi
		# install oh-my-zsh framework
		curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
		;;
	*)
		echo " hmmm, I don't recognize that role.  you should check the help docs"
		;;
esac
