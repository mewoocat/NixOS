use std::process::Command;

fn main() {
    println!("Hello, world!");

    let command = Command::new("sh")
        .arg("-c")
        .arg("echo welcome")
        .output()
        .expect("failed to run command");
    let output = String::from_utf8(command.stdout).unwrap(); // what.
    println!("output: {}", output);
}
