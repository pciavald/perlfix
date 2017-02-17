#!/bin/sh

# get the list of used locales
_LANGUAGES=`perl -e exit 2>&1 | grep UTF-8 | sed 's/.*"\(.*\)".*/\1/g' | sort | uniq`

# get the user's locale
_LOCALE=`perl -e exit 2>&1 | grep UTF-8 | sed 's/.*"\(.*\)".*/\1/g' | sort | uniq | grep -v "en_US.UTF-8"`

# construct env variables
_BASHRC=`perl -e exit 2>&1 | grep unset | sed "s/(.*)/\"$_LOCALE\"/" | sed "s/[ ,]//g" | sed "s/\"/\'/g"`

# set env variables in bashrc if not existing
for i in $_BASHRC
do
	if ! cat ~/.bashrc | grep "$i" > /dev/null ; then
		echo $i >> ~/.bashrc
	fi
done

# regenerate locales
for i in $_LANGUAGES
do
	sudo locale-gen $i
done
sudo dpkg-reconfigure -fnoninteractive locales

# source current bashrc
. ~/.bashrc

# test perl
perl -e exit
