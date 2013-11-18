#!/bin/sh

WD=`pwd`
cd `dirname $0`/py-venv
source bin/activate
cd $WD
python `dirname $0`/pbkdf2.py $*
