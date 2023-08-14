# .profile is used by vscode logins

# initialize the HPC stuff
SETUP="/hpc/apps/setup"
[ -f "$SETUP/profile.bash" ] && . $SETUP/profile.bash

# the HPC conda setup includes lots of extra channels we don't need
module load git conda sge
conda activate base
unset CONDARC

# use london time
export TZ=GB

export XDG_CACHE_HOME=/data1/${USER}/.cache
mkdir --parents $XDG_CACHE_HOME

export STARSHIP_CACHE=$XDG_RUNTIME_DIR
export PRE_COMMIT_HOME="/data1/${USER}/pre-commit-cache"
export VSCODE_CLI_DATA_DIR="${HPCDATADIR}/.vscode-cli"

export NTLM_USER_FILE=${HOME}/.ntlm-user-file

# Created by `pipx` on 2022-12-15 10:02:07
export PATH="$PATH:/home/0066tm/.local/bin"

