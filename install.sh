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

# Language servers and the treesitter CLI used to come from mason.nvim, which is
# gone: nvim now runs whatever is on PATH (see lsp/*.lua). gopls comes from asdf.
need() { command -v "${1}" >/dev/null 2>&1; }

if need brew; then
    for tool in tree-sitter-cli lua-language-server; do
        if ! brew list --formula "${tool}" >/dev/null 2>&1; then
            say "brew  ${tool}"
            brew install --quiet "${tool}" || say "could not install ${tool}"
        fi
    done
else
    say "no brew; install tree-sitter-cli and lua-language-server yourself"
fi

need tree-sitter || say "WARNING: tree-sitter CLI missing, :TSInstallAll will fail"
need gopls || say "WARNING: gopls missing, run: go install golang.org/x/tools/gopls@latest"
