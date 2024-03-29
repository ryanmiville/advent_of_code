use deno_bindgen::deno_bindgen;
use nom::{
    branch::alt,
    bytes::complete::{tag, take_until},
    character::{
        complete::{digit1, newline},
        streaming::alpha1,
    },
    combinator::map_res,
    multi::separated_list1,
    sequence::{delimited, tuple},
    *,
};

#[deno_bindgen]
#[derive(Debug, PartialEq)]
pub struct State {
    stacks: Vec<Vec<String>>,
    moves: Vec<Move>,
}

#[deno_bindgen]
pub fn day5_part1(input: &str) -> State {
    part1(input)
}

fn part1(input: &str) -> State {
    let (_, (stacks, _, moves)) = tuple((stacks, drop_until_move, crate_moves))(input).unwrap();
    State { stacks, moves }
}

type Crate = String;

type CrateStack = Vec<Crate>;

#[deno_bindgen]
#[derive(Debug, PartialEq)]
struct Move {
    count: usize,
    from: usize,
    to: usize,
}

fn spaces(input: &str) -> IResult<&str, Option<Crate>> {
    nom::combinator::map(tag("   "), |_| Option::None)(input)
}

fn crate_opt(input: &str) -> IResult<&str, Option<Crate>> {
    let alpha = alpha1.map(|s: &str| Option::Some(s.to_string()));
    let parser = delimited(tag("["), alpha, tag("]"));
    alt((parser, spaces))(input)
}

fn row(input: &str) -> IResult<&str, Vec<Option<Crate>>> {
    separated_list1(tag(" "), crate_opt)(input)
}

fn stacks_input(input: &str) -> IResult<&str, &str> {
    take_until(" 1")(input)
}

fn stacks(input: &str) -> IResult<&str, Vec<CrateStack>> {
    let (input, stack_input) = stacks_input(input)?;
    let (_, stacks_of_opts) = separated_list1(newline, row)(stack_input)?;
    let crate_stacks = make_stacks(stacks_of_opts);
    Ok((input, crate_stacks))
}

fn make_stacks(v: Vec<Vec<Option<Crate>>>) -> Vec<Vec<Crate>> {
    let num_stacks = v[0].len();
    let mut ss: Vec<CrateStack> = vec![vec![]; num_stacks];
    for r in v.iter() {
        for (j, k) in r.iter().enumerate() {
            if let Some(e) = k {
                ss[j].push(e.clone())
            }
        }
    }
    ss
}

fn drop_until_move(input: &str) -> IResult<&str, &str> {
    take_until("move")(input)
}

fn num(input: &str) -> IResult<&str, usize> {
    map_res(digit1, str::parse)(input)
}

fn crate_move(input: &str) -> IResult<&str, Move> {
    let (input, (_, count, _, from, _, to)) =
        tuple((tag("move "), num, tag(" from "), num, tag(" to "), num))(input)?;

    Ok((input, Move { count, from, to }))
}

fn crate_moves(input: &str) -> IResult<&str, Vec<Move>> {
    separated_list1(newline, crate_move)(input)
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = "    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2";

    macro_rules! vec_strings {
        ($($x:expr),*) => (vec![$($x.to_string()),*]);
    }

    #[test]
    fn part1_works() {
        let result = part1(INPUT);
        let expected = State {
            stacks: vec![
                vec_strings!["N", "Z"],
                vec_strings!["D", "C", "M"],
                vec_strings!["P"],
            ],
            moves: vec![
                Move {
                    count: 1,
                    from: 2,
                    to: 1,
                },
                Move {
                    count: 3,
                    from: 1,
                    to: 3,
                },
                Move {
                    count: 2,
                    from: 2,
                    to: 1,
                },
                Move {
                    count: 1,
                    from: 1,
                    to: 2,
                },
            ],
        };
        assert_eq!(result, expected)
    }
}
