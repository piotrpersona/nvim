# nvim

Neovim config for Go, built on nvim 0.12 built-ins: `vim.pack` for plugins,
`vim.lsp.config`/`vim.lsp.enable` for LSP, `vim.lsp.completion` for completion,
`vim.snippet` for snippets. No plugin manager bootstrap, no mason, no cmp.

## Install

```sh
./install.sh          # symlinks this repo to ~/.config/nvim, installs tooling
nvim -c TSInstallAll  # build treesitter parsers (needs the tree-sitter CLI)
```

Language servers are whatever is on `PATH`; `:LspServers` shows which were found.
`gopls` is resolved from `$GOBIN`, then `$GOPATH/bin`, then `~/go/bin`, falling
back to `PATH` — the asdf shim refuses to run in directories with no resolvable
golang version, so the real binary is preferred.

## Layout

| Path | Contents |
|---|---|
| `lua/pp/plugins.lua` | `vim.pack` plugin list, treesitter, oil |
| `lua/pp/set.lua` | options, colorscheme, statusline wiring |
| `lua/pp/autocmd.lua` | disk-reload for agent edits, large-file guard |
| `lua/pp/remap.lua` | general keymaps, panes, harpoon |
| `lua/pp/search.lua` | fzf-lua pickers |
| `lua/pp/git.lua` | gitsigns, diffview, copy-reference maps |
| `lua/pp/lsp.lua` | LSP, completion, diagnostics, snippets, format-on-save |
| `lsp/*.lua` | one file per language server |

`:lua vim.pack.update()` updates plugins. `:TSInstallAll` updates parsers.

## Keymaps

Leader is `<Space>`.

### Search

| Key | Action |
|---|---|
| `<leader><leader>` | live grep |
| `<leader>ff` / `<leader>fh` | find files / including hidden |
| `<leader>fs` / `<leader>fc` | grep prompt / grep word under cursor |
| `<leader>fb` / `<leader>fo` / `<leader>f/` | buffers / recent / lines in buffer |
| `<leader>fr` | resume last picker |
| `<leader>fu` / `<leader>fw` / `<leader>fd` | references / workspace symbols / diagnostics |
| `<leader>gi` | implementations |
| `<leader>gf` / `<leader>gbr` / `<leader>gc` | git files / branches / commits |

In the git branch and commit pickers, `ctrl-d` opens the selection in diffview.

### LSP

| Key | Action |
|---|---|
| `gd` / `gt` / `K` | definition / type definition / hover |
| `]d` / `[d` | next / previous diagnostic |
| `<leader>vd` | line diagnostics |
| `<leader>rn` / `<leader>.` / `<leader>i` | rename / code action / fill struct |
| `<leader>F` | format buffer (Go, Lua, Zig, Rust, proto also format on save) |
| `i <C-h>` | signature help |
| `i <C-k>` / `i <C-j>` | expand snippet or jump forward / jump back |

Completion is native and auto-triggers; `<C-n>`/`<C-p>` move, `<CR>` accepts,
`<C-e>` cancels. Go snippets: type `ife`, `ifr`, `iwf` or `iwe` then `<C-k>`.

### Git and references

| Key | Action |
|---|---|
| `<leader>gd` / `<leader>gD` / `<leader>gq` | diff working tree / vs origin/main / close |
| `<leader>gl` | file history |
| `]h` / `[h` | next / previous hunk |
| `<leader>hp` / `<leader>hs` / `<leader>hr` / `<leader>hb` | preview / stage / reset / blame hunk |
| `<leader>gp` / `<leader>gP` | copy repo-relative / absolute `path:line` |
| `<leader>gy` | copy remote permalink |
| `<leader>gm` | copy selection as a fenced block with its path |

### Editing and movement

| Key | Action |
|---|---|
| `<leader>w` | next window (`2<leader>w` jumps to window 2; `<C-w>h/j/k/l` still works) |
| `<leader>\|` / `<leader>_` | split vertical / horizontal |
| `<leader>a` / `<C-e>` / `<leader>1`-`<leader>4` | harpoon add / menu / jump to file |
| `]q` / `[q` / `]l` / `[l` / `<leader>q` | quickfix and loclist nav, toggle quickfix |
| `<leader>s` / `<leader>x` / `<leader>X` | substitute word / change word repeatable with `.` |
| `<leader>y` / `<leader>Y` / `<leader>d` / `<leader>p` | clipboard yank / blackhole delete / paste over |
| `;;` / `;a` | write / write all |
| `<leader>-` / `<leader>u` | oil / undotree |
| `gc` / `gcc` | comment (built in) |

## Agent-friendly behavior

Buffers reload when something edits them on disk, with a warning, so an agent's
edits are never silently overwritten. Files over 256 KB load without syntax,
treesitter, LSP or undofile.
