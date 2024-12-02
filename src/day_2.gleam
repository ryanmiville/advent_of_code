import aoc
import gleam/bool
import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/order.{type Order}
import gleam/string

pub fn main() {
  aoc.run(2, Some(#(2, part_1)), Some(#(4, part_2)))
}

pub fn part_1(input: String) {
  input
  |> parse
  |> list.count(is_safe)
}

pub fn part_2(input: String) {
  input
  |> parse
  |> list.count(brute_force)
}

fn parse(input) -> List(Report) {
  let lines = input |> string.trim_end |> string.split("\n")
  use line <- list.map(lines)
  let assert Ok(levels) =
    line
    |> string.split(" ")
    |> list.try_map(int.parse)
  levels
}

type Report =
  List(Int)

fn is_safe(report: Report) -> Bool {
  case report {
    [a, b, ..rest] -> safe_diff(a, b) && do_is_safe(rest, int.compare(a, b), b)
    _ -> True
  }
}

fn do_is_safe(levels: List(Int), direction: Order, last: Int) -> Bool {
  case levels {
    [] -> True
    [next, ..rest] ->
      safe_diff(last, next)
      && int.compare(last, next) == direction
      && do_is_safe(rest, direction, next)
  }
}

fn safe_diff(a, b) {
  let abs = int.absolute_value(a - b)
  abs >= 1 && abs <= 3
}

fn brute_force(levels: List(Int)) -> Bool {
  use <- bool.guard(is_safe(levels), True)
  let size = list.count(levels, fn(_) { True })
  let perms = list.combinations(levels, size - 1)
  list.any(perms, is_safe)
}
