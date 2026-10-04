#!/usr/bin/env bash
# Standalone bootstrap: clone this config and link it into ~/.config/nvim.
set -euo pipefail

DIR="${NVIM_SRC:-${HOME}/developer/github.com/piotrpersona/nvim}"

if [ -d "${DIR}/.git" ]; then
    git -C "${DIR}" pull --ff-only
else
    mkdir -p -- "$(dirname -- "${DIR}")"
    git clone --branch=main https://github.com/piotrpersona/nvim.git "${DIR}"
fi

"${DIR}/install.sh"
