---
name: tmux-show
description: >
  Opens contextual content in tmux panes — code files, diffs, REPLs, logs, test runners, and more.
  Triggers on: "show me", "open that file", "let's try this in a console/REPL/IRB/python",
  "run the tests", "tail the logs", "what does the diff look like", "open neovim",
  "show the implementation", "look at that function", "open a shell", "watch",
  "side by side", "compare these files", "open lazygit".
  Also triggers when showing a diff, file, or code output would be more useful in a
  tmux pane than inline in the conversation.
trigger: auto
---

# tmux-show

You are inside a tmux session and can create panes to show the user contextual content
instead of (or in addition to) printing it inline in the conversation.

## Primitives

```bash
# List current panes (ALWAYS do this before ANY pane interaction)
tmux list-panes -F '#{pane_index} #{pane_width}x#{pane_height} #{pane_current_command} #{pane_active}'
# WARNING: pane_current_command is unreliable — it shows the top-level shell (e.g. fish)
# even when a child process (e.g. cargo run via make server) is running.
# Always capture-pane to verify what's actually happening.

# Create a pane with a direct command (pane auto-closes when command exits —
# the pane vanishes and indexes shift, so don't plan to send-keys to it later)
tmux split-window -v -l 25% 'command here'      # bottom strip
tmux split-window -h -l 50% 'nvim +42 foo.rs'   # right half with neovim

# Create a pane with a shell (persists until killed — use when you need to
# interact with the pane later: servers you'll restart, REPLs, iterative work)
tmux split-window -v -l 25%

# Send commands to an existing pane (use pane index, not {bottom})
tmux send-keys -t <pane_index> 'command here' Enter

# Read pane output
tmux capture-pane -t <pane_index> -p

# Read scrollback (up to N lines back)
tmux capture-pane -t <pane_index> -p -S -100

# Close a pane
tmux kill-pane -t <pane_index>
```

## Look before you act

Before ANY pane interaction — `send-keys`, `capture-pane`, `kill-pane`, creating a new
split — follow this loop:

1. **`list-panes`** — confirm the target pane exists and get its current index. Indexes
   shift when panes are created or destroyed, so never assume a previous index is still valid.
2. **`capture-pane`** — read what's actually on screen. This is your eyes. Don't guess
   state from `pane_current_command` — it shows the top-level shell even when a child process
   is running (e.g. `make server` spawns `cargo run`, but `pane_current_command` says `fish`).
3. **Act** — now that you know the pane exists and what it's showing, send keys / kill / split.

### Pane lifecycle

- **Direct-command panes** (`split-window ... 'command'`): auto-close when the command exits.
  The pane vanishes, indexes shift, and any `send-keys` to that index will fail or hit the
  wrong pane. Use these for fire-and-forget commands (tests, one-shot scripts, viewing files).
- **Shell panes** (`split-window` with no command): persist until explicitly killed. Use these
  when you need to interact after the initial command — servers you'll restart, REPLs, or
  anything you might Ctrl-C and rerun.

If you're about to `send-keys` to a pane and aren't sure it still exists — it probably doesn't.
List panes first.

## What to open and where

**Viewing code / reading files / diffs / implementations:**
- Use a vertical split (right half, `-h -l 50%`)
- These need vertical space for reading
- Open with neovim: `nvim +<line_number> <file_path>`
- For diffs: `git diff <args> | delta` or just `git diff <args>`

**Running something (REPL, tests, server, logs):**
- Use a horizontal split (bottom strip, `-v -l 25%` to `-v -l 30%`)
- These are transient — the user glances at output
- For non-interactive commands, pass the command directly to split-window:
  `tmux split-window -v -l 25% 'cargo test'`
- For REPLs: split with a shell first, then send-keys (see REPL workflow below)
- For logs: `tmux split-window -v -l 25% 'tail -f <logfile>'`

**Comparison (two files, before/after):**
- Side by side using vimdiff or two vertical splits

## Adapting to existing layout

- If the desired position is already occupied by another pane, consider reusing it
  (send-keys to run a new command) rather than creating yet another split
- Don't clobber the user's existing panes that aren't yours
- If the screen is already crowded (3+ panes), prefer reusing over splitting further

## Cross-window and cross-session operations

Read `references/cross-session.md` for moving panes between windows or sessions.

## REPL workflow

When sending code to a REPL:
1. Split the pane and start the REPL
2. Sleep 2 seconds to let it boot (or more for Rails console)
3. Send code via `tmux send-keys -t <index> '<code>' Enter`
4. Sleep 1 second, then `tmux capture-pane -t <index> -p` to read output
5. Bring relevant results back into the conversation

For multi-line code, send line by line with Enter after each.

## Cleanup

- When done with a pane or the user says "close it", use `tmux kill-pane -t <index>`
- Track which panes you created by checking indexes after splitting
- Offer to clean up when a task is finished

## Tone

Don't announce what you're doing in detail — just do it. Say something brief like
"Opened in a pane on the right" or "Running in the bottom pane." The user can see it.
