import birl
import birl/duration
import gleam/float
import gleam/int
import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/string
import gleam_community/ansi
import simplifile
import spinner

pub fn get_input(day: Int, filename: String) {
  simplifile.read(
    "./priv/input/day_" <> int.to_string(day) <> "/" <> filename <> ".txt",
  )
}

pub fn get_example_input(day: Int) {
  simplifile.read("./priv/input/day_" <> int.to_string(day) <> "/example.txt")
}

pub type Part(a) =
  #(a, fn(String) -> a)

pub fn run(
  day day: Int,
  part_1 part_1: Option(Part(a)),
  part_2 part_2: Option(Part(b)),
) {
  io.println(ansi.blue("PART 1:"))
  case part_1 {
    Some(#(example, func)) -> run_part(day, example, func)
    None -> io.println(ansi.yellow("not implemented"))
  }
  io.println(ansi.blue("\nPART 2:"))
  case part_2 {
    Some(#(example, func)) -> run_part(day, example, func)
    None -> io.println(ansi.yellow("not implemented"))
  }
}

pub fn run_part(
  day day: Int,
  example_answer example_answer: a,
  part part: fn(String) -> a,
) -> Nil {
  let assert Ok(example) = get_input(day, "example")
  let answer = part(example)
  case answer == example_answer {
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
  io.print("ANSWER:")
  let answer = {
    use <- timeit()
    part(input)
  }
  io.println(string.inspect(answer))
}

pub fn timeit(fun: fn() -> a) {
  let spinner =
    spinner.new("")
    |> spinner.with_colour(ansi.dim)
    |> spinner.start()

  let start = birl.now()
  let a = fun()
  let dur =
    birl.difference(birl.now(), start)
    |> duration.blur_to(duration.MilliSecond)
    |> int.to_float

  spinner.stop(spinner)

  let message = "ran in " <> dur /. 1000.0 |> float.to_string <> "s"
  io.println(ansi.yellow(message))
  a
}
