//! `pest_derive` crate has large dependency tree, and, as a build dependency,
//! it imposes these deps onto our consumers.
//!
//! To avoid that, let's just dump generated code to string into this
//! repository, and add a test that checks that the code is fresh.
use std::{
    fs,
    io::Write,
    process::{Command, Stdio},
    time::Instant,
};
/* // */
#[test]
fn generated_code_is_fresh() {
    let t = Instant::now();

    let token_stream = {
        let grammar = include_str!("../src/semver.pest");
        let input = format!(
            r###"
#[derive(Parser)]
#[grammar_inline = r#"{}"#]
struct SemverParser;
"###,
            grammar
        )
        .parse::<proc_macro2::TokenStream>()
        .unwrap();

        let ts = pest_generator::derive_parser(input.into(), true);
        eprintln!("Generated code in {:02?}", t.elapsed());
        ts
    };

    let code = {
        eprintln!("Reformatting (this will take couple of minutes)");
        let t = Instant::now();
        let code = reformat(&token_stream.to_string());
        let code = format!(
            "\
//! This is @generated code, do not edit by hand.
//! See `semver.pest` and `genpest.rs`.
#![allow(unused_attributes)]
#![rustfmt::skip]
use super::SemverParser;

{}",
            code
        );
        eprintln!("Reformatted in {:02?}", t.elapsed());

        normalize_newlines(&code)
    };

    let current = {
        let current = fs::read("./src/generated.rs").unwrap_or_default();
        let current = String::from_utf8(current).unwrap();
        normalize_newlines(&current)
    };

    if current == code {
        eprintln!("Generated code is up to date, hurray!")
    } else {
        fs::write("./src/generated.rs", code).unwrap();
        panic!("Generated code in the repository is outdated, updating...");
    }
}

fn reformat(code: &str) -> String {
    let mut cmd = Command::new("rustfmt")
        .args(&["--config", "tab_spaces=2"])
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()
        .unwrap();

    cmd.stdin
        .take()
        .unwrap()
        .write_all(code.as_bytes())
        .unwrap();
    let output = cmd.wait_with_output().unwrap();
    assert!(output.status.success());
    String::from_utf8(output.stdout).unwrap()
}

fn normalize_newlines(code: &str) -> String {
    code.replace("\r\n", "\n")
}
