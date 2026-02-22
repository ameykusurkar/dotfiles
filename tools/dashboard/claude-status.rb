#!/usr/bin/env ruby
require "json"

input = JSON.parse($stdin.read)
event = input["hook_event_name"]

session = `tmux display-message -p '\#{session_name}' 2>/dev/null`.chomp
exit 0 if session.empty?

# Only track the main "claude" window, ignore other claude instances
window = `tmux display-message -p '\#{window_name}' 2>/dev/null`.chomp
exit 0 unless window == "claude"

status_file = "/tmp/claude-status-#{session}"

case event
when "SessionStart", "Stop"
  File.write(status_file, "idle")
when "UserPromptSubmit", "PostToolUse", "PostToolUseFailure"
  File.write(status_file, "working")
when "PreToolUse"
  if input["tool_name"] == "AskUserQuestion"
    File.write(status_file, "waiting")
  else
    File.write(status_file, "working")
  end
when "PermissionRequest"
  File.write(status_file, "waiting")
when "SessionEnd"
  File.delete(status_file) if File.exist?(status_file)
end
