#!/bin/bash

#while [ -n "$*" ]; do
#  flag=$1
#  value=$2
# 
#  case "$flag" in
#    "-e")
#      one=$value
#      shift
#    ;;
#    "--two")
#      two=$value
#      shift
#    ;;
#    "--pretend")
#      pretend=true
#    ;;
#    "--help")
#      dohelp
#    ;;
#    "--")
#      break
#    ;;
#    *)
#      echo -e "unknown option $flag\n"
#      dohelp
#    ;;
#  esac
# 
#  shift
#done


if [ $# -ge 1 -a -f "$1"  ]
then
    input="$1"
else
    input="-"
    input=`cat $input`
fi
cat $input
