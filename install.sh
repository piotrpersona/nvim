#!/usr/bin/env bash
# Link this config into ~/.config/nvim.
#
# Symlinked, not copied: editing a file under ~/.config/nvim edits this repo,
# and `git pull` is enough to pick up a change. Runs standalone or from the
# parent `environment` repo.

set -euo pipefail

SRC="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DST="${XDG_CONFIG_HOME:-${HOME}/.config}/nvim"
STAMP="${ENV_STAMP:-$(date +%Y%m%d-%H%M%S)}"

say() { printf '  %s\n' "${*}"; }

if [ -L "${DST}" ] && [ "$(readlink -- "${DST}")" != "${SRC}" ]; then
    rm -- "${DST}"
elif [ ! -L "${DST}" ] && [ -e "${DST}" ]; then
    mv -- "${DST}" "${DST}.${STAMP}.bak"
    say "kept   ${DST} -> $(basename -- "${DST}").${STAMP}.bak"
fi

if [ ! -L "${DST}" ]; then
    mkdir -p -- "$(dirname -- "${DST}")"
    ln -s -- "${SRC}" "${DST}"
fi
say "link   ${DST} -> ${SRC}"

# copilot.vim lives under pack/, which is gitignored, so it does not dirty
# this repo now that the live config is a symlink back into it.
COPILOT="${SRC}/pack/github/start/copilot.vim"
if [ -d "${COPILOT}/.git" ]; then
    git -C "${COPILOT}" pull --ff-only --quiet || say "could not update copilot.vim"
else
    mkdir -p -- "$(dirname -- "${COPILOT}")"
    git clone --quiet --depth=1 https://github.com/github/copilot.vim.git "${COPILOT}"
fi
say "copilot.vim ready"
