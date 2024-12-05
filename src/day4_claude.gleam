//// I was not content with my own solution so I asked Claude.ai to
//// give it a shot. It's solution if quite a bit more concise than mine :(
////

import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub type Position {
  Position(row: Int, col: Int)
}

pub type Direction {
  Direction(row_delta: Int, col_delta: Int)
}

pub fn solve(input: String) -> Int {
  // Convert input string to 2D grid
  let grid =
    input
    |> string.trim
    |> string.split(on: "\n")
    |> list.map(string.to_graphemes)

  case grid {
    [] -> 0
    [first, ..] -> {
      let height = list.length(grid)
      let width = list.length(first)

      // Define all 8 possible directions
      let directions = [
        Direction(0, 1),
        // right
        Direction(1, 0),
        // down
        Direction(1, 1),
        // diagonal down-right
        Direction(-1, 1),
        // diagonal up-right
        Direction(0, -1),
        // left
        Direction(-1, 0),
        // up
        Direction(-1, -1),
        // diagonal up-left
        Direction(1, -1),
        // diagonal down-left
      ]

      // Generate all possible starting positions
      let positions =
        list.flat_map(list.range(0, height - 1), fn(row) {
          list.map(list.range(0, width - 1), fn(col) { Position(row, col) })
        })

      // Check each position in each direction
      list.fold(positions, 0, fn(count, pos) {
        count
        + list.fold(directions, 0, fn(dir_count, dir) {
          dir_count
          + case check_xmas(grid, pos, dir) {
            True -> 1
            False -> 0
          }
        })
      })
    }
  }
}

fn check_xmas(grid: List(List(String)), start: Position, dir: Direction) -> Bool {
  let target = ["X", "M", "A", "S"]

  // Check if we can make 4 steps in this direction from the starting position
  case
    can_check_position(
      grid,
      Position(start.row + dir.row_delta * 3, start.col + dir.col_delta * 3),
    )
  {
    False -> False
    True -> {
      // Check each character matches the target word
      list.index_fold(target, True, fn(acc, char, i) {
        acc
        && get_char(
          grid,
          Position(start.row + dir.row_delta * i, start.col + dir.col_delta * i),
        )
        == Ok(char)
      })
    }
  }
}

fn can_check_position(grid: List(List(String)), pos: Position) -> Bool {
  case grid {
    [] -> False
    [first, ..] -> {
      let height = list.length(grid)
      let width = list.length(first)

      pos.row >= 0 && pos.row < height && pos.col >= 0 && pos.col < width
    }
  }
}

fn get_char(grid: List(List(String)), pos: Position) -> Result(String, Nil) {
  case list.drop(grid, pos.row) {
    [] -> Error(Nil)
    [row, ..] ->
      case list.drop(row, pos.col) {
        [] -> Error(Nil)
        [char, ..] -> Ok(char)
      }
  }
}

pub fn main() {
  let example =
    "
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"

  io.println("Number of XMAS occurrences: " <> int.to_string(solve(example)))
}
