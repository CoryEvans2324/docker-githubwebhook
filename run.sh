#!/bin/bash

docker run \
    --rm \
    -it \
    -e GIT_REPO=git@github.com:user/repo_name.git \
    -e GIT_BRANCH=master \
    -p 80:80 \
    -v $(pwd)/ssh:/tmp/.ssh \
    -v $(pwd)/code:/code \
    coryevans2324/githubwebhook
