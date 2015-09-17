#!/bin/bash

NEEDED_COMMANDS="wdiff colordiff"

install_wdiff() {
	echo Installing wdiff
	curl ftp://ftp.gnu.org/gnu/wdiff/wdiff-latest.tar.gz > wdiff-latest.tar.gz
	tar -xzvf wdiff-latest.tar.gz
	mv wdiff-*/ wdiff/
	dir=`pwd`"/wdiff/"
	cd wdiff
	./configure --prefix ${dir}
	make
}

install_colordiff() {
	echo Installing colordiff
	#wget -O - http://www.colordiff.org/colordiff-1.0.15.tar.gz
	tar -xzvf colordiff-1.0.15.tar.gz
	cd colordiff-1.0.15
	cat Makefile | sed "s?INSTALL_DIR=.*?INSTALL_DIR=`pwd`?" | sed "s?MAN_DIR=.*?MAN_DIR=`pwd`\/man\/man1?" | sed "s?ETC_DIR=.*?ETC_DIR=`pwd`\/etc?" | sed "s?install -D?install -d?g" > Makefile.tmp
	mv Makefile.tmp Makefile
	make install
}

print_usage() {
	echo "Usage: ./install.sh -c [install colordiff] -w [install wdiff] -h [help]"
}

while getopts wch o; do
	case $o in
		w)	install_wdiff;;
		c)	install_colordiff;;
		h) 	print_usage;;
		*)	echo "Invalid argument";;
	esac
done

for cmd in ${NEEDED_COMMANDS} ; do
	if ! command -v ${cmd} &> /dev/null; then
		short=`echo ${cmd} | cut -b 1`
		echo Please rerun installer with option -${short} or install ${cmd}
	else
		echo ${cmd} is installed, moving on.
	fi
done
