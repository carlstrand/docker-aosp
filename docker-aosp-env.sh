#!/bin/sh

#=================================#
# CONFIG SECTION                  #
#=================================#

# Directory of the AOSP TREE
export BASE_DIR=descendant
export FULL_DIR=/mnt/android/${BASE_DIR}

# Directory & Compose file of the docker repo
export DREPO_DIR=/mnt/android/docker-aosp
export DCOMP_FILE=${DREPO_DIR}/docker-compose.yml

# Git editor
export VISUAL=nano
export EDITOR="$VISUAL"

#=================================#

# Git
alias gcp='git cherry-pick'
alias gco='git checkout'

# Go to AOSP tree and setup the env. The venv line is
# needed for distributions that default to python 3.
# For details, see https://wiki.archlinux.org/index.php/android#Setting_up_the_build_environment
alias adevenv='cd ${FULL_DIR} && source ./build/envsetup.sh && source ./venv/bin/activate'

# Android build command.
alias abuild='docker-compose -f ${DCOMP_FILE} run --rm aosp buildaosp.sh'

# Launch a bash shell in the build container
alias abash='docker-compose -f ${DCOMP_FILE} run --rm aosp /bin/bash'

rateup () {
    ssh -p 29418 ${UNAME_GERRIT}@${SRV_GERRIT} gerrit review --verified +1 --code-review +2 --project "$1" $(git rev-list "$2"..HEAD)
}
rateup_low () {
    ssh -p 29418 ${UNAME_GERRIT}@${SRV_GERRIT} gerrit review --code-review +1 --project "$1" $(git rev-list "$2"..HEAD)
}
