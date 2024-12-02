import aoc24/lib
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() {
  io.println("")

  let ex_p1 = example_input() |> day1_part1()
  io.println("[day 1][part 1] example: " <> int.to_string(ex_p1))

  let ex_p2 = example_input() |> day1_part1()
  io.println("[day 1][part 2] example: " <> int.to_string(ex_p2))

  io.println("")

  let real_p1 = lib.puzzle_input(1) |> day1_part1()
  io.println("[day 1][part 1] real: " <> int.to_string(real_p1))

  let real_p2 = lib.puzzle_input(1) |> day1_part2()
  io.println("[day 1][part 2] real: " <> int.to_string(real_p2))

  io.println("")
}

pub fn example_input() {
  let nl = "\n"
  "3   4"
  <> nl
  <> "4   3"
  <> nl
  <> "2   5"
  <> nl
  <> "1   3"
  <> nl
  <> "3   9"
  <> nl
  <> "3   3"
}

pub fn day1_part2(input: String) {
  let lines =
    input
    |> string.trim()
    |> string.split("\n")

  let pairs = list.map(lines, fn(line) { string.split(line, "   ") })

  let left =
    list.map(pairs, fn(el) {
      let assert [l, _] = el
      let assert Ok(v) = int.parse(l)
      v
    })
  let right =
    list.map(pairs, fn(el) {
      let assert [_, r] = el
      let assert Ok(v) = int.parse(r)
      v
    })

  let scores =
    list.map(left, fn(el) {
      let matches =
        right
        |> list.filter(fn(el2) { el == el2 })
        |> list.length
      el * matches
    })

  let sum = list.fold(scores, 0, fn(acc, cur) { acc + cur })

  sum
}

pub fn day1_part1(input: String) {
  let lines =
    input
    |> string.trim()
    |> string.split("\n")

  let pairs = list.map(lines, fn(line) { string.split(line, "   ") })

  let left =
    list.map(pairs, fn(el) {
      let assert [l, _] = el
      let assert Ok(v) = int.parse(l)
      v
    })
  let right =
    list.map(pairs, fn(el) {
      let assert [_, r] = el
      let assert Ok(v) = int.parse(r)
      v
    })

  let pairs = pair_up(left, right, [])

  let diffs =
    pairs
    |> list.map(fn(pair) {
      let #(l, r) = pair
      int.absolute_value(l - r)
    })

  let sum = list.fold(diffs, 0, fn(acc, cur) { acc + cur })

  sum
}

fn pair_up(left: List(Int), right: List(Int), acc: List(#(Int, Int))) {
  let left = list.sort(left, by: int.compare)
  let smallest = list.first(left)

  case smallest {
    Error(Nil) -> acc
    Ok(smallest) -> {
      let assert [_, ..left] = left
      let assert [smallest_right, ..right] = list.sort(right, by: int.compare)

      let acc = [#(smallest, smallest_right), ..acc]

      pair_up(left, right, acc)
    }
  }
}
