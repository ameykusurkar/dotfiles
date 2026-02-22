use crate::app::{App, InputMode};
use crate::icons;
use ratatui::layout::{Constraint, Layout};
use ratatui::style::{Color, Style};
use ratatui::text::{Line, Span, Text};
use ratatui::widgets::{Cell, Row, Table};
use ratatui::Frame;

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

    let rows: Vec<Row> = filtered
        .iter()
        .map(|s| {
            // Col 1: Session name (row 1), empty (row 2)
            let col1 = Cell::from(Text::from(vec![
                Line::from(Span::raw(s.name.clone())),
                Line::from(""),
            ]));

            // Col 2: repo slug (row 1), branch (row 2)
            let col2 = Cell::from(Text::from(vec![
                Line::from(icons::repo_span(s.repo_slug.as_deref())),
                Line::from(icons::branch_span(s.branch.as_deref())),
            ]));

            // Col 3: PR# + CI + approval inline (row 1), empty (row 2)
            let col3 = Cell::from(Text::from(vec![
                Line::from(icons::status_line_spans(s.pr_number, &s.pr_status, &s.ci_status)),
                Line::from(""),
            ]));

            // Col 4: Claude status (row 1), empty (row 2)
            let col4 = Cell::from(Text::from(vec![
                Line::from(icons::claude_span(&s.claude_status)),
                Line::from(""),
            ]));

            Row::new(vec![col1, col2, col3, col4]).height(2)
        })
        .collect();

    let widths = [
        Constraint::Length(22),
        Constraint::Length(32),
        Constraint::Length(34),
        Constraint::Length(18),
    ];

    let table = Table::new(rows, widths)
        .row_highlight_style(Style::default().bg(Color::Rgb(40, 40, 55)))
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
