use crate::data::{CiStatus, ClaudeStatus, PrStatus};
use ratatui::style::{Color, Modifier, Style};
use ratatui::text::Span;

pub fn repo_span(slug: Option<&str>) -> Span<'static> {
    match slug {
        Some(s) => Span::styled(
            format!("\u{F09B} {}", s),
            Style::default()
                .fg(Color::White)
                .add_modifier(Modifier::BOLD),
        ),
        None => Span::styled("—", Style::default().fg(Color::DarkGray)),
    }
}

pub fn branch_span(branch: Option<&str>) -> Span<'static> {
    match branch {
        Some(b) => Span::styled(
            format!("\u{E0A0} {}", b),
            Style::default().fg(Color::Indexed(245)),
        ),
        None => Span::styled("—", Style::default().fg(Color::DarkGray)),
    }
}

fn pr_number_spans(number: Option<u32>, status: &Option<PrStatus>) -> Vec<Span<'static>> {
    match (number, status) {
        (Some(n), Some(PrStatus::Changes)) => vec![Span::styled(
            format!("\u{E728} ✘ #{}", n),
            Style::default().fg(Color::Red),
        )],
        (Some(n), Some(PrStatus::Draft)) => vec![
            Span::styled("\u{EBDB} ", Style::default().fg(Color::DarkGray)),
            Span::styled(format!("#{}", n), Style::default().fg(Color::White)),
        ],
        (Some(n), Some(PrStatus::Merged)) => vec![Span::styled(
            format!("\u{E728} #{}", n),
            Style::default().fg(Color::Magenta),
        )],
        (Some(n), Some(PrStatus::Closed)) => vec![Span::styled(
            format!("\u{E728} #{}", n),
            Style::default().fg(Color::Red),
        )],
        (Some(n), _) => vec![
            Span::styled("\u{F407} ", Style::default().fg(Color::Rgb(63, 185, 80))),
            Span::styled(format!("#{}", n), Style::default().fg(Color::White)),
        ],
        (None, _) => vec![Span::styled(
            "(no PR)",
            Style::default().fg(Color::DarkGray),
        )],
    }
}

fn ci_span(status: &Option<CiStatus>) -> Span<'static> {
    match status {
        Some(CiStatus::Pass) => Span::styled("● pass", Style::default().fg(Color::Green)),
        Some(CiStatus::Fail) => Span::styled("● fail", Style::default().fg(Color::Red)),
        Some(CiStatus::Pending) => Span::styled("● pending", Style::default().fg(Color::Yellow)),
        None => Span::styled("", Style::default()),
    }
}

fn approval_span(status: &Option<PrStatus>) -> Span<'static> {
    match status {
        Some(PrStatus::Approved) => Span::styled(
            "\u{F00C} approved",
            Style::default().fg(Color::Green),
        ),
        Some(PrStatus::Review) => Span::styled(
            "○ review",
            Style::default().fg(Color::Cyan),
        ),
        Some(PrStatus::Changes) => Span::styled(
            "✘ changes",
            Style::default().fg(Color::Red),
        ),
        _ => Span::styled("", Style::default()),
    }
}

/// Combines PR number, CI status, and approval into a single inline `Vec<Span>`.
pub fn status_line_spans(
    pr_number: Option<u32>,
    pr_status: &Option<PrStatus>,
    ci_status: &Option<CiStatus>,
) -> Vec<Span<'static>> {
    let mut spans = Vec::new();

    spans.extend(pr_number_spans(pr_number, pr_status));

    if pr_number.is_some() {
        let ci = ci_span(ci_status);
        if !ci.content.is_empty() {
            spans.push(Span::raw("  "));
            spans.push(ci);
        }

        let approval = approval_span(pr_status);
        if !approval.content.is_empty() {
            spans.push(Span::raw("  "));
            spans.push(approval);
        }
    }

    spans
}

pub fn claude_span(status: &ClaudeStatus) -> Span<'static> {
    match status {
        ClaudeStatus::Waiting => Span::styled(
            "\u{F128} waiting",
            Style::default()
                .fg(Color::Yellow)
                .add_modifier(Modifier::BOLD),
        ),
        ClaudeStatus::Working => Span::styled(
            "\u{F2DC} working",
            Style::default().fg(Color::Rgb(217, 119, 87)),
        ),
        ClaudeStatus::Idle => Span::styled(
            "\u{F186} idle",
            Style::default().fg(Color::DarkGray),
        ),
        ClaudeStatus::Off => Span::styled("—", Style::default().fg(Color::DarkGray)),
    }
}
