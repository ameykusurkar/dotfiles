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
# List current panes (ALWAYS do this before creating or killing panes)
tmux list-panes -F '#{pane_index} #{pane_width}x#{pane_height} #{pane_current_command} #{pane_active}'

# Create a pane with a command (preferred — pane auto-closes when command exits)
tmux split-window -v -l 25% 'command here'      # bottom strip
tmux split-window -h -l 50% 'nvim +42 foo.rs'   # right half with neovim

# Create a pane with a shell (only when you need to send-keys interactively, e.g. REPLs)
tmux split-window -v -l 25%

# Send commands to an existing pane (use pane index, not {bottom})
tmux send-keys -t <pane_index> 'command here' Enter

# Read pane output
tmux capture-pane -t <pane_index> -p

# Read scrollback (up to N lines back)
tmux capture-pane -t <pane_index> -p -S -100

# Close a pane (ALWAYS list-panes first to confirm the pane still exists)
tmux kill-pane -t <pane_index>
```

## Placement heuristics

Before creating a pane, ALWAYS run `tmux list-panes` to understand the current layout.

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
