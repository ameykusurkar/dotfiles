use crate::data::Session;
use ratatui::widgets::TableState;

#[derive(Debug, PartialEq)]
pub enum InputMode {
    Normal,
    Filter,
}

pub enum Action {
    None,
    Quit,
    SwitchSession(String),
    NewSession,
    CloseSession(String),
    ForceRefresh,
}

pub struct App {
    pub sessions: Vec<Session>,
    pub table_state: TableState,
    pub input_mode: InputMode,
    pub filter: String,
    pub loading: bool,
}

impl App {
    pub fn new(sessions: Vec<Session>) -> Self {
        let mut table_state = TableState::default();
        if !sessions.is_empty() {
            table_state.select(Some(0));
        }
        App {
            sessions,
            table_state,
            input_mode: InputMode::Normal,
            filter: String::new(),
            loading: true,
        }
    }

    pub fn filtered_sessions(&self) -> Vec<&Session> {
        if self.filter.is_empty() {
            self.sessions.iter().collect()
        } else {
            self.sessions
                .iter()
                .filter(|s| s.name.contains(&self.filter))
                .collect()
        }
    }

    pub fn selected_session_name(&self) -> Option<String> {
        let filtered = self.filtered_sessions();
        self.table_state
            .selected()
            .and_then(|i| filtered.get(i))
            .map(|s| s.name.clone())
    }

    pub fn update_sessions(&mut self, new_sessions: Vec<Session>) {
        let prev_name = self.selected_session_name();
        self.sessions = new_sessions;
        self.loading = false;

        let filtered = self.filtered_sessions();
        if filtered.is_empty() {
            self.table_state.select(None);
        } else {
            // Try to keep the same session selected
            let idx = prev_name
                .and_then(|name| filtered.iter().position(|s| s.name == name))
                .unwrap_or(0);
            self.table_state.select(Some(idx.min(filtered.len() - 1)));
        }
    }

    fn clamp_selection(&mut self) {
        let len = self.filtered_sessions().len();
        if len == 0 {
            self.table_state.select(None);
        } else {
            let idx = self.table_state.selected().unwrap_or(0);
            self.table_state.select(Some(idx.min(len - 1)));
        }
    }

    pub fn handle_key(&mut self, key: crossterm::event::KeyEvent) -> Action {
        use crossterm::event::{KeyCode, KeyModifiers};

        match self.input_mode {
            InputMode::Normal => match key.code {
                KeyCode::Char('q') | KeyCode::Esc => Action::Quit,
                KeyCode::Char('j') | KeyCode::Down => {
                    let len = self.filtered_sessions().len();
                    if len > 0 {
                        let i = self.table_state.selected().unwrap_or(0);
                        self.table_state.select(Some((i + 1) % len));
                    }
                    Action::None
                }
                KeyCode::Char('k') | KeyCode::Up => {
                    let len = self.filtered_sessions().len();
                    if len > 0 {
                        let i = self.table_state.selected().unwrap_or(0);
                        self.table_state
                            .select(Some(if i == 0 { len - 1 } else { i - 1 }));
                    }
                    Action::None
                }
                KeyCode::Enter => {
                    if let Some(name) = self.selected_session_name() {
                        Action::SwitchSession(name)
                    } else {
                        Action::None
                    }
                }
                KeyCode::Char('n') => Action::NewSession,
                KeyCode::Char('x') => {
                    if let Some(name) = self.selected_session_name() {
                        Action::CloseSession(name)
                    } else {
                        Action::None
                    }
                }
                KeyCode::Char('r') => Action::ForceRefresh,
                KeyCode::Char('/') => {
                    self.input_mode = InputMode::Filter;
                    self.filter.clear();
                    Action::None
                }
                KeyCode::Char('c') if key.modifiers.contains(KeyModifiers::CONTROL) => {
                    Action::Quit
                }
                _ => Action::None,
            },
            InputMode::Filter => match key.code {
                KeyCode::Esc => {
                    self.input_mode = InputMode::Normal;
                    self.filter.clear();
                    self.clamp_selection();
                    Action::None
                }
                KeyCode::Enter => {
                    self.input_mode = InputMode::Normal;
                    self.clamp_selection();
                    Action::None
                }
                KeyCode::Backspace => {
                    self.filter.pop();
                    self.clamp_selection();
                    Action::None
                }
                KeyCode::Char(c) => {
                    self.filter.push(c);
                    self.clamp_selection();
                    Action::None
                }
                _ => Action::None,
            },
        }
    }
}
