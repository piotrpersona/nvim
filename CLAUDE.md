# nvim

Neovim config for Go, built on nvim 0.12 built-ins. See `README.md` for the
layout and keymaps.

`~/.config/nvim` is a **symlink** to this repo. The live config and the repo
working tree are the same files, so an edit under `~/.config/nvim` is an
uncommitted change here.

## Always check for drift before install.sh or sync.sh

`install.sh` and `sync.sh` change the machine. Never run either one as the
first step. Run the check below, report what it found, and get approval before
anything destructive.

```sh
git status --short --branch        # uncommitted work in the repo
git fetch -q origin && git log --oneline HEAD..origin/main   # incoming commits
ls -ld ~/.config/nvim              # is it a link, and where does it point?
readlink ~/.config/nvim            # empty output means it is a real directory
```

Read each result against the cases below.

### What drift means here

| Finding | What the installer does | Report as |
| --- | --- | --- |
| `~/.config/nvim` is a real directory | moved to `~/.config/nvim.<stamp>.bak`, then replaced by the link | **destructive** — diff it against this repo first and list every file that exists only there |
| `~/.config/nvim` links somewhere else | the old link is removed and replaced | safe for files, but say which repo stops being live |
| `~/.config/nvim` links here already | nothing | no action |
| uncommitted changes in the repo | `sync.sh` runs `git pull --ff-only`, which aborts on conflict | **blocking** — commit, stash or report before pulling |
| local commits not on `origin/main` | `--ff-only` refuses to pull | **blocking** — the branches diverged, ask how to resolve |
| `brew` missing tools | `install.sh` runs `brew install` | changes the machine outside this repo, say which formulae |

When the live directory is real and not a link, diff before touching it:

```sh
diff -ru ~/.config/nvim . | head -100
```

A `.bak` copy is a recovery path, not permission. Anything that moves, removes
or overwrites a file in `$HOME` is reported first and run second.

### Report format

State, in this order: the link state of `~/.config/nvim`, uncommitted files,
incoming commits, then a plain list of every destructive action with its
recovery path. If the lists are empty, say the install is a no-op.

## Rules for changes

- Keep the config symlinked. Never `cp` this repo into `~/.config/nvim`, and
  never `rm -rf` the target: `install.sh` moves an existing real directory
  aside as `<target>.<stamp>.bak`.
- `plugin/`, `pack/` and `nvim-pack-lock.json` are gitignored plugin state, not
  config. Do not commit them.
- Plugins are `vim.pack` entries in `lua/pp/plugins.lua`. There is no plugin
  manager bootstrap, no mason and no cmp — do not add one back.
- Language servers come from `PATH`, one file per server in `lsp/`.
- Check syntax with `bash -n` on every script touched.
- Record a user-visible change in `README.md`.
