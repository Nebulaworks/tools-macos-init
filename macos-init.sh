#!/bin/bash
# shellcheck disable=SC2068
###
# title             : NWI MacOS bootstrapper
# file              : shell script
# created           : 2017-11
# modified          : ----------
# www-site          : http://www.nebulaworks.com
# description       : Nebulaworks Mac OS configuration script
# executor-version  : bash
###

###
# Nebulaworks Mac OS configuration script
# run script in terminal as standard user
###

set -e

###
# Common tool source list for base systems
###

# base common cask tools
base_cask=(
	'slack' 'google-drive-file-stream' 'google-chrome' '1password' 'zoomus' 'quip' 'encryptme' 'microsoft-office'
);

# marketing cask tools
mrkt_cask=(
	'adobe-creative-cloud'
);

# sales cask tools
sales_cask=(
	'dialpad'
);

###
# Engineering tool source list for base systems
###

# engineering cli tools
eng_cli=(
    'awscli' 'azure-cli' 'bash' 'ccat' 'coreutils' 'diffutils'
    'ed' 'file-formula' 'findutils'
    'gawk' 'git' 'git-lfs' 'gnu-indent'
    'gnu-sed' 'gnu-tar'
    'gnu-which' 'gnutls' 'graphviz'
    'grep' 'gzip' 'htop-osx' 'httpie' 'jq' 'kubectl'
    'less' 'make' 'most' 'nmap' 'openssh' 'rsync' 'shellcheck' 'stow'
    'terraform' 'the_silver_searcher' 'tmux' 'tree' 'unzip'
    'vim' 'watch'
    'wdiff' 'wget' 'zsh'
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
	brew install $@
	# echo "$@"
}

brew_cask_install() {
	brew cask install $@
	# echo "$@"
}

apm_install() {
	apm install $@
}

prereq_prep (){
	echo " checking for system prerequisites...."
	if ! command_exists 'brew'; then
	  echo "Info: brew is not installed." >&2
	  echo "Installing HomeBrew package manager.... "
		printf '\n' | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
	echo " continuing to configure system for $*...."
}

base_install (){
	for app in "${base_cask[@]}"; do
		brew_cask_install "$app"
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
  echo "  sales      configure system for a sales role"
  echo "  marketing  configure system for a marketing role"
  echo "  engineer   configure system for an engineering role"
  exit $E_ARG_ERR
fi

case $1 in
	sales)
		echo " heck I'm in sales so I don't need all that engineering tools junk!"
		# install base apps
		prereq_prep $1
		base_install
		# install sales apps
		for app in "${sales_cask[@]}"; do
			brew_cask_install "$app"
		done
		;;
	marketing)
		echo " I'm better than sales so I need a few other tools!"
		# install base apps
		prereq_prep $1
		base_install
		# install marketing apps
		for app in "${mrkt_cask[@]}"; do
			brew_cask_install "$app"
		done
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
			brew_cask_install "$app"
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
