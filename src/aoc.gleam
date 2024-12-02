import birl
import birl/duration
import gleam/float
import gleam/int
import gleam/io
import gleam/string
import gleam_community/ansi
import simplifile

pub fn get_input(day: Int, filename: String) {
  simplifile.read(
    "./priv/input/day_" <> int.to_string(day) <> "/" <> filename <> ".txt",
  )
}

pub fn get_example_input(day: Int) {
  simplifile.read("./priv/input/day_" <> int.to_string(day) <> "/example.txt")
}

pub fn run(
  day day: Int,
  example_answer_1 example_answer_1: a,
  part_1 part_1: fn(String) -> a,
  example_answer_2 example_answer_2: b,
  part_2 part_2: fn(String) -> b,
) -> Nil {
  io.println(ansi.blue("PART 1:"))
  run_part(day, example_answer_1, part_1)
  io.println("")
  io.println(ansi.blue("PART 2:"))
  run_part(day, example_answer_2, part_2)
}

pub fn run_part(
  day day: Int,
  example_answer example_answer: a,
  part part: fn(String) -> a,
) {
  let assert Ok(example) = get_input(day, "example")
  let answer = part(example)
  case part(example) == example_answer {
    True ->
      io.println(ansi.green(
        "✅ Example passed: "
        <> string.inspect(answer)
        <> " == "
        <> string.inspect(example_answer),
      ))
    False ->
      io.println(ansi.red(
        "❌ Example failed: "
        <> string.inspect(answer)
        <> " != "
        <> string.inspect(example_answer),
      ))
  }

  let assert Ok(input) = get_input(day, "input")
  use <- timeit()
  io.println("ANSWER:")
  part(input) |> string.inspect |> io.println
}

pub fn timeit(fun: fn() -> a) {
  let start = birl.now()
  let a = fun()
  let dur =
    birl.difference(birl.now(), start)
    |> duration.blur_to(duration.MilliSecond)
    |> int.to_float

  let message = "ran in " <> dur /. 1000.0 |> float.to_string <> "s"
  io.println(ansi.yellow(message))
  a
}
