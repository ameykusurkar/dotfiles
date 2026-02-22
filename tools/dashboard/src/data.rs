use serde::{Deserialize, Serialize};
use std::process::Command;
use std::thread;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Session {
    pub name: String,
    pub dir: Option<String>,
    pub repo: Option<String>,
    pub branch: Option<String>,
    pub pr_status: Option<PrStatus>,
    pub ci_status: Option<CiStatus>,
    pub pr_comments: Option<u32>,
    pub claude_status: ClaudeStatus,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
#[serde(rename_all = "lowercase")]
pub enum PrStatus {
    Approved,
    Draft,
    Review,
    Changes,
    Merged,
    Closed,
    Open,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
#[serde(rename_all = "lowercase")]
pub enum CiStatus {
    Pass,
    Fail,
    Pending,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
#[serde(rename_all = "lowercase")]
pub enum ClaudeStatus {
    Working,
    Waiting,
    Idle,
    Off,
}

fn run_cmd(cmd: &str, args: &[&str]) -> Option<String> {
    let output = Command::new(cmd).args(args).output().ok()?;
    if !output.status.success() {
        return None;
    }
    let s = String::from_utf8_lossy(&output.stdout).trim().to_string();
    if s.is_empty() {
        None
    } else {
        Some(s)
    }
}

fn run_cmd_in_dir(cmd: &str, args: &[&str], dir: &str) -> Option<String> {
    let output = Command::new(cmd).args(args).current_dir(dir).output().ok()?;
    if !output.status.success() {
        return None;
    }
    let s = String::from_utf8_lossy(&output.stdout).trim().to_string();
    if s.is_empty() {
        None
    } else {
        Some(s)
    }
}

fn fetch_env(session: &str, var: &str) -> Option<String> {
    let output = run_cmd("tmux", &["show-environment", "-t", session, var])?;
    // Output is "VAR=value", strip the prefix
    let prefix = format!("{}=", var);
    let val = output.strip_prefix(&prefix).unwrap_or(&output);
    if val.is_empty() {
        None
    } else {
        Some(val.to_string())
    }
}

fn fetch_pane_path(session: &str) -> Option<String> {
    let target = format!("{}:0", session);
    run_cmd(
        "tmux",
        &["display-message", "-t", &target, "-p", "#{pane_current_path}"],
    )
}

fn fetch_branch(dir: &str) -> Option<String> {
    run_cmd("git", &["-C", dir, "rev-parse", "--abbrev-ref", "HEAD"])
}

fn fetch_pr_status(dir: &str, branch: &str) -> Option<PrStatus> {
    let output = run_cmd_in_dir(
        "gh",
        &["pr", "view", branch, "--json", "state,isDraft,reviewDecision"],
        dir,
    )?;
    let data: serde_json::Value = serde_json::from_str(&output).ok()?;
    let state = data["state"].as_str()?;
    let is_draft = data["isDraft"].as_bool().unwrap_or(false);
    let decision = data["reviewDecision"].as_str().unwrap_or("");

    Some(if state == "MERGED" {
        PrStatus::Merged
    } else if state == "CLOSED" {
        PrStatus::Closed
    } else if is_draft {
        PrStatus::Draft
    } else if decision == "APPROVED" {
        PrStatus::Approved
    } else if decision == "CHANGES_REQUESTED" {
        PrStatus::Changes
    } else if decision == "REVIEW_REQUIRED" {
        PrStatus::Review
    } else {
        PrStatus::Open
    })
}

fn fetch_ci_status(dir: &str, branch: &str) -> Option<CiStatus> {
    let output = run_cmd_in_dir("gh", &["pr", "checks", branch, "--json", "bucket"], dir)?;
    let checks: Vec<serde_json::Value> = serde_json::from_str(&output).ok()?;
    if checks.is_empty() {
        return None;
    }
    let buckets: Vec<&str> = checks
        .iter()
        .filter_map(|c| c["bucket"].as_str())
        .collect();
    Some(if buckets.contains(&"fail") {
        CiStatus::Fail
    } else if buckets.contains(&"pending") {
        CiStatus::Pending
    } else {
        CiStatus::Pass
    })
}

fn fetch_pr_comments(dir: &str, branch: &str) -> Option<u32> {
    let output = run_cmd_in_dir(
        "gh",
        &["pr", "view", branch, "--json", "reviewThreads"],
        dir,
    )?;
    let data: serde_json::Value = serde_json::from_str(&output).ok()?;
    let threads = data["reviewThreads"].as_array()?;
    let unresolved = threads
        .iter()
        .filter(|t| !t["isResolved"].as_bool().unwrap_or(true))
        .count();
    Some(unresolved as u32)
}

fn fetch_claude_status(session: &str) -> ClaudeStatus {
    let path = format!("/tmp/claude-status-{}", session);
    match std::fs::read_to_string(&path) {
        Ok(contents) => match contents.trim() {
            "working" => ClaudeStatus::Working,
            "waiting" => ClaudeStatus::Waiting,
            "idle" => ClaudeStatus::Idle,
            _ => ClaudeStatus::Off,
        },
        Err(_) => ClaudeStatus::Off,
    }
}

fn build_session(name: &str) -> Session {
    let dir = fetch_env(name, "SESSION_DIR").or_else(|| fetch_pane_path(name));
    let repo = fetch_env(name, "SESSION_REPO").or_else(|| dir.clone());

    let claude_status = fetch_claude_status(name);
    let branch = dir.as_deref().and_then(fetch_branch);

    let (pr_status, ci_status, pr_comments) = match (&dir, &branch) {
        (Some(d), Some(b)) => {
            let d1 = d.clone();
            let b1 = b.clone();
            let d2 = d.clone();
            let b2 = b.clone();
            let d3 = d.clone();
            let b3 = b.clone();

            thread::scope(|s| {
                let pr = s.spawn(move || fetch_pr_status(&d1, &b1));
                let ci = s.spawn(move || fetch_ci_status(&d2, &b2));
                let comments = s.spawn(move || fetch_pr_comments(&d3, &b3));
                (pr.join().ok().flatten(), ci.join().ok().flatten(), comments.join().ok().flatten())
            })
        }
        _ => (None, None, None),
    };

    Session {
        name: name.to_string(),
        dir,
        repo,
        branch,
        pr_status,
        ci_status,
        pr_comments,
        claude_status,
    }
}

pub fn fetch_all() -> Vec<Session> {
    let names = match run_cmd("tmux", &["list-sessions", "-F", "#{session_name}"]) {
        Some(output) => output.lines().map(String::from).collect::<Vec<_>>(),
        None => return Vec::new(),
    };

    if names.is_empty() {
        return Vec::new();
    }

    thread::scope(|s| {
        let handles: Vec<_> = names
            .iter()
            .map(|name| {
                let name = name.clone();
                s.spawn(move || build_session(&name))
            })
            .collect();

        handles
            .into_iter()
            .filter_map(|h| h.join().ok())
            .collect()
    })
}
