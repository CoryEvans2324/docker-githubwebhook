#!/bin/bash

cd /code && git pull
chown -Rf $PUID:$PGID /code
