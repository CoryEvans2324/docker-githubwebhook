#!/bin/bash

# Copy ssh keys to home folder (/root)
# and change ownership & permissions.
cp -R /tmp/.ssh /root/.ssh
chown -R root:root /root/.ssh
chmod -R 600 /root/.ssh


echo "*** cloning git repo ***"

if [ ! -d '/code/.git' ];then
    if [ ! -z "$GIT_REPO" ];then
        if [ ! -z "$GIT_BRANCH" ];then
            git clone --recursive -b $GIT_BRANCH $GIT_REPO /code/
            cd /code && git checkout $GIT_BRANCH
            git reset --hard origin/$GIT_BRANCH
        else
            git clone --recursive $GIT_REPO /code/
        fi
        chown -Rf root:root /code/*
    else
        echo "GIT_REPO is not defined"
        exit
    fi
fi

echo "*** Starting server ***"
server.py
