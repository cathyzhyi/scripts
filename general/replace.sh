#!/bin/bash
if [[ "$#" -lt 2 ]]; then
   echo "arg1 pattern to replace, arg2 replacing pattern"
   exit 1
fi

while getopts ":g" option; do
   case $option in
      g)
         export git=1
         ;;
   esac
done

if [ -z $git ]; then
   for file in `git diff-tree --no-commit-id --name-only -r HEAD~0`
   do
      echo $file
      sed -i "s/$1/$2/g" $file
   done
   exit 0
fi

for file in `find ./ -name \*`
do
   sed -i "s/$1/$2/g" $file
done

