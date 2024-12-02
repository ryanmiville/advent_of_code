import aoc
import atto
import atto/ops
import atto/text
import atto/text_util
import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/result

pub fn main() {
  aoc.run(day: 1, example_answer_1: 11, part_1:, example_answer_2: 31, part_2:)
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

fn parse(input: String) -> #(List(Int), List(Int)) {
  let line_parser = {
    use a <- atto.do(text_util.decimal() |> text_util.ws)
    use b <- atto.do(text_util.decimal() |> text_util.ws)
    atto.pure(#(a, b))
  }
  let parser = ops.many(line_parser)

  let assert Ok(parsed) = atto.run(parser, text.new(input), Nil)
  list.unzip(parsed)
}
