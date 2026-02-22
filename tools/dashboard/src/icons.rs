use crate::data::{CiStatus, ClaudeStatus, PrStatus};
use ratatui::style::{Color, Style};
use ratatui::text::Span;

pub fn pr_span(status: &Option<PrStatus>) -> Span<'static> {
    match status {
        Some(PrStatus::Approved) => Span::styled("✔ approved", Style::default().fg(Color::Green)),
        Some(PrStatus::Draft) => Span::styled("◌ draft", Style::default().fg(Color::Yellow)),
        Some(PrStatus::Review) => Span::styled("○ review", Style::default().fg(Color::Cyan)),
        Some(PrStatus::Changes) => Span::styled("✘ changes", Style::default().fg(Color::Red)),
        Some(PrStatus::Merged) => Span::styled("✔ merged", Style::default().fg(Color::Magenta)),
        Some(PrStatus::Closed) => Span::styled("✘ closed", Style::default().fg(Color::Red)),
        Some(PrStatus::Open) => Span::styled("○ open", Style::default().fg(Color::Cyan)),
        None => Span::styled("—", Style::default().fg(Color::DarkGray)),
    }
}

pub fn ci_span(status: &Option<CiStatus>) -> Span<'static> {
    match status {
        Some(CiStatus::Pass) => Span::styled("✔ pass", Style::default().fg(Color::Green)),
        Some(CiStatus::Fail) => Span::styled("✘ fail", Style::default().fg(Color::Red)),
        Some(CiStatus::Pending) => Span::styled("◌ pend", Style::default().fg(Color::Yellow)),
        None => Span::styled("—", Style::default().fg(Color::DarkGray)),
    }
}

pub fn claude_span(status: &ClaudeStatus) -> Span<'static> {
    match status {
        ClaudeStatus::Working => Span::styled("↻ working", Style::default().fg(Color::Yellow)),
        ClaudeStatus::Waiting => Span::styled("● waiting", Style::default().fg(Color::Cyan)),
        ClaudeStatus::Idle => Span::styled("○ idle", Style::default().fg(Color::Green)),
        ClaudeStatus::Off => Span::styled("— off", Style::default().fg(Color::DarkGray)),
    }
}

pub fn comments_span(count: &Option<u32>) -> Span<'static> {
    match count {
        Some(0) => Span::styled("0", Style::default().fg(Color::DarkGray)),
        Some(n) => Span::styled(format!("{}", n), Style::default().fg(Color::Yellow)),
        None => Span::styled("—", Style::default().fg(Color::DarkGray)),
    }
}
