---
name: cmux
description: >
  General skill for working inside cmux — creating surfaces, splits, and managing layout.
  Triggers on: "show me", "open that file", "let's try this in a console/REPL/IRB/python",
  "run the tests", "tail the logs", "what does the diff look like", "open neovim",
  "show the implementation", "look at that function", "open a shell", "watch",
  "side by side", "compare these files".
  Also triggers when showing a diff, file, or code output would be more useful in a
  separate surface than inline in the conversation.
trigger: auto
---

# cmux

You are inside cmux and can create surfaces and splits to show the user contextual content
instead of (or in addition to) printing it inline in the conversation.

For full command reference, run `cmux --help`. This skill covers principles and core primitives only.

## Terminology

- **Window** — a top-level OS window
- **Workspace** — a tab within a window (like a tmux session)
- **Pane** — a spatial region within a workspace (created by splitting)
- **Surface** — a terminal or browser tab within a pane

References use the format `surface:<n>`, `pane:<n>`, `workspace:<n>`.

## Primitives

### New surface (new tab in current pane)

Opens a new terminal tab alongside the current surface, within the same pane.

```bash
cmux new-surface --type terminal
```

Use when: the user wants a parallel workspace without changing the layout — a REPL,
a server, a log tail — something they'll switch between via tabs.

`new-surface` opens a shell prompt — there is **no `--command` flag for terminal
surfaces** (the only `new-surface` flags are `--type`, `--pane`, `--workspace`, and
`--url` for browser surfaces). To launch a program in the new surface, capture the
returned `surface:<n>` from the command output and follow up with `cmux send` +
`cmux send-key Enter` (see "Interacting with surfaces" below).

### Horizontal split (top/bottom)

Splits the current pane to create a new pane below (or above).

```bash
cmux new-split down    # new pane below
cmux new-split up      # new pane above
```

Use when: running something transient the user glances at — test output, logs, a quick
command. The main content stays dominant on top.

### Vertical split (left/right)

Splits the current pane to create a new pane to the side.

```bash
cmux new-split right   # new pane to the right
cmux new-split left    # new pane to the left
```

Use when: viewing code, diffs, or comparing files side by side. Content that benefits
from vertical reading space.

### Interacting with surfaces

`cmux new-surface` and `cmux new-split` print the new `surface:<id>` to stdout — capture
it from the output rather than running `cmux tree` again. Then:

```bash
cmux send --surface surface:<id> 'command here'
cmux send-key --surface surface:<id> Enter
cmux read-screen --surface surface:<id>
```

Sending text and pressing Enter are separate steps — always follow `send` with `send-key Enter`.

**Common pattern — open a file in nvim in a new surface:**

```bash
cmux new-surface --type terminal
# → prints "OK surface:91 pane:55 workspace:44"
cmux send --surface surface:91 'nvim /path/to/file.md'
cmux send-key --surface surface:91 Enter
```

If the screen still shows the shell prompt after sending, `cmux read-screen` will reveal
that — read it before assuming the command ran.

### When it's not obvious

If the content doesn't clearly fit one of these patterns, ask the user how they'd like
it opened rather than guessing.

## Principles

### Look before you act

Before interacting with any surface:

1. **`cmux tree`** — see the current layout of panes and surfaces
2. **`cmux read-screen --surface surface:<id>`** — read what's on screen before sending input
3. **Act** — now that you know the state, proceed

### Reuse over proliferation

If a suitable pane or surface already exists, reuse it rather than creating another split.
If the layout is already busy, prefer a new surface (tab) over another split.

### Cleanup

When done with a surface, close it with `cmux close-surface --surface surface:<id>`.
Offer to clean up when a task is finished.

### Tone

Don't announce what you're doing in detail — just do it. Say something brief like
"Opened in a split on the right" or "Running in the bottom pane." The user can see it.
