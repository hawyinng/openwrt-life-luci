#!/bin/sh

BTlist=`wget -qO- --no-check-certificate https://ngosang.github.io/trackerslist/trackers_all.txt|awk NF|sed ":a;N;s/\n/,/g;ta"`

if [ -z "`grep "list bt_tracker " /etc/config/aria2`" ]; then

    sed -i "$a list bt_tracker '"${BTlist}"'" /etc/config/aria2

    echo Adding

else

    sed -i "s@list bt_tracker .*@list bt_tracker '$BTlist'@g" /etc/config/aria2

    echo update completed

fi

/etc/init.d/aria2 restart
