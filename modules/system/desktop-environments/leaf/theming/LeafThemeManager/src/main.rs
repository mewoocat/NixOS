use std::process::Command;

fn main() {
    println!("Hello, world!");

    let command = Command::new("sh")
        .arg("-c")
        .arg("poopoo")
        .output()
        .expect("failed to run command");
    let output = String::from_utf8(command.stdout).unwrap(); // what.
    let error = command.stderr;
    println!("output: {}", output);
    eprintln!("error: {:?}", error);

    println!("debug what {:?}", 1);
}
