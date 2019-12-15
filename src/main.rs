use async_std::prelude::*;
use std::time::Instant;

#[async_std::main]
async fn main() {
    let mut capture = switchbot::start_capture().unwrap();
    let mut frames = 0;
    let start = Instant::now();
    let mut last = start;
    while let Some(_) = capture.next().await {
        frames += 1;
        let now = Instant::now();
        let diff = (now - start).as_secs_f64();
        let time = (now - last).as_secs_f64();
        let fps = 1.0 / time;
        last = now;
        println!("{} frames in {:.3} seconds ({:.3}fps)", frames, diff, fps);
    }
}
