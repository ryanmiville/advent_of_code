import aoc
import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/result
import gleam/string

pub fn main() {
  aoc.run(day: 1, part_1: Some(#(11, part_1)), part_2: Some(#(31, part_2)))
}

pub fn part_1(input: String) {
  let #(a, b) = parse(input)
  let a = list.sort(a, int.compare)
  let b = list.sort(b, int.compare)
  let zip = list.zip(a, b)

  use acc, #(a, b) <- list.fold(zip, 0)
  acc + int.absolute_value(a - b)
}

pub fn part_2(input: String) {
  let #(a, b) = parse(input)
  let counts = {
    use acc, next <- list.fold(b, dict.new())
    dict.upsert(acc, next, fn(x) { option.unwrap(x, 0) + 1 })
  }
  use acc, next <- list.fold(a, 0)
  let count = dict.get(counts, next) |> result.unwrap(0)
  acc + next * count
}

fn parse(input: String) {
  let lines = input |> string.trim_end |> string.split("\n")
  use #(a, b), line <- list.fold(lines, #([], []))
  let assert Ok(#(e1, e2)) = string.split_once(line, "   ")
  let assert Ok(e1) = int.parse(e1)
  let assert Ok(e2) = int.parse(e2)
  #([e1, ..a], [e2, ..b])
}
