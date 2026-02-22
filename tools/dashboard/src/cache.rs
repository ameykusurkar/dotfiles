use crate::data::Session;
use std::fs;
use std::io::Write;
use std::path::Path;

const CACHE_PATH: &str = "/tmp/dashboard-cache.json";

pub fn load() -> Vec<Session> {
    let path = Path::new(CACHE_PATH);
    if !path.exists() {
        return Vec::new();
    }
    let contents = match fs::read_to_string(path) {
        Ok(c) => c,
        Err(_) => return Vec::new(),
    };
    serde_json::from_str(&contents).unwrap_or_default()
}

pub fn save(sessions: &[Session]) {
    let json = match serde_json::to_string_pretty(sessions) {
        Ok(j) => j,
        Err(_) => return,
    };
    // Atomic write: write to temp file, then rename
    let tmp_path = format!("{}.tmp", CACHE_PATH);
    let result = (|| -> std::io::Result<()> {
        let mut f = fs::File::create(&tmp_path)?;
        f.write_all(json.as_bytes())?;
        f.sync_all()?;
        fs::rename(&tmp_path, CACHE_PATH)?;
        Ok(())
    })();
    if result.is_err() {
        let _ = fs::remove_file(&tmp_path);
    }
}
