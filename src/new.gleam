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
    simplifile.write("./src/" <> label <> ".gleam", template(day))
}

fn template(day: String) {
  "import aoc
import gleam/option.{None}

pub fn main() {
  aoc.run(day: " <> day <> ", part_1: None, part_2: None)
}

pub fn part_1(_input: String) {
  todo
}

pub fn part_2(_input: String) {
  todo
}

fn parse(_input: String) {
  todo
}
"
}
