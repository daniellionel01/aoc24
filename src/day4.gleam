import aoc24/lib.{str}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/string

pub fn main() {
  let day = 4

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
  let chars =
    string.to_graphemes(input)
    |> list.filter(fn(char) { char != "\n" })

  let lines =
    input
    |> string.trim
    |> string.split("\n")
    |> list.map(string.trim)

  let assert [first_line, ..] = lines

  let cols = string.length(first_line) |> int.to_float
  let rows = list.length(lines) |> int.to_float

  let get_row_col = fn(index: Int) -> #(Int, Int) {
    let row = { int.to_float(index) /. cols } |> lib.ftoi
    let col = index % lib.ftoi(rows)
    #(row, col)
  }

  let init_mask = fn() { list.map(chars, fn(_) { 0 }) }

  let max_col = lib.ftoi(cols) - 4
  let max_row = lib.ftoi(rows) - 4

  let xmas =
    chars
    |> list.index_fold(#([], init_mask()), fn(acc, _, index) {
      let #(hashes, mask) = acc

      let #(row, col) = get_row_col(index)

      case col > max_col || row > max_row {
        True -> acc
        False -> {
          let assert Some(line1) = lib.item_at(lines, row)
          let assert Some(line2) = lib.item_at(lines, row + 1)
          let assert Some(line3) = lib.item_at(lines, row + 2)
          let assert Some(line4) = lib.item_at(lines, row + 3)

          let line1 = string.slice(line1, at_index: col, length: 4)
          let line2 = string.slice(line2, at_index: col, length: 4)
          let line3 = string.slice(line3, at_index: col, length: 4)
          let line4 = string.slice(line4, at_index: col, length: 4)

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
            [line1, line2, line3, line4]
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

          let dia_right =
            [
              lib.item_at_def(string.to_graphemes(line1), 0),
              lib.item_at_def(string.to_graphemes(line2), 1),
              lib.item_at_def(string.to_graphemes(line3), 2),
              lib.item_at_def(string.to_graphemes(line4), 3),
            ]
            |> string.join("")
            |> check_xmas
            |> fn(val) {
              case val {
                True ->
                  list.flatten([
                    [1, 0, 0, 0],
                    [0, 1, 0, 0],
                    [0, 0, 1, 0],
                    [0, 0, 0, 1],
                  ])
                False -> four_by_four_mask()
              }
            }

          let dia_left =
            [
              lib.item_at_def(string.to_graphemes(line1), 3),
              lib.item_at_def(string.to_graphemes(line2), 2),
              lib.item_at_def(string.to_graphemes(line3), 1),
              lib.item_at_def(string.to_graphemes(line4), 0),
            ]
            |> string.join("")
            |> check_xmas
            |> fn(val) {
              case val {
                True ->
                  list.flatten([
                    [0, 0, 0, 1],
                    [0, 0, 1, 0],
                    [0, 1, 0, 0],
                    [1, 0, 0, 0],
                  ])
                False -> four_by_four_mask()
              }
            }

          let combined =
            row_lines
            |> zip_and_sum(col_lines)
            |> zip_and_sum(dia_right)
            |> zip_and_sum(dia_left)

          let check_hashes = fn(hashes: List(Int), bin_mask: List(Int)) {
            let bin_rows = list.sized_chunk(bin_mask, 4)
            let assert [row1, row2, row3, row4] = bin_rows

            let bin_cols = [
              [
                lib.item_at_def(row1, 0),
                lib.item_at_def(row2, 0),
                lib.item_at_def(row3, 0),
                lib.item_at_def(row4, 0),
              ],
              [
                lib.item_at_def(row1, 1),
                lib.item_at_def(row2, 1),
                lib.item_at_def(row3, 1),
                lib.item_at_def(row4, 1),
              ],
              [
                lib.item_at_def(row1, 2),
                lib.item_at_def(row2, 2),
                lib.item_at_def(row3, 2),
                lib.item_at_def(row4, 2),
              ],
              [
                lib.item_at_def(row1, 3),
                lib.item_at_def(row2, 3),
                lib.item_at_def(row3, 3),
                lib.item_at_def(row4, 3),
              ],
            ]
            let assert [row1, row2, row3, row4] = bin_rows
            let assert [col1, col2, col3, col4] = bin_cols

            let hashes = case row1 {
              [1, 1, 1, 1] -> {
                let h = hash(index, index + 1, index + 2, index + 3)
                [h, ..hashes]
              }
              _ -> hashes
            }
            let hashes = case row2 {
              [1, 1, 1, 1] -> {
                let index = index + lib.ftoi(cols)
                let h = hash(index, index + 1, index + 2, index + 3)
                [h, ..hashes]
              }
              _ -> hashes
            }
            let hashes = case row3 {
              [1, 1, 1, 1] -> {
                let index = index + lib.ftoi(cols) * 2
                let h = hash(index, index + 1, index + 2, index + 3)
                [h, ..hashes]
              }
              _ -> hashes
            }
            let hashes = case row4 {
              [1, 1, 1, 1] -> {
                let index = index + lib.ftoi(cols) * 3
                let h = hash(index, index + 1, index + 2, index + 3)
                [h, ..hashes]
              }
              _ -> hashes
            }

            let hashes = case col1 {
              [1, 1, 1, 1] -> {
                let colsi = lib.ftoi(cols)
                let h =
                  hash(
                    index,
                    index + colsi,
                    index + colsi * 2,
                    index + colsi * 3,
                  )
                [h, ..hashes]
              }
              _ -> hashes
            }
            let hashes = case col2 {
              [1, 1, 1, 1] -> {
                let colsi = lib.ftoi(cols)
                let h =
                  hash(
                    index + 1,
                    index + colsi + 1,
                    index + colsi * 2 + 1,
                    index + colsi * 3 + 1,
                  )
                [h, ..hashes]
              }
              _ -> hashes
            }
            let hashes = case col3 {
              [1, 1, 1, 1] -> {
                let colsi = lib.ftoi(cols)
                let h =
                  hash(
                    index + 2,
                    index + colsi + 2,
                    index + colsi * 2 + 2,
                    index + colsi * 3 + 2,
                  )
                [h, ..hashes]
              }
              _ -> hashes
            }
            let hashes = case col4 {
              [1, 1, 1, 1] -> {
                let colsi = lib.ftoi(cols)
                let h =
                  hash(
                    index + 3,
                    index + colsi + 3,
                    index + colsi * 2 + 3,
                    index + colsi * 3 + 3,
                  )
                [h, ..hashes]
              }
              _ -> hashes
            }

            let dia_right = [
              lib.item_at_def(row1, 0),
              lib.item_at_def(row2, 1),
              lib.item_at_def(row3, 2),
              lib.item_at_def(row4, 3),
            ]
            let hashes = case dia_right {
              [1, 1, 1, 1] -> {
                let colsi = lib.ftoi(cols)
                let h =
                  hash(
                    index,
                    index + colsi + 1,
                    index + colsi * 2 + 2,
                    index + colsi * 3 + 3,
                  )
                [h, ..hashes]
              }
              _ -> hashes
            }

            let dia_left = [
              lib.item_at_def(row1, 3),
              lib.item_at_def(row2, 2),
              lib.item_at_def(row3, 1),
              lib.item_at_def(row4, 0),
            ]
            let hashes = case dia_left {
              [1, 1, 1, 1] -> {
                let colsi = lib.ftoi(cols)
                let h =
                  hash(
                    index + 3,
                    index + colsi + 2,
                    index + colsi * 2 + 1,
                    index + colsi * 3,
                  )
                [h, ..hashes]
              }
              _ -> hashes
            }

            hashes
          }

          let hashes = check_hashes(hashes, row_lines)
          let hashes = check_hashes(hashes, col_lines)
          let hashes = check_hashes(hashes, dia_right)
          let hashes = check_hashes(hashes, dia_left)

          let mask =
            list.index_fold(combined, mask, fn(acc, cur, local_idx) {
              let local_row = { int.to_float(local_idx) /. 4.0 } |> lib.ftoi
              let local_col = local_idx % 4

              let update_row = row + local_row
              let update_col = col + local_col

              let update_index = update_row * lib.ftoi(cols) + update_col
              let current = lib.item_at_def(acc, update_index)

              lib.update_at(acc, update_index, current + cur)
            })

          #(hashes, mask)
        }
      }
    })

  let #(hashes, _) = xmas

  list.length(list.unique(hashes))
}

