import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn day1() {
  let assert Ok(input) = simplifile.read("./priv/input1.txt")

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

  io.debug(sum)
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
