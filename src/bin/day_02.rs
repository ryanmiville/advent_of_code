use std::fs;
use std::fs::File;
use std::io::{self, BufRead};


#[derive(Debug)]
struct Part1 {
    ids: Vec<u64>,
}

#[derive(Debug)]
struct Part2 {
    ids: Vec<u64>,
}


fn main() {
    let answer = part_1().unwrap();
    println!("Part 1: {:?}", answer);

    let answer = part_2().unwrap();
    println!("Part 2: {:?}", answer);

}

fn part_1() -> Result<u64, Box<dyn std::error::Error>> {
    let input = fs::read_to_string("input/day_02/input.txt")?;

    let mut state = Part1 { ids: Vec::new() };

    for element in input.split(',') {
        println!("{}", element);
        let (a, b) = parse(element)?;
        if b < 11 { continue }
        add_repeating(a, b, &mut state);
    }

    Ok(state.ids.iter().map(|&x| x as u64).sum())
}

fn part_2() -> Result<u64, Box<dyn std::error::Error>> {
    let input = fs::read_to_string("input/day_02/example.txt")?;

    let mut state = Part2 { ids: Vec::new() };

    for element in input.split(',') {
        println!("{}", element);
        let (a, b) = parse(element)?;
        if b < 11 { continue }
        let candidates = candidates(a);
        let candidates = candidates.iter().copied().filter(|&x| x as u64 <= b);
        state.ids.extend(candidates);
    }

    println!("{:?}", state.ids);
    Ok(state.ids.iter().map(|&x| x as u64).sum())
}

fn parse(element: &str) -> Result<(u64, u64), Box<dyn std::error::Error>> {
    let (a, b) = element.split_once('-').ok_or_else(|| "parse error")?;
    let a = a.parse()?;
    let b = b.parse()?;
    Ok((a, b))
}

fn add_repeating(start: u64, end: u64, state: &mut Part1) {
    let mut rep = next_repeating(start);
    while rep <= u64::from(end) {
        state.ids.push(rep);
        rep = next_repeating(rep + 1);
    }
}

fn next_repeating(start: u64) -> u64 {
    if start <= 11 {
        return 11;
    }

    let len = start.ilog10() + 1;

    match len % 2 {
        1 => {
            let len = (len + 1) / 2;
            let a = 10u64.pow(len - 1);
            a * (10u64.pow(len) + 1)
        }
        _ => {
            let len = len / 2;
            let (a, b) = split_number(start, len);
            let a = if a < b { a + 1 } else { a };
            a * (10u64.pow(len) + 1)
        }
    }
}


fn next_repeating_by(start: u64, num_repeats: u32) -> u64 {
    let start = if start == 0 { 1 } else { start };

    let len = start.ilog10() + 1;

    match len % num_repeats {
        0 => {
            let len = len / num_repeats;
            let a = take_digits(start, len);
            let res = repeat(a, num_repeats);
            if res < start {
                res
            } else {
                repeat(a + 1, num_repeats)
            }
        }
        rem => {
            let len = (len + rem) / num_repeats;
            let a = 10u64.pow(len - 1);
            a * (10u64.pow(len) + 1)
        }
    }
}

fn split_number(num: u64, at: u32) -> (u64, u64) {
    let divisor = 10u64.pow(at);
    (num / divisor, num % divisor)
}


fn candidates(n: u64) -> Vec<u64> {
    let len = n.ilog10() + 1;
    eprint
    let mut factors = factors(len);

    let mut results = Vec::new();

    for f in factors {
        let reps = len / f;
        let prefix = take_digits(n, f);
        let candidate = repeat(prefix, reps);
        if candidate >= n {
            results.push(candidate);
        } else {
            let prefix = prefix + 1;
            if prefix.ilog10() + 1 == len {
                let candidate = repeat(prefix, reps);
                results.push(candidate);
            }
        }
    }
    results
}


fn factors(n: u32) -> Vec<u32> {
    let mut result = Vec::new();
    let limit = (n as f64).sqrt() as u32;

    for i in 1..=limit {
        if n % i == 0 {
            result.push(i);
            let other = n / i;
            if other != i {
                result.push(other);
            }
        }
    }
    result
}

fn take_digits(n: u64, num_digits: u32) -> u64 {
    let len = n.ilog10() + 1;
    let k = len.saturating_sub(num_digits);
    n / 10u64.pow(k)
}

fn repeat(x: u64, n: u32) -> u64 {
    let digits = {
        let mut d = 1u64;
        let mut temp = x;
        while temp >= 10 {
            temp /= 10;
            d *= 10;
        }
        d * 10
    };

    let mut result = 0u64;
    for _ in 0..n {
        result = result * digits + x;
    }
    result
}
