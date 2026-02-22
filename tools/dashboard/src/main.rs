mod app;
mod cache;
mod data;
mod icons;
mod ui;

use app::{Action, App};
use std::io;
use std::os::unix::process::CommandExt;
use std::process::Command;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::{mpsc, Arc};
use std::time::Duration;

enum Event {
    Key(crossterm::event::KeyEvent),
    Tick,
    Refresh(Vec<data::Session>),
}

fn main() -> io::Result<()> {
    // Load cached sessions for instant first render
    let cached = cache::load();

    if cached.is_empty() {
        // Also try a quick fetch in case there's no cache
        let sessions = data::fetch_all();
        if sessions.is_empty() {
            println!("No tmux sessions found.");
            print!("Create a new session? [Y/n] ");
            io::Write::flush(&mut io::stdout())?;
            let mut answer = String::new();
            io::stdin().read_line(&mut answer)?;
            let answer = answer.trim().to_lowercase();
            if answer.is_empty() || answer == "y" {
                let err = Command::new("workon").exec();
                eprintln!("Failed to exec workon: {}", err);
            }
            return Ok(());
        }
        return run_app(sessions);
    }

    run_app(cached)
}

fn run_app(initial_sessions: Vec<data::Session>) -> io::Result<()> {
    let mut terminal = ratatui::init();
    let result = run_event_loop(&mut terminal, initial_sessions);
    ratatui::restore();
    result
}

fn run_event_loop(
    terminal: &mut ratatui::DefaultTerminal,
    initial_sessions: Vec<data::Session>,
) -> io::Result<()> {
    let mut app = App::new(initial_sessions);
    let (tx, rx) = mpsc::channel::<Event>();
    let force_refresh = Arc::new(AtomicBool::new(false));

    // Background refresh thread
    let refresh_tx = tx.clone();
    let refresh_flag = Arc::clone(&force_refresh);
    std::thread::spawn(move || {
        loop {
            let sessions = data::fetch_all();
            cache::save(&sessions);
            let _ = refresh_tx.send(Event::Refresh(sessions));

            // Sleep for 2s in 100ms intervals, checking force flag
            for _ in 0..20 {
                if refresh_flag.swap(false, Ordering::Relaxed) {
                    break;
                }
                std::thread::sleep(Duration::from_millis(100));
            }
        }
    });

    // Input thread
    let input_tx = tx.clone();
    std::thread::spawn(move || loop {
        if crossterm::event::poll(Duration::from_millis(200)).unwrap_or(false) {
            if let Ok(crossterm::event::Event::Key(key)) = crossterm::event::read() {
                let _ = input_tx.send(Event::Key(key));
            }
        } else {
            let _ = input_tx.send(Event::Tick);
        }
    });

    // Main loop
    terminal.draw(|f| ui::draw(f, &mut app))?;

    loop {
        match rx.recv() {
            Ok(Event::Key(key)) => {
                let action = app.handle_key(key);
                match action {
                    Action::Quit => break,
                    Action::SwitchSession(name) => {
                        ratatui::restore();
                        let inside_tmux =
                            std::env::var("TMUX").map_or(false, |v| !v.is_empty());
                        if inside_tmux {
                            let err = Command::new("tmux")
                                .args(["switch-client", "-t", &name])
                                .exec();
                            eprintln!("Failed to exec: {}", err);
                        } else {
                            let err = Command::new("tmux")
                                .args(["attach-session", "-t", &name])
                                .exec();
                            eprintln!("Failed to exec: {}", err);
                        }
                        return Ok(());
                    }
                    Action::NewSession => {
                        ratatui::restore();
                        let status = Command::new("workon").status();
                        if let Ok(s) = status {
                            if s.success() {
                                let inside_tmux =
                                    std::env::var("TMUX").map_or(false, |v| !v.is_empty());
                                if !inside_tmux {
                                    // Attach to the most recently created session
                                    if let Some(output) = run_cmd_for_main(
                                        "tmux",
                                        &[
                                            "list-sessions",
                                            "-F",
                                            "#{session_created} #{session_name}",
                                        ],
                                    ) {
                                        if let Some(last_line) = output.lines().last() {
                                            if let Some(name) =
                                                last_line.split_once(' ').map(|(_, n)| n)
                                            {
                                                let err = Command::new("tmux")
                                                    .args(["attach-session", "-t", name])
                                                    .exec();
                                                eprintln!("Failed to exec: {}", err);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        // Re-init terminal and force refresh
                        *terminal = ratatui::init();
                        force_refresh.store(true, Ordering::Relaxed);
                    }
                    Action::CloseSession(name) => {
                        ratatui::restore();
                        let _ = Command::new("wrapup").arg(&name).status();
                        // Re-init terminal and force refresh
                        *terminal = ratatui::init();
                        force_refresh.store(true, Ordering::Relaxed);
                    }
                    Action::ForceRefresh => {
                        force_refresh.store(true, Ordering::Relaxed);
                    }
                    Action::None => {}
                }
            }
            Ok(Event::Refresh(sessions)) => {
                app.update_sessions(sessions);
            }
            Ok(Event::Tick) => {
                // Just redraw on tick for cursor blink etc
            }
            Err(_) => break,
        }
        terminal.draw(|f| ui::draw(f, &mut app))?;
    }

    Ok(())
}

fn run_cmd_for_main(cmd: &str, args: &[&str]) -> Option<String> {
    let output = Command::new(cmd).args(args).output().ok()?;
    if output.status.success() {
        Some(String::from_utf8_lossy(&output.stdout).trim().to_string())
    } else {
        None
    }
}
