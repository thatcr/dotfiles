#!/bin/bash
#------------------------------------------------------------------------------     
# BP HPC .bashrc file 
# => Do not delete, modify, or molest.
# => All user mods should go in $HOME/.userbashrc
#------------------------------------------------------------------------------     
# => This is where our setup files live
#     
SETUP="/hpc/apps/setup"
#
#------------------------------------------------------------------------------     
#     
[ -f "$SETUP/profile.bash" ] && . $SETUP/profile.bash
#
#------------------------------------------------------------------------------
#
[ -f "$HOME/.userbashrc" ] && . $HOME/.userbashrc
#

# Created by `pipx` on 2022-12-15 10:02:07
export PATH="$PATH:/home/0066tm/.local/bin"
