import aoc
import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/regexp.{type Match, Match}

pub fn main() {
  aoc.run(day: 3, part_1: Some(#(161, part_1)), part_2: Some(#(48, part_2)))
}

pub fn part_1(input: String) {
  use acc, #(x, y) <- list.fold(parse(input), 0)
  acc + x * y
}

pub fn part_2(input: String) {
  use acc, #(x, y) <- list.fold(parse_2(input), 0)
  acc + x * y
}

fn parse(input: String) -> List(#(Int, Int)) {
  let assert Ok(re) = regexp.from_string(mul_pattern)
  let matches = regexp.scan(re, input)
  use match <- list.map(matches)
  let assert [Some(x), Some(y)] = match.submatches
  let assert Ok(x) = int.parse(x)
  let assert Ok(y) = int.parse(y)
  #(x, y)
}

const mul_pattern = "mul\\(([0-9]|[1-9][0-9]|[1-9][0-9][0-9])\\,([0-9]|[1-9][0-9]|[1-9][0-9][0-9])\\)"

fn parse_2(input: String) -> List(#(Int, Int)) {
  let assert Ok(re) = regexp.from_string("don't|do|" <> mul_pattern)
  let matches = regexp.scan(re, input)
  do_parse_2(matches, True, [])
}

fn do_parse_2(matches: List(Match), enabled: Bool, acc: List(#(Int, Int))) {
  case enabled, matches {
    _, [] -> acc
    _, [Match("do", _), ..rest] -> do_parse_2(rest, True, acc)
    True, [Match(_, [Some(x), Some(y)]), ..rest] -> {
      let assert Ok(x) = int.parse(x)
      let assert Ok(y) = int.parse(y)
      do_parse_2(rest, True, [#(x, y), ..acc])
    }
    _, [_, ..rest] -> do_parse_2(rest, False, acc)
  }
}
