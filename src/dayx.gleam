import aoc24/lib
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() {
  let day = todo

  io.println("")

  let ex_p1 = example_input() |> part1()
  io.println("[day " <> day <> "][part 1] example: " <> int.to_string(ex_p1))

  let ex_p2 = example_input() |> part2()
  io.println("[day " <> day <> "][part 2] example: " <> int.to_string(ex_p2))

  io.println("")

  let real_p1 = lib.puzzle_input(1) |> part1()
  io.println("[day " <> day <> "][part 1] real: " <> int.to_string(real_p1))

  let real_p2 = lib.puzzle_input(1) |> part2()
  io.println("[day " <> day <> "][part 2] real: " <> int.to_string(real_p2))

  io.println("")
}

pub fn example_input() {
  let nl = "\n"
  todo
}

pub fn part1(input: String) {
  todo
}

pub fn part2(input: String) {
  todo
}
