import aoc
import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{Some}
import gleam/result
import gleam/string

pub fn main() {
  aoc.run(day: 4, part_1: Some(#(18, part_1)), part_2: Some(#(9, part_2)))
}

pub fn part_1(input: String) {
  input |> parse |> find_words
}

pub fn part_2(input: String) {
  input |> parse |> solve_part_2
}

fn parse(input: String) -> Puzzle {
  let lines = string.split(input, "\n")
  use acc, line, row <- list.index_fold(lines, dict.new())
  let letters = string.to_graphemes(line)
  use acc, letter, col <- list.index_fold(letters, acc)
  dict.insert(acc, #(row, col), new(letter))
}

fn new(letter: String) -> Letter {
  case letter {
    "X" -> X
    "M" -> M
    "A" -> A
    "S" -> S
    other -> Other(other)
  }
}

pub type Puzzle =
  Dict(#(Int, Int), Letter)

pub type Letter {
  X
  M
  A
  S
  Other(String)
}

pub type Direction {
  Left
  Right
  Up
  Down
  UpLeft
  UpRight
  DownLeft
  DownRight
}

pub fn find_words(p: Puzzle) -> Int {
  let xs = find_all(p, X)
  use acc, cell <- list.fold(xs, 0)
  let next_cells = surrounding(p, cell)
  let count = {
    use #(next_cell, letter, direction) <- list.count(next_cells)
    next(p, next_cell, letter, X, direction)
  }
  acc + count
}

pub fn solve_part_2(p: Puzzle) {
  let aa = find_all(p, A)
  use acc, cell <- list.fold(aa, 0)
  let top_left = next_cell(p, cell, UpLeft) |> result.map(fn(x) { x.1 })
  let top_right = next_cell(p, cell, UpRight) |> result.map(fn(x) { x.1 })
  let bot_left = next_cell(p, cell, DownLeft) |> result.map(fn(x) { x.1 })
  let bot_right = next_cell(p, cell, DownRight) |> result.map(fn(x) { x.1 })
  case top_left, bot_right, bot_left, top_right {
    Ok(M), Ok(S), Ok(M), Ok(S) -> acc + 1
    Ok(M), Ok(S), Ok(S), Ok(M) -> acc + 1
    Ok(S), Ok(M), Ok(M), Ok(S) -> acc + 1
    Ok(S), Ok(M), Ok(S), Ok(M) -> acc + 1
    _, _, _, _ -> acc
  }
}

pub fn find_all(p: Puzzle, letter: Letter) -> List(#(Int, Int)) {
  dict.filter(p, fn(_, v) { v == letter })
  |> dict.keys
}

pub fn surrounding(
  p: Puzzle,
  cell: #(Int, Int),
) -> List(#(#(Int, Int), Letter, Direction)) {
  [
    next_cell(p, cell, Down),
    next_cell(p, cell, DownLeft),
    next_cell(p, cell, DownRight),
    next_cell(p, cell, Left),
    next_cell(p, cell, Right),
    next_cell(p, cell, Up),
    next_cell(p, cell, UpLeft),
    next_cell(p, cell, UpRight),
  ]
  |> result.values
}

pub fn next(
  p: Puzzle,
  cell: #(Int, Int),
  current: Letter,
  previous: Letter,
  direction: Direction,
) -> Bool {
  case previous, current {
    A, S -> True
    X, M | M, A -> {
      {
        use #(next_cell, letter, _) <- result.map(next_cell(p, cell, direction))
        next(p, next_cell, letter, current, direction)
      }
      |> result.unwrap(False)
    }
    _, _ -> False
  }
}

pub fn next_cell(
  p: Puzzle,
  cell: #(Int, Int),
  direction: Direction,
) -> Result(#(#(Int, Int), Letter, Direction), Nil) {
  let #(row, col) = cell

  let next_cell = case direction {
    Down -> #(row + 1, col)
    DownLeft -> #(row + 1, col - 1)
    DownRight -> #(row + 1, col + 1)
    Left -> #(row, col - 1)
    Right -> #(row, col + 1)
    Up -> #(row - 1, col)
    UpLeft -> #(row - 1, col - 1)
    UpRight -> #(row - 1, col + 1)
  }

  use letter <- result.map(dict.get(p, next_cell))
  #(next_cell, letter, direction)
}
