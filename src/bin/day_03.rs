use std::fs::File;
use std::io::{self, BufRead};


fn main() {
    let answer = part_1().unwrap();
    println!("Part 1: {:?}", answer);

    let answer = part_2().unwrap();
    println!("Part 2: {:?}", answer);

}

fn part_1() -> Result<u64, Box<dyn std::error::Error>> {
    let input = File::open("input/day_03/input.txt")?;
    let reader = io::BufReader::new(input);
    let mut total: u64 = 0;
    for line in reader.lines() {
        let line = line?;
        if line.is_empty() {
            continue;
        }
        let answer = solve_bank(line.as_bytes());
        total += u64::from(answer);
    }
    Ok(total)
}

fn solve_bank(bank: &[u8]) -> u8 {
    let mut max: u8 = 0;
    let mut max_index = 0;
    for (i, &byte) in bank[..bank.len()-1].iter().enumerate() {
        let byte = byte - b'0';
        if byte == 9 {
            max = byte;
            max_index = i;
            break;
        }
        if byte > max {
            max = byte;
            max_index = i;
        }
    }

    let rest: &[u8] = &bank[max_index+1..];
    let mut second: u8 = 0;
    for &byte in rest {
        second = second.max(byte - b'0');
    }

    eprintln!("max: {}, second: {}", max, second);
    max * 10 + second
}

#[test]
fn solve_bank_test() {
    assert_eq!(solve_bank("12345".as_bytes()), 45);
}

#[test]
fn solve_bank_2_test() {
    assert_eq!(solve_bank_2("987654321111111".as_bytes(), 12, 0), 987654321111);
    assert_eq!(solve_bank_2("811111111111119".as_bytes(), 12, 0), 811111111119);
    assert_eq!(solve_bank_2("234234234234278".as_bytes(), 12, 0), 434234234278);
    assert_eq!(solve_bank_2("818181911112111".as_bytes(), 12, 0), 888911112111);
}

fn solve_bank_2(bank: &[u8], size: u8, mut acc: u64) -> u64 {
    if size == 0 {
        return acc;
    }
    let sub_bank: &[u8] = &bank[..bank.len() - usize::from(size) + 1];

    let mut max: u8 = 0;
    let mut max_index = 0;
    for (i, &byte) in sub_bank.iter().enumerate() {
        let byte = byte - b'0';
        if byte == 9 {
            max = byte;
            max_index = i;
            break;
        }
        if byte > max {
            max = byte;
            max_index = i;
        }
    }


    acc += u64::from(max) * 10u64.pow(u32::from(size) - 1);
    // let rest: &[u8] = &bank[max_index+1..];
    // let size = size -1;
    solve_bank_2(&bank[max_index+1..], size -1, acc)
}
fn part_2() -> Result<u64, Box<dyn std::error::Error>> {
    let input = File::open("input/day_03/input.txt")?;
    let reader = io::BufReader::new(input);
    let mut total: u64 = 0;
    for line in reader.lines() {
        let line = line?;
        if line.is_empty() {
            continue;
        }
        let answer = solve_bank_2(line.as_bytes(), 12, 0);
        total += answer;
    }
    Ok(total)
}
