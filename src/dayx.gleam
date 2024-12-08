import aoc24/lib.{str}
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() {
  let day = todo

  io.println("")

  let ex_p1 = example_input() |> part1()
  io.println("[day " <> str(day) <> "][part 1] example: " <> str(ex_p1))

  let real_p1 = lib.puzzle_input(day) |> part1()
  io.println("[day " <> str(day) <> "][part 1] real: " <> str(real_p1))

  io.println("")

  let ex_p2 = example_input() |> part2()
  io.println("[day " <> str(day) <> "][part 2] example: " <> str(ex_p2))

  let real_p2 = lib.puzzle_input(day) |> part2()
  io.println("[day " <> str(day) <> "][part 2] real: " <> str(real_p2))

  io.println("")
}

pub fn part1(input: String) {
  todo

  0
}

pub fn part2(input: String) {
  todo

  0
}

pub fn example_input() {
  todo
}