pub fn part2(input: String) {
  let chars =
    string.to_graphemes(input)
    |> list.filter(fn(char) { char != "\n" })

  let lines =
    input
    |> string.trim
    |> string.split("\n")
    |> list.map(string.trim)

  let assert [first_line, ..] = lines

  let cols = string.length(first_line) |> int.to_float
  let rows = list.length(lines) |> int.to_float

  let get_row_col = fn(index: Int) -> #(Int, Int) {
    let row = { int.to_float(index) /. cols } |> lib.ftoi
    let col = index % lib.ftoi(rows)
    #(row, col)
  }

  let init_mask = fn() { list.map(chars, fn(_) { 0 }) }

  let max_col = lib.ftoi(cols) - 3
  let max_row = lib.ftoi(rows) - 3

  let xmas =
    chars
    |> list.index_fold(#([], init_mask()), fn(acc, _, index) {
      let #(hashes, mask) = acc

      let #(row, col) = get_row_col(index)

      case col > max_col || row > max_row {
        True -> acc
        False -> {
          let assert Some(line1) = lib.item_at(lines, row)
          let assert Some(line2) = lib.item_at(lines, row + 1)
          let assert Some(line3) = lib.item_at(lines, row + 2)

          let line1 = string.slice(line1, at_index: col, length: 3)
          let line2 = string.slice(line2, at_index: col, length: 3)
          let line3 = string.slice(line3, at_index: col, length: 3)

          let check_xmas = fn(str: String) {
            case str {
              "MAS" | "SAM" -> True
              _ -> False
            }
          }

          let dia_right =
            [
              lib.item_at_def(string.to_graphemes(line1), 0),
              lib.item_at_def(string.to_graphemes(line2), 1),
              lib.item_at_def(string.to_graphemes(line3), 2),
            ]
            |> string.join("")
            |> check_xmas
            |> fn(val) {
              case val {
                True -> list.flatten([[1, 0, 0], [0, 1, 0], [0, 0, 1]])
                False -> three_by_three_mask()
              }
            }

          let dia_left =
            [
              lib.item_at_def(string.to_graphemes(line1), 2),
              lib.item_at_def(string.to_graphemes(line2), 1),
              lib.item_at_def(string.to_graphemes(line3), 0),
            ]
            |> string.join("")
            |> check_xmas
            |> fn(val) {
              case val {
                True -> list.flatten([[0, 0, 1], [0, 1, 0], [1, 0, 0]])
                False -> three_by_three_mask()
              }
            }

          let combined = zip_and_sum(dia_left, dia_right)

          let is_cross = case combined {
            [1, 0, 1, 0, 2, 0, 1, 0, 1] -> True
            _ -> False
          }
          let combined = case is_cross {
            False -> three_by_three_mask()
            True -> combined
          }

          let hashes = case is_cross {
            False -> hashes
            True -> {
              let h =
                cross_hash(
                  index,
                  index + 2,
                  index + 3 + 1,
                  index + 3 * 2,
                  index + 3 * 2 + 2,
                )
              [h, ..hashes]
            }
          }

          let mask =
            list.index_fold(combined, mask, fn(acc, cur, local_idx) {
              let local_row = { int.to_float(local_idx) /. 3.0 } |> lib.ftoi
              let local_col = local_idx % 3

              let update_row = row + local_row
              let update_col = col + local_col

              let update_index = update_row * lib.ftoi(cols) + update_col
              let current = lib.item_at_def(acc, update_index)

              lib.update_at(acc, update_index, current + cur)
            })

          #(hashes, mask)
        }
      }
    })

  let #(hashes, _) = xmas

  list.length(list.unique(hashes))
}

fn hash(a: Int, b: Int, c: Int, d: Int) {
  a * 1234 + b * 237 + c * 819 + d * 195
}

fn cross_hash(a: Int, b: Int, c: Int, d: Int, e: Int) {
  a * 1234 + b * 237 + c * 819 + d * 195 + e * 410
}

fn four_by_four_mask() {
  [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
  |> list.flatten
}

fn three_by_three_mask() {
  [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
  |> list.flatten
}

fn zip_and_sum(a: List(Int), b: List(Int)) {
  list.zip(a, b)
  |> list.map(fn(el) {
    let #(l, r) = el
    l + r
  })
}

pub fn example_input() {
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
