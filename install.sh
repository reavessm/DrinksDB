#!/bin/sh

if ! [ $(id -u) = 0 ]
then
  echo "This script must be run as root"
  exit 1
fi

pkg="bash sqlite3"

if [ -n "$(which dnf)" ]
then
  echo Using DNF
  dnf install -y $pkg
fi

if [ -n "$(which apt)" ]
then
  echo Using APT
  apt install -y $pkg
fi

if [ -n "$(which yaourt)" ]
then
  echo Using YAOURT
  yaourt -Syi $pkg
fi

if [ -n "$(which pacman)" ]
then
  echo Using pacman
  pacman -Syi $pkg
fi

if [ -f "drinkdb.sh" ]
then
  chmod +x drinkdb.sh
fi
