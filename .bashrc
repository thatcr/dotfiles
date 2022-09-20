# exec pwsh
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/workspace/mambaforge/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/workspace/mambaforge/etc/profile.d/conda.sh" ]; then
        . "/workspace/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="/workspace/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

eval "$(starship init bash)"

