import aoc
import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string

pub fn main() {
  aoc.run(day: 6, part_1: Some(#(41, part_1)), part_2: None)
}

pub fn part_1(input: String) {
  parse(input) |> do_part_1
}

pub fn part_2(_input: String) {
  todo
}

fn parse(input: String) -> State {
  let input = string.trim_end(input)
  let lines = string.split(input, "\n")
  use state, line, row <- list.index_fold(lines, empty_state())
  let cells = string.to_graphemes(line)
  use state, cell, col <- list.index_fold(cells, state)
  let guard = case cell {
    "^" -> Some(Guard(#(row, col), Up))
    ">" -> Some(Guard(#(row, col), Right))
    "<" -> Some(Guard(#(row, col), Left))
    "v" -> Some(Guard(#(row, col), Down))
    _ -> state.guard
  }
  let map = state.map |> dict.insert(#(row, col), new_status(cell))
  State(map, guard, 1)
}

type Status {
  Empty(visited: Bool)
  Obstacle
}

fn empty_state() {
  State(dict.new(), None, 0)
}

type Position =
  #(Int, Int)

type Map =
  Dict(Position, Status)

fn new_status(cell: String) -> Status {
  case cell {
    "#" -> Obstacle
    "." -> Empty(False)
    _ -> Empty(True)
  }
}

type Direction {
  Left
  Right
  Up
  Down
}

type Guard {
  Guard(position: Position, direction: Direction)
}

type State {
  State(map: Map, guard: Option(Guard), acc: Int)
}

fn do_part_1(state: State) {
  case state.guard {
    Some(_) -> next(state).acc
    _ -> state.acc
  }
}

fn next(state: State) -> State {
  let assert Some(guard) = state.guard

  let next_pos = case guard {
    Guard(#(r, c), Left) -> #(r, c - 1)
    Guard(#(r, c), Down) -> #(r + 1, c)
    Guard(#(r, c), Right) -> #(r, c + 1)
    Guard(#(r, c), Up) -> #(r - 1, c)
  }
  case dict.get(state.map, next_pos) {
    Ok(Obstacle) ->
      State(
        ..state,
        guard: Some(Guard(..guard, direction: turn(guard.direction))),
      )
      |> next
    Ok(Empty(True)) ->
      State(..state, guard: Some(Guard(next_pos, guard.direction))) |> next
    Ok(Empty(False)) -> {
      let map = dict.insert(state.map, next_pos, Empty(True))
      State(map, Some(Guard(next_pos, guard.direction)), state.acc + 1)
      |> next
    }
    _ -> State(..state, guard: None)
  }
}

fn turn(dir: Direction) -> Direction {
  case dir {
    Down -> Left
    Left -> Up
    Right -> Down
    Up -> Right
  }
}
