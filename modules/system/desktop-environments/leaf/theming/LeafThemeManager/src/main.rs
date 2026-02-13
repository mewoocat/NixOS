use std::process::Command;
use std::env::args;
use clap::Parser;

// Type to store and validate cli arguments
#[derive(Parser, Debug)] // Attribute for providing clap parser trait to our Cli struct
struct Cli {
    #[arg(short = 'i', long = "image_path")]
    image_path: std::path::PathBuf,
}

fn print_type_of<T>(_: &T) {
    println!("{}", std::any::type_name::<T>());
}

fn main() {

    // Get cli args
    let image_path = args().nth(1).expect("image path not provided");

    // Since our Cli class dervives the clap::Parser trait, we can call parse() on it 
    // to get an instance of Cli with the arguments set as it's properties.
    let args: Cli = Cli::parse();
    //let args_type = std::any::type_name::<&args>()
    print_type_of(&args);

    println!("arg 1 {}", image_path);
    println!("args via clap {:?}", args);

    let command = Command::new("sh")
        .arg("-c")
        .arg("matugen image ")
        .output()
        .expect("failed to run command");
    let output = String::from_utf8(command.stdout).unwrap(); // what.
    let error = String::from_utf8(command.stderr).unwrap();
    println!("output: {}", output);
    eprintln!("error: {:?}", error);

    println!("debug what {:?}", 1);
}
