#!/bin/sh
#
# unicorn_top_c
#
# chkconfig: - 85 15
# processname: unicorn_top_c
# description: unicorn_top_c
#
### BEGIN INIT INFO
# Provides: unicorn_top_c
# Required-Start: $all
# Required-Stop: $all
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: start and stop unicorn_top_c
### END INIT INFO

set -u
set -e
# Example init script, this can be used with nginx, too,
# since nginx and unicorn accept the same signals

# Feel free to change any of the following variables for your app:
PATH=/usr/local/rvm/bin:$PATH
APP_ROOT=/var/www/developers
PID=$APP_ROOT/tmp/pids/unicorn.pid
ENV=production
CMD="$APP_ROOT/bin/unicorn -D -E $ENV -c $APP_ROOT/config/unicorn.conf.rb"

old_pid="$PID.oldbin"

cd $APP_ROOT || exit 1
#rvm wrapper ruby-1.9.3-p0@top_c unicorn
date >> tmp/refs
git show-ref >> tmp/refs

sig () {
	test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
	test -s $old_pid && kill -$1 `cat $old_pid`
}

case $1 in
start)
	sig 0 && echo >&2 "Already running" && exit 0
	$CMD
	;;
stop)
	sig QUIT && exit 0
	echo >&2 "Not running"
	;;
force-stop)
	sig TERM && exit 0
	echo >&2 "Not running"
	;;
restart|reload)
	sig HUP && echo reloaded OK && exit 0
	echo >&2 "Couldn't reload, starting '$CMD' instead"
	$CMD
	;;
upgrade)
	sig USR2 && exit 0
	echo >&2 "Couldn't upgrade, starting '$CMD' instead"
	$CMD
	;;
rotate)
        sig USR1 && echo rotated logs OK && exit 0
        echo >&2 "Couldn't rotate logs" && exit 1
        ;;
*)
	echo >&2 "Usage: $0 <start|stop|restart|upgrade|rotate|force-stop>"
	exit 1
	;;
esac
