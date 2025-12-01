use std::fs::File;
use std::io::{self, BufRead};

#[derive(Debug)]
struct Part1 {
    current: u8,
    zero_count: u32,
}

impl Part1 {
    pub fn new() -> Self {
        Part1 { current: 50, zero_count: 0 }
    }

    pub fn right(&mut self, steps: u32) {
        let steps = (steps % 100) as u8;
        self.current = (self.current + steps) % 100;
        self.check_zero();
    }

    pub fn left(&mut self, steps: u32) {
        let steps = (steps % 100) as u8;
        self.current = (self.current + 100 - steps) % 100;
        self.check_zero();
    }

    fn check_zero(&mut self) {
        if self.current == 0 {
            self.zero_count += 1;
        }
    }
}

#[derive(Debug)]
struct Part2 {
    current: u8,
    zero_count: u32,
}

impl Part2 {
    pub fn new() -> Self {
        Part2 { current: 50, zero_count: 0 }
    }

    pub fn right(&mut self, steps: u32) {
        let acc = steps + u32::from(self.current);
        self.zero_count += acc / 100;
        self.current = (acc % 100) as u8;
    }

    pub fn left(&mut self, steps: u32) {
        let acc = steps + (100 - u32::from(self.current)) % 100;
        self.zero_count += acc / 100;
        self.current = (100 - (acc % 100)) as u8 % 100;
    }
}

fn main() {
    let answer = part_1().unwrap();
    println!("Part 1: {:?}", answer);

    let answer = part_2().unwrap();
    println!("Part 2: {:?}", answer);

}

fn part_1() -> Result<Part1, Box<dyn std::error::Error>> {
    let input = File::open("input/day_01/part_01.txt")?;
    let reader = io::BufReader::new(input);
    let mut pos = Part1::new();
    for line in reader.lines() {
        let line = line?;
        if line.is_empty() {
            continue;
        }
        let dir = line.as_bytes()[0];
        let num: u32 = line[1..].parse()?;

        match dir {
            b'R' => pos.right(num),
            b'L' => pos.left(num),
            _ => return Err("Invalid direction".into()),
        }
    }
    Ok(pos)
}

fn part_2() -> Result<Part2, Box<dyn std::error::Error>> {
    let input = File::open("input/day_01/part_01.txt")?;
    let reader = io::BufReader::new(input);
    let mut state = Part2::new();
    for line in reader.lines() {
        let line = line?;
        if line.is_empty() {
            continue;
        }
        let dir = line.as_bytes()[0];
        let num: u32 = line[1..].parse()?;

        match dir {
            b'R' => state.right(num),
            b'L' => state.left(num),
            _ => return Err("Invalid direction".into()),
        }
    }
    Ok(state)
}
