#!/bin/bash
set -e

nohup mongod &
source ~/.nvm/nvm.sh
node wiki configure &
node wiki start
sleep infinity
