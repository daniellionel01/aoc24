import aoc24/lib
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/string

pub fn main() {
  io.debug("hello")

  let lines = ["_X__", "XMAS", "_A__", "_S__"]

  let row = 0
  let col = 0

  let assert Some(line1) = lib.item_at(lines, row)
  let assert Some(line2) = lib.item_at(lines, row + 1)
  let assert Some(line3) = lib.item_at(lines, row + 2)
  let assert Some(line4) = lib.item_at(lines, row + 3)

  io.println(line1)
  io.println(line2)
  io.println(line3)
  io.println(line4)

  let get_col_line = fn(n: Int) {
    [
      lib.item_at_def(string.to_graphemes(line1), n),
      lib.item_at_def(string.to_graphemes(line2), n),
      lib.item_at_def(string.to_graphemes(line3), n),
      lib.item_at_def(string.to_graphemes(line4), n),
    ]
    |> string.join("")
  }

  let check_xmas = fn(str: String) {
    case str {
      "XMAS" | "SAMX" -> True
      _ -> False
    }
  }

  let row_lines =
    [
      string.slice(line1, at_index: col, length: 4),
      string.slice(line2, at_index: col, length: 4),
      string.slice(line3, at_index: col, length: 4),
      string.slice(line4, at_index: col, length: 4),
    ]
    |> list.map(check_xmas)
    |> list.map(fn(xmas) {
      case xmas {
        True -> [1, 1, 1, 1]
        False -> [0, 0, 0, 0]
      }
    })
    |> list.flatten

  let col_lines =
    [get_col_line(0), get_col_line(1), get_col_line(2), get_col_line(3)]
    |> list.map(check_xmas)
    |> list.index_fold(four_by_four_mask(), fn(acc, cur, index) {
      case cur {
        False -> acc
        True -> {
          acc
          |> lib.update_at(index, 1)
          |> lib.update_at(index + 4, 1)
          |> lib.update_at(index + 8, 1)
          |> lib.update_at(index + 12, 1)
        }
      }
    })

  let combined =
    list.zip(row_lines, col_lines)
    |> list.map(fn(el) {
      let #(a, b) = el
      a + b
    })

  row_lines
  |> list.sized_chunk(4)
  |> list.each(fn(line) {
    list.each(line, fn(el) { io.print(lib.str(el)) })
    io.print("\n")
  })
  io.println("")

  col_lines
  |> list.sized_chunk(4)
  |> list.each(fn(line) {
    list.each(line, fn(el) { io.print(lib.str(el)) })
    io.print("\n")
  })
  io.println("")

  combined
  |> list.sized_chunk(4)
  |> list.each(fn(line) {
    list.each(line, fn(el) { io.print(lib.str(el)) })
    io.print("\n")
  })
  io.println("")
}

fn four_by_four_mask() {
  [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
  |> list.flatten
}

fn example_input() {
  let nl = "\n"
  "MMMSXXMASM"
  <> nl
  <> "MSAMXMSMSA"
  <> nl
  <> "AMXSXMAAMM"
  <> nl
  <> "MSAMASMSMX"
  <> nl
  <> "XMASAMXAMM"
  <> nl
  <> "XXAMMXXAMA"
  <> nl
  <> "SMSMSASXSS"
  <> nl
  <> "SAXAMASAAA"
  <> nl
  <> "MAMMMXMMMM"
  <> nl
  <> "MXMXAXMASX"
}
