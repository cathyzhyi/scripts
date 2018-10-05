#!/bin/bash
title
screenItem=`screen -r | grep -i $1`
title `echo $screenItem | cut -d'.' -f2,2 | cut -d' ' -f1,1`
screenNum=`echo $screenItem | cut -d'.' -f1,1`
screen -rAadx $screenNum
