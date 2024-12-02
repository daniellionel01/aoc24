import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import simplifile

pub fn day2_part1() {
  let assert Ok(input) = simplifile.read("./priv/input2.txt")

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

  io.debug(list.length(safe_levels))
}

pub fn day2_part2() {
  let assert Ok(input) = simplifile.read("./priv/input2.txt")

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

  io.debug(list.length(safe_levels))
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
