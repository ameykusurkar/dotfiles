require "open3"
require "json"

Session = Struct.new(:name, :dir, :repo, :branch, :pr_status, :ci_status, :pr_comments, :claude_status, keyword_init: true)

module SessionData
  module_function

  def run(cmd, chdir: nil)
    opts = chdir ? { chdir: chdir } : {}
    stdout, stderr, status = Open3.capture3(cmd, **opts)
    [stdout.chomp, stderr.chomp, status]
  end

  def fetch_all
    names = run("tmux list-sessions -F '\#{session_name}'")[0].split("\n")
    return [] if names.empty?

    sessions = names.map do |name|
      Thread.new { build_session(name) }
    end.map(&:value)

    sessions
  end

  def build_session(name)
    dir = fetch_env(name, "SESSION_DIR") || fetch_pane_path(name)
    repo = fetch_env(name, "SESSION_REPO") || dir

    pr_status = nil
    ci_status = nil
    pr_comments = nil
    claude_status = nil

    # Fetch branch + claude status in parallel; PR/CI depend on branch
    claude_thread = Thread.new { fetch_claude_status(name) }

    branch = dir ? fetch_branch(dir) : nil

    if dir && branch
      pr_thread = Thread.new { fetch_pr_status(dir, branch) }
      ci_thread = Thread.new { fetch_ci_status(dir, branch) }
      comments_thread = Thread.new { fetch_pr_comments(dir, branch) }
      pr_status = pr_thread.value
      ci_status = ci_thread.value
      pr_comments = comments_thread.value
    end

    claude_status = claude_thread.value

    Session.new(
      name: name,
      dir: dir,
      repo: repo,
      branch: branch,
      pr_status: pr_status,
      ci_status: ci_status,
      pr_comments: pr_comments,
      claude_status: claude_status
    )
  end

  def fetch_env(session, var)
    out, _, status = run("tmux show-environment -t #{session} #{var}")
    return nil unless status.success?
    val = out.sub(/^#{var}=/, "")
    val.empty? ? nil : val
  end

  def fetch_pane_path(session)
    out, _, status = run("tmux display-message -t #{session}:0 -p '\#{pane_current_path}'")
    return nil unless status.success?
    out.empty? ? nil : out
  end

  def fetch_branch(dir)
    out, _, status = run("git -C #{dir} rev-parse --abbrev-ref HEAD 2>/dev/null")
    return nil unless status.success?
    out.empty? ? nil : out
  end

  def fetch_pr_status(dir, branch)
    out, _, status = run("gh pr view #{branch} --json state,isDraft,reviewDecision 2>/dev/null", chdir: dir)
    return nil unless status.success?

    data = JSON.parse(out)
    state = data["state"]
    is_draft = data["isDraft"]
    decision = data["reviewDecision"]

    if state == "MERGED"
      "merged"
    elsif state == "CLOSED"
      "closed"
    elsif is_draft
      "draft"
    elsif decision == "APPROVED"
      "approved"
    elsif decision == "CHANGES_REQUESTED"
      "changes"
    elsif decision == "REVIEW_REQUIRED"
      "review"
    else
      "open"
    end
  rescue
    nil
  end

  def fetch_ci_status(dir, branch)
    out, _, status = run("gh pr checks #{branch} --json bucket 2>/dev/null", chdir: dir)
    return nil unless status.success?

    checks = JSON.parse(out)
    return nil if checks.empty?

    buckets = checks.map { |c| c["bucket"] }
    if buckets.include?("fail")
      "fail"
    elsif buckets.include?("pending")
      "pending"
    else
      "pass"
    end
  rescue
    nil
  end

  def fetch_pr_comments(dir, branch)
    out, _, status = run("gh pr view #{branch} --json reviewThreads 2>/dev/null", chdir: dir)
    return nil unless status.success?

    data = JSON.parse(out)
    threads = data["reviewThreads"] || []
    unresolved = threads.count { |t| !t["isResolved"] }
    unresolved
  rescue
    nil
  end

  def fetch_claude_status(session)
    # Get pane PID of the "claude" window
    pane_pid, _, status = run("tmux display-message -t #{session}:claude -p '\#{pane_pid}' 2>/dev/null")
    return "off" unless status.success? && !pane_pid.empty?

    # Find shell PID (direct child of pane), then check its children for claude
    shell_pid, _, _ = run("pgrep -P #{pane_pid} 2>/dev/null")
    return "off" if shell_pid.empty?

    children, _, _ = run("pgrep -P #{shell_pid} -f claude 2>/dev/null")
    return "off" if children.empty?

    # Capture last 30 lines of the claude pane
    pane_out, _, _ = run("tmux capture-pane -t #{session}:claude -p -S -30 2>/dev/null")
    lines = strip_ansi(pane_out)

    last_lines = lines.split("\n").last(10).join("\n")

    if last_lines.match?(/[⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏]|Thinking|thinking/)
      "working"
    elsif last_lines.match?(/^>\s*$/)
      "waiting"
    else
      "idle"
    end
  rescue
    "off"
  end

  def strip_ansi(str)
    str.gsub(/\e\[[0-9;]*[a-zA-Z]/, "")
  end

  # Format helpers for display

  def pr_icon(status)
    case status
    when "approved" then "\u2714 approved"
    when "draft"    then "\u25CC draft"
    when "review"   then "\u25CB review"
    when "changes"  then "\u2718 changes"
    when "merged"   then "\u2714 merged"
    when "closed"   then "\u2718 closed"
    when "open"     then "\u25CB open"
    else "\u2014"
    end
  end

  def ci_icon(status)
    case status
    when "pass"    then "\u2714 pass"
    when "fail"    then "\u2718 fail"
    when "pending" then "\u25CC pend"
    else "\u2014"
    end
  end

  def claude_icon(status)
    case status
    when "working" then "\u21BB working"
    when "waiting" then "\u25CF waiting"
    when "idle"    then "\u25CB idle"
    else "\u2014 off"
    end
  end

  def comments_display(count)
    return "\u2014" if count.nil?
    count.to_s
  end
end
