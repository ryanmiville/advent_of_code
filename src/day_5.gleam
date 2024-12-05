import aoc
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/order.{type Order}
import gleam/string

pub fn main() {
  aoc.run(day: 5, part_1: Some(#(143, part_1)), part_2: Some(#(123, part_2)))
}

pub fn part_1(input: String) {
  let #(rules, updates) = input |> parse

  updates
  |> list.filter(is_valid(_, rules))
  |> list.fold(0, fn(acc, u) { acc + get_mid(u) })
}

pub fn part_2(input: String) {
  let #(rules, updates) = input |> parse

  updates
  |> list.filter(fn(u) { !is_valid(u, rules) })
  |> list.fold(0, fn(acc, u) { acc + { fix_invalid(u, rules) |> get_mid } })
}

fn parse(input: String) {
  let input = string.trim_end(input)
  let assert Ok(#(rules_input, updates_input)) =
    string.split_once(input, "\n\n")

  let rules = parse_rules(rules_input)

  let updates = parse_updates(updates_input)
  #(rules, updates)
}

fn parse_rules(input: String) -> Rules {
  let rule_list = do_parse_rules(input)
  use acc, rule <- list.fold(rule_list, dict.new())
  add_rule(acc, rule)
}

fn do_parse_rules(input: String) -> List(Rule) {
  use line <- list.map(string.split(input, "\n"))
  let assert Ok(#(l, r)) = line |> string.split_once("|")
  let assert Ok(l) = int.parse(l)
  let assert Ok(r) = int.parse(r)
  #(l, r)
}

fn parse_updates(input: String) -> List(List(Int)) {
  use line <- list.map(string.split(input, "\n"))
  use num <- list.map(line |> string.split(","))
  let assert Ok(num) = int.parse(num)
  num
}

type Page {
  Page(before: List(Int))
}

type Rules =
  Dict(Int, Page)

type Rule =
  #(Int, Int)

fn add_rule(rules: Rules, rule: Rule) -> Rules {
  dict.upsert(rules, rule.0, fn(page) {
    case page {
      Some(p) -> p
      None -> Page([])
    }
  })
  |> dict.upsert(rule.1, fn(page) {
    case page {
      Some(p) -> Page(before: [rule.0, ..p.before])
      None -> Page([rule.0])
    }
  })
}

fn is_valid(update: List(Int), rules: Rules) {
  is_sorted(update, compare(rules))
}

fn compare(rules: Rules) {
  fn(a, b) {
    let assert Ok(p) = dict.get(rules, a)
    case list.contains(p.before, b) {
      True -> order.Gt
      False -> order.Lt
    }
  }
}

fn is_sorted(list: List(a), compare: fn(a, a) -> Order) {
  list.window_by_2(list)
  |> list.all(fn(window) {
    let #(a, b) = window
    compare(a, b) != order.Gt
  })
}

fn get_mid(list: List(a)) -> a {
  let len = list.length(list)
  let assert Ok(mid) =
    list
    |> list.drop(len / 2)
    |> list.first
  mid
}

fn fix_invalid(update: List(Int), rules: Rules) {
  list.sort(update, compare(rules))
}
