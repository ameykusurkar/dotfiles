use crate::app::{App, InputMode};
use crate::icons;
use ratatui::layout::{Constraint, Layout};
use ratatui::style::{Color, Modifier, Style};
use ratatui::text::{Line, Span};
use ratatui::widgets::{Cell, Row, Table};
use ratatui::Frame;
use std::path::Path;

fn truncate(s: &str, max: usize) -> String {
    if s.chars().count() > max {
        let truncated: String = s.chars().take(max - 1).collect();
        format!("{}…", truncated)
    } else {
        s.to_string()
    }
}

pub fn draw(f: &mut Frame, app: &mut App) {
    let area = f.area();

    let chunks = Layout::vertical([
        Constraint::Length(1),  // top padding
        Constraint::Min(5),    // table
        Constraint::Length(1), // help bar
        Constraint::Length(1), // filter line or bottom padding
    ])
    .split(area);

    // Table
    let filtered = app.filtered_sessions();

    let header = Row::new(vec![
        Cell::from("Session"),
        Cell::from("Repo"),
        Cell::from("Dir"),
        Cell::from("Branch"),
        Cell::from("PR"),
        Cell::from("CI"),
        Cell::from("Comments"),
        Cell::from("Claude"),
    ])
    .style(
        Style::default()
            .fg(Color::Cyan)
            .add_modifier(Modifier::BOLD),
    );

    let rows: Vec<Row> = filtered
        .iter()
        .map(|s| {
            let repo_display = s
                .repo
                .as_deref()
                .map(|r| Path::new(r).file_name().unwrap_or_default().to_string_lossy().to_string())
                .unwrap_or_else(|| "—".to_string());

            let dir_display = match (&s.dir, &s.repo) {
                (Some(d), Some(r)) if d != r => {
                    Path::new(d).file_name().unwrap_or_default().to_string_lossy().to_string()
                }
                _ => "—".to_string(),
            };

            let branch_display = s.branch.as_deref().unwrap_or("—");

            Row::new(vec![
                Cell::from(truncate(&s.name, 20)),
                Cell::from(truncate(&repo_display, 16)),
                Cell::from(truncate(&dir_display, 16)),
                Cell::from(truncate(branch_display, 20)),
                Cell::from(icons::pr_span(&s.pr_status)),
                Cell::from(icons::ci_span(&s.ci_status)),
                Cell::from(icons::comments_span(&s.pr_comments)),
                Cell::from(icons::claude_span(&s.claude_status)),
            ])
        })
        .collect();

    let widths = [
        Constraint::Length(20),
        Constraint::Length(16),
        Constraint::Length(16),
        Constraint::Length(20),
        Constraint::Length(14),
        Constraint::Length(10),
        Constraint::Length(10),
        Constraint::Length(12),
    ];

    let table = Table::new(rows, widths)
        .header(header)
        .row_highlight_style(
            Style::default()
                .add_modifier(Modifier::BOLD),
        )
        .highlight_symbol("› ")
        .column_spacing(2);

    f.render_stateful_widget(table, chunks[1], &mut app.table_state);

    // Help bar
    let help_text = if app.loading {
        Line::from(vec![
            Span::styled("  Loading...", Style::default().fg(Color::Yellow)),
        ])
    } else {
        Line::from(vec![
            Span::styled(
                "  [enter] switch   [n] new   [x] close   [r] refresh   [/] filter   [q] quit",
                Style::default().fg(Color::DarkGray),
            ),
        ])
    };
    f.render_widget(help_text, chunks[2]);

    // Filter line
    if app.input_mode == InputMode::Filter {
        let filter_line = Line::from(vec![
            Span::styled("  filter: ", Style::default().fg(Color::Yellow)),
            Span::raw(&app.filter),
        ]);
        f.render_widget(filter_line, chunks[3]);

        // Show cursor at filter input position
        f.set_cursor_position((
            (10 + app.filter.len()) as u16,
            chunks[3].y,
        ));
    }
}
