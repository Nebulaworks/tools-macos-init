#!/bin/bash

#if (( EUID != 0 )); then
#   echo "You must be root to properly run this script." 1>&2
#   exit 100
#fi

list="cat dog fish"

if [ -z "$1" ]
then
  echo "Usage:  $0 COMMAND"
  echo ""
  echo "minikube installer"
  echo ""
  echo "Commands:"
  echo "  install     installs the minikube software stack"
  echo "  cleanup     uninstalls the minikuve software stack"
  exit $E_ARG_ERR
fi

for l in $list; do
	echo $l
done


fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

fancy_echo "this is my message"

app=('coreutils'
		'diffutils'
		'gnu-indent --with-default-names'
		'gnu-sed --with-default-names'
		'gnu-tar --with-default-names'
		'gnu-which --with-default-names'
		'ed --with-default-names'
		'findutils --with-default-names'
		'grep --with-default-names'
		'wdiff --with-gettext'
		'ccat'
		'gawk');

for a in "${app[@]}"; do
	echo $a
done

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

brew_install() {
	brew info "$@"
}

if ! command_exists "it"; then
	echo 'no brew here'
else
	echo 'Yay! you can brew'
fi

# for a in "${app[@]}"; do
# 	brew_install "$a"
# done
