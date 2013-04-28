#! /bin/bash
ledstate=`xset q 2>/dev/null | grep LED`  
ledstate=`echo $ledstate | sed s/[^1-9]//g`  
case "$ledstate" in
        '1')
        echo -n "C"
        ;;
        '2')
        echo -n "N"
        ;;
        '3')
        echo -n "CN"
        ;;
        *)
        echo -n ""
esac
