#!/bin/sh

# some magic to find out the real location of this script dealing with symlinks
DIR=`readlink "$0"` || DIR="$0";
DIR=`dirname "$DIR"`;
cd "$DIR"
DIR=`pwd`
cd - > /dev/null 

"$DIR"/files/pharo-ui "$DIR"/files/Pharo st "$DIR"/deployer.st $1 $2
