import argv
import simplifile

pub fn main() {
  let assert [day] = argv.load().arguments
  let label = "day_" <> day
  let assert Ok(_) = simplifile.create_directory_all("./priv/input/" <> label)
  let assert Ok(_) =
    simplifile.create_file("./priv/input/" <> label <> "/example.txt")
  let assert Ok(_) =
    simplifile.create_file("./priv/input/" <> label <> "/input.txt")
  let assert Ok(_) =
    simplifile.write("./src/" <> label <> ".gleam", template(label))
}

fn template(label: String) {
  "import gleam/io

pub fn main() {
  // aoc.run(day: 1, example_answer_1: 11, part_1:, example_answer_2: 31, part_2:)
  io.println(\"hello from " <> label <> "!\")
}

pub fn part_1(input: String) {
  todo
}

pub fn part_2(input: String) {
  todo
}

fn parse(input: String) {
  todo
}
"
}
