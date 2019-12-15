#![recursion_limit = "256"]

use async_std::prelude::*;
use futures::channel::mpsc::channel;

use image::RgbImage;
use rscam::Camera;
use std::thread;

pub fn start_capture() -> rscam::Result<impl Stream<Item = RgbImage>> {
    let mut camera = Camera::new("/dev/video0")?;
    camera.start(&rscam::Config {
        interval: (1, 30),
        resolution: (1280, 720),
        format: b"RGB3",
        ..Default::default()
    })?;
    let (mut send, recv) = channel(0);
    thread::spawn(move || loop {
        let frame = camera.capture().unwrap();
        let image =
            RgbImage::from_vec(frame.resolution.0, frame.resolution.1, Vec::from(&*frame)).unwrap();
        match send.try_send(image) {
            Ok(_) => {}
            Err(e) => {
                if e.is_disconnected() {
                    return;
                }
            }
        }
    });
    Ok(recv)
}
