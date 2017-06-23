#!/bin/bash
set -e

nohup mongod &
source ~/.nvm/nvm.sh
exec node wiki configure
