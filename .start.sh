#!/bin/bash
source /root/.bashrc
export RAILS_ENV=production
cd /var/www/top_c
./config/unicorn.sh start
#bluepill load config/main.pill
