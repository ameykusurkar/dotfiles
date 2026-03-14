# Cross-window and cross-session tmux operations

## Key commands

```bash
# List ALL windows and panes across ALL sessions
tmux list-windows -a -F '#{session_name}:#{window_index}.#{pane_index} #{window_name} #{pane_current_command}'

# Break a pane out into its own new window (keeps it in the same session)
# -d = don't switch to the new window
tmux break-pane -d -s <session>:<window>.<pane>

# Move an entire window from one session to another
# WARNING: this moves ALL panes in the window, not just one
tmux move-window -s <src_session>:<window_index> -t <dst_session>

# Move a single pane from one place to another
# This is usually what you want — it moves just the pane
tmux move-pane -s <src_session>:<window>.<pane> -t <dst_session>:<window>.<pane>
```

## Targeting syntax

Tmux uses `session:window.pane` targeting:
- `mysession:0.1` — session "mysession", window 0, pane 1
- `2:3.0` — session "2", window 3, pane 0
- If you omit the session, tmux uses the current session

## Step-by-step workflow: moving a pane between sessions

1. **List full state** — understand what's where before touching anything:
   ```bash
   tmux list-windows -a -F '#{session_name}:#{window_index}.#{pane_index} #{window_name} #{pane_current_command}'
   ```

2. **Identify the target pane** — find the exact `session:window.pane` address of the pane you want to move.

3. **Move just that pane** — use `move-pane`, not `move-window`:
   ```bash
   tmux move-pane -s source_session:1.2 -t dest_session:0.1
   ```

4. **Verify** — list state again to confirm the pane landed where expected:
   ```bash
   tmux list-windows -a -F '#{session_name}:#{window_index}.#{pane_index} #{window_name} #{pane_current_command}'
   ```

## Common pitfalls

- **`move-window` moves the entire window** (all its panes), not a single pane. If a window has 3 panes and you `move-window`, all 3 come along. Use `break-pane` first to isolate the pane you want, then `move-window` the new single-pane window.

- **Window index conflicts** — if the destination session already has a window at the target index, `move-window` will fail. Use `-k` to replace the existing window, or omit the target index to let tmux pick the next available slot:
  ```bash
  tmux move-window -s src:2 -t dst:
  ```

- **Pane indexes shift after moves** — after moving or killing panes, the remaining panes may be renumbered. Always re-list before operating on another pane.

- **Session names with special characters** — quote or escape session names that contain colons, periods, or spaces.
