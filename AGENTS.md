# AGENTS.md - bash-ftw

Guidelines for AI agents working with this repository.

## Project Overview

**bash-ftw** is a cross-platform optimized BASH framework. It provides:
- Portable shell configuration (`.bashrc.ftw`)
- Useful aliases, functions, and shortcuts
- Installation recipes for common dev tools
- Git workflow helpers (worktrees, branch management)

## File Structure

| Path | Purpose | When to Edit |
|------|---------|--------------|
| `dotfiles/.bashrc.ftw` | **Main file** — aliases, functions, recipes | Most changes go here |
| `dotfiles/.bashrc.ftw.mac` | macOS-specific config | Mac-only features |
| `dotfiles/.bashrc.ftw.linux` | Linux-specific config | Linux-only features |
| `bin/` | Standalone scripts | **Rarely** — special cases only |
| `install.sh` | Bootstrap installer | Seldom changed |

## Where to Add Things

### ✅ Default: `dotfiles/.bashrc.ftw`

**Almost everything goes here.** Organized in sections:

```
################################################################################
# Section Name
```

Key sections:
- **BASH functions** — utility functions
- **aliases** — shortcuts for common commands
- **Git** — git aliases and functions
- **Git Worktrees** — worktree management
- **Installation Cheatsheets** — `install-*` recipes (alphabetized!)

### ❌ Avoid: `bin/`

Only add to `bin/` when:
- Script must exist **before** BASH profile loads
- Script is used by non-interactive shells
- Script is complex enough to warrant a standalone file (100+ lines)

If in doubt, use `.bashrc.ftw`.

## Installation Recipes

### Preferred Pattern: `alias install-X="curl ... | bash"`

```bash
alias install-bun="curl -fsSL https://bun.sh/install | bash"
alias install-claude="curl -fsSL https://claude.ai/install.sh | bash"
alias install-nvm="curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash"
```

### When to Use `function` Instead

Use a function when:
- Different install methods per OS
- Need pre/post install steps
- Multi-step process

```bash
function install-gh {
    if [[ $KERNEL == 'Darwin' ]]; then
        brew install gh
    elif [[ $KERNEL == 'Linux' ]]; then
        # apt-based install
    fi
}
```

### ⚠️ Source Vetting Rules

Only use `curl | bash` from **reputable sources**:
- ✅ Official project install scripts (bun.sh, rustup.rs, nvm-sh)
- ✅ GitHub repos with 1000+ stars, 6+ months old
- ✅ Well-known orgs (Anthropic, OpenAI, Vercel, etc.)
- ❌ Random repos or unverified sources
- ❌ Unofficial mirrors

### Cross-Platform Priority

Prefer universal installers over package managers:

| Prefer | Over |
|--------|------|
| `curl .../install.sh \| bash` | `brew install X` |
| `npm install -g X` | OS-specific package |
| `cargo install X` | Distro packages |

Only fall back to `brew`/`apt` when no universal installer exists.

## Style Guide

### Aliases
- Keep alphabetized within sections
- Use double quotes for complex commands
- One-liners only

### Functions
- Use `function name {` style (not `name() {`)
- Add usage comments for non-obvious functions
- Check `$KERNEL` for OS-specific behavior

### Comments
- Section headers: `################################################################################`
- Subsection: `##`
- Inline explanations: `#`

## Testing Changes

After editing:
```bash
make install    # Copy dotfiles to ~
rebash          # Reload BASH config
```

## Git Workflow

Standard commit, push to master. Branch protection may require admin bypass.

Commit message format:
```
Add install-X recipe for Tool Name
Fix: description of fix
```
