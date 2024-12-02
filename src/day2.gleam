import aoc24/lib
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string

pub fn main() {
  io.println("")

  let ex_p1 = example_input() |> day2_part1()
  io.println("[day 2][part 1] example: " <> int.to_string(ex_p1))

  let ex_p2 = example_input() |> day2_part1()
  io.println("[day 2][part 2] example: " <> int.to_string(ex_p2))

  io.println("")

  let real_p1 = lib.puzzle_input(2) |> day2_part1()
  io.println("[day 2][part 1] real: " <> int.to_string(real_p1))

  let real_p2 = lib.puzzle_input(2) |> day2_part2()
  io.println("[day 2][part 2] real: " <> int.to_string(real_p2))

  io.println("")
}

pub fn example_input() {
  let nl = "\n"
  "7 6 4 2 1"
  <> nl
  <> "1 2 7 8 9"
  <> nl
  <> "9 7 6 2 1"
  <> nl
  <> "1 3 2 4 5"
  <> nl
  <> "8 6 4 4 1"
  <> nl
  <> "1 3 6 7 9"
}

pub fn day2_part1(input: String) {
  let line_to_level = fn(line: String) -> List(Int) {
    let digits =
      line
      |> string.trim()
      |> string.split(" ")
      |> list.map(int.parse)
      |> list.map(result.unwrap(_, 0))
    digits
  }

  let levels =
    input
    |> string.trim()
    |> string.split("\n")
    |> list.map(line_to_level)

  let is_safe = fn(level: List(Int)) {
    let #(diffs, _) =
      list.fold(level, #([], None), fn(acc, cur) {
        let #(lst, last) = acc
        case last {
          None -> #(lst, Some(cur))
          Some(last) -> {
            let diff = cur - last
            #([diff, ..lst], Some(cur))
          }
        }
      })

    let increasing = list.all(diffs, fn(el) { el > 0 })
    let decreasing = list.all(diffs, fn(el) { el < 0 })

    let min_diff =
      diffs
      |> list.map(int.absolute_value)
      |> list.all(fn(el) { el >= 1 && el <= 3 })

    { increasing || decreasing } && min_diff
  }

  let safe_levels = list.filter(levels, is_safe)

  list.length(safe_levels)
}

pub fn day2_part2(input: String) {
  let line_to_level = fn(line: String) -> List(Int) {
    let digits =
      line
      |> string.trim()
      |> string.split(" ")
      |> list.map(int.parse)
      |> list.map(result.unwrap(_, 0))
    digits
  }

  let levels =
    input
    |> string.trim()
    |> string.split("\n")
    |> list.map(line_to_level)

  let is_safe = fn(level: List(Int)) {
    let #(diffs, _) =
      list.fold(level, #([], None), fn(acc, cur) {
        let #(lst, last) = acc
        case last {
          None -> #(lst, Some(cur))
          Some(last) -> {
            let diff = cur - last
            #([diff, ..lst], Some(cur))
          }
        }
      })

    let increasing = list.all(diffs, fn(el) { el > 0 })
    let decreasing = list.all(diffs, fn(el) { el < 0 })

    let min_diff =
      diffs
      |> list.map(int.absolute_value)
      |> list.all(fn(el) { el >= 1 && el <= 3 })

    { increasing || decreasing } && min_diff
  }

  let safe_levels =
    list.filter(levels, fn(level) {
      case is_safe(level) {
        True -> True
        False -> {
          permutate_level(level, [], 0)
          |> list.any(is_safe)
        }
      }
    })

  list.length(safe_levels)
}

pub fn drop_index(lst: List(a), index: Int) -> List(a) {
  list.index_fold(lst, [], fn(acc, cur, idx) {
    case index == idx {
      True -> acc
      False -> list.append(acc, [cur])
    }
  })
}

fn permutate_level(level: List(Int), acc: List(List(Int)), index: Int) {
  let end = index == list.length(level)
  case end {
    True -> acc
    False -> {
      let permutation = drop_index(level, index)
      let acc = [permutation, ..acc]
      permutate_level(level, acc, index + 1)
    }
  }
}
