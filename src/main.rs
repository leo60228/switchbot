use async_std::prelude::*;
use std::time::Instant;

#[async_std::main]
async fn main() {
    let mut capture = switchbot::start_capture().unwrap();
    let mut frames = 0;
    let start = Instant::now();
    while let Some(_) = capture.next().await {
        frames += 1;
        let diff = (Instant::now() - start).as_secs_f64();
        println!("{} frames in {} seconds ({}fps)", frames, diff, (frames as f64) / diff);
    }
}
