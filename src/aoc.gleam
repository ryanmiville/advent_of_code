import birl
import birl/duration
import gleam/float
import gleam/int
import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import gleam_community/ansi
import simplifile
import spinner

pub fn get_input(day: Int, filename: String) {
  simplifile.read(
    "./priv/input/day_" <> int.to_string(day) <> "/" <> filename <> ".txt",
  )
}

pub fn get_input_2(day: Int, filename: String) {
  simplifile.read(
    "./priv/input/day_" <> int.to_string(day) <> "/" <> filename <> "2.txt",
  )
  |> result.or(get_input(day, filename))
}

pub fn get_example_input(day: Int) {
  simplifile.read("./priv/input/day_" <> int.to_string(day) <> "/example.txt")
}

pub fn get_example_input_2(day: Int) {
  simplifile.read("./priv/input/day_" <> int.to_string(day) <> "/example2.txt")
  |> result.or(get_example_input(day))
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
    Some(#(example_answer, func)) -> {
      let assert Ok(example) = get_example_input(day)
      let assert Ok(input) = get_input(day, "input")
      run_part(example, input, example_answer, func)
    }
    None -> io.println(ansi.yellow("not implemented"))
  }
  io.println(ansi.blue("\nPART 2:"))
  case part_2 {
    Some(#(example_answer, func)) -> {
      let assert Ok(example) = get_example_input_2(day)
      let assert Ok(input) = get_input_2(day, "input")
      run_part(example, input, example_answer, func)
    }
    None -> io.println(ansi.yellow("not implemented"))
  }
}

pub fn run_part(
  example: String,
  input: String,
  example_answer example_answer: a,
  part part: fn(String) -> a,
) -> Nil {
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
