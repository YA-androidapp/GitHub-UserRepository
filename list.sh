#!/bin/sh
# Copyright (c) 2019 YA-androidapp(https://github.com/YA-androidapp) All rights reserved.

USER='ya-androidapp'

if [ -e result.txt ]; then
    rm result.txt
fi

for page in $(seq 1 10)
do
REPONAME=$(curl -s "https://api.github.com/users/$USER/repos?page=$page&per_page=100"|grep "\"full_name\""|cut -d'"' -f4)
if [ -z "$REPONAME" ]; then break;fi
echo "$REPONAME"|sed -e "s~${USER}/~~ig" >> result.txt
done

cat result.txt | while read REPONAME
do
    if [ -e $REPONAME ]; then
        cd "$REPONAME"
        git pull
        cd ../
    else
        git clone "https://github.com/$USER/$REPONAME"
    fi
done
