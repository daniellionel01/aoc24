import aoc24/lib.{str}
import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string

pub fn main() {
  let day = 6

  io.println("")

  let ex_p1 = example_input() |> part1()
  io.println("[day " <> str(day) <> "][part 1] example: " <> str(ex_p1))

  let real_p1 = lib.puzzle_input(day) |> part1()
  io.println("[day " <> str(day) <> "][part 1] real: " <> str(real_p1))

  io.println("")

  // let ex_p2 = example_input() |> part2()
  // io.println("[day " <> str(day) <> "][part 2] example: " <> str(ex_p2))

  // let real_p2 = lib.puzzle_input(day) |> part2()
  // io.println("[day " <> str(day) <> "][part 2] real: " <> str(real_p2))

  io.println("")
}

type Direction {
  Up
  Right
  Down
  Left
}

const current = "^"

const visited = "X"

const obstacle = "#"

/// #(x, y)
fn get_delta(dir: Direction) -> #(Int, Int) {
  case dir {
    Up -> #(0, -1)
    Right -> #(1, 0)
    Down -> #(0, 1)
    Left -> #(-1, 0)
  }
}

fn turn_right(dir: Direction) {
  case dir {
    Up -> Right
    Right -> Down
    Down -> Left
    Left -> Up
  }
}

fn find_index(chars: List(String)) {
  case chars {
    [char, ..rest] if char != current -> {
      1 + find_index(rest)
    }
    _ -> 0
  }
}

/// #(x, y)
fn index_to_pos(index: Int, width: Int) -> #(Int, Int) {
  let x = index % width
  let y = { int.to_float(index) /. int.to_float(width) } |> lib.ftoi

  #(x, y)
}

fn pos_to_index(x: Int, y: Int, width: Int) -> Int {
  x + y * width
}

fn part1_loop(
  chars: List(String),
  index: Int,
  width: Int,
  dir: Direction,
) -> List(String) {
  let delta = get_delta(dir)

  let #(x, y) = index_to_pos(index, width)

  let #(x2, y2) = #(x + delta.0, y + delta.1)

  let chars =
    list.index_map(chars, fn(el, el_idx) {
      case index == el_idx {
        True -> visited
        False -> el
      }
    })

  let height = list.length(chars) / width
  let in_bounds = case x2, y2 {
    x2, y2 if x2 < 0 || y2 < 0 || x2 >= width || y2 >= height -> False
    _, _ -> True
  }

  use <- bool.guard(when: !in_bounds, return: chars)

  let index2 = pos_to_index(x2, y2, width)
  let next_char = lib.item_at_def(chars, index2)

  case next_char {
    next_char if next_char == obstacle -> {
      turn_right(dir)
      |> part1_loop(chars, index, width, _)
    }
    _ -> {
      part1_loop(chars, index2, width, dir)
    }
  }
}

pub fn part1(input: String) {
  let width =
    input
    |> string.split("\n")
    |> list.map(string.trim)
    |> list.first()
    |> result.unwrap("")
    |> string.length

  let chars =
    input
    |> string.to_graphemes
    |> list.filter(fn(char) { char != "\n" })

  let index = find_index(chars)

  part1_loop(chars, index, width, Up)
  |> string.join("")
  |> string.to_graphemes
  |> list.count(fn(c) { c == visited })
}

pub fn part2(input: String) {
  todo

  0
}

pub fn example_input() {
  "
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
  "
  |> string.trim()
}
