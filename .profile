#!/bin/sh

# NOTE vscode will use /bib/sh on first access so this sets the environment
#      for it's commands. terminals will launch bashrc etc.

export PATH=~/bin:~/.local/bin:${PATH}
export TZ=GB
export NTLM_USER_FILE=${HOME}/.ntlm-user-file

# TERM_PROGRAM will be "vscode"

# if we are on HPC install the specific script
[ -d "/hpc" ] && source ${HOME}/.profile.hpc

