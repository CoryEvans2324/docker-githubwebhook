#!/bin/bash

docker create \
    --name=githubwebhook \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Pacific/Auckland \
    -e HOOK_SECRET_KEY=another-secret \
    -e GIT_REPO=git@github.com:user/repo_name \
    -e GIT_BRANCH=master \
    -p 80:80 \
    -v $(pwd)/ssh:/tmp/.ssh \
    -v $(pwd)/code:/code \
    coryevans2324/githubwebhook

docker start githubwebhook
