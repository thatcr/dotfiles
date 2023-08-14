#!/bin/bash

# include the /bin/sh profile settings
source ${HOME}/.profile

# if running from an interactive session setup starship
TTY=`tty|awk -F/ '{print $2}'`
if [ "$TTY" = "dev" ] ; then
    source <(starship init bash --print-full-init)
fi







