import aoc24/lib.{str}
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub fn main() {
  let day = 7

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
  let lines =
    input
    |> string.trim()
    |> string.split("\n")
    |> list.map(string.trim)

  lines
  |> list.map(fn(line) {
    let assert [sum, statements] = string.split(line, ":")

    let assert Ok(sum) = int.parse(sum)

    let statements =
      statements
      |> string.trim()
      |> string.split(" ")
      |> list.map(fn(n) {
        let assert Ok(n) = int.parse(n)
        n
      })

    #(sum, statements)
  })
  |> list.filter(fn(line) {
    let #(sum, numbers) = line
    let assert [first, ..rest] = numbers

    let ops = list.length(numbers) - 1
    let assert Ok(poss) = int.power(2, int.to_float(ops))
    let poss = float.truncate(poss)

    list.repeat(0, poss)
    |> list.index_map(fn(_, i) { i })
    |> list.map(fn(i) {
      int.to_base2(i)
      |> string.pad_start(ops, "0")
    })
    |> list.map(fn(i) {
      let map = string.to_graphemes(i)
      let zipped = list.zip(rest, map)
      let result =
        list.fold(zipped, first, fn(acc, x) {
          let #(n, bin) = x
          case bin {
            "0" -> acc + n
            "1" -> acc * n
            _ -> panic as "unexpected binary operator"
          }
        })

      result == sum
    })
    |> list.any(fn(x) { x == True })
  })
  |> list.map(fn(x) { x.0 })
  |> list.fold(0, int.add)
}

pub fn part2(input: String) {
  let lines =
    input
    |> string.trim()
    |> string.split("\n")
    |> list.map(string.trim)

  lines
  |> list.map(fn(line) {
    let assert [sum, statements] = string.split(line, ":")

    let assert Ok(sum) = int.parse(sum)

    let statements =
      statements
      |> string.trim()
      |> string.split(" ")
      |> list.map(fn(n) {
        let assert Ok(n) = int.parse(n)
        n
      })

    #(sum, statements)
  })
  |> list.filter(fn(line) {
    let #(sum, numbers) = line
    let assert [first, ..rest] = numbers

    let ops = list.length(numbers) - 1
    let assert Ok(poss) = int.power(3, int.to_float(ops))
    let poss = float.truncate(poss)

    list.repeat(0, poss)
    |> list.index_map(fn(_, i) { i })
    |> list.map(fn(i) {
      let assert Ok(based) = int.to_base_string(i, 3)
      string.pad_start(based, ops, "0")
    })
    |> list.map(fn(i) {
      let map = string.to_graphemes(i)
      let zipped = list.zip(rest, map)
      let result =
        list.fold(zipped, first, fn(acc, x) {
          let #(n, bin) = x
          case bin {
            "0" -> acc + n
            "1" -> acc * n
            "2" -> {
              { int.to_string(acc) <> int.to_string(n) }
              |> int.parse
              |> result.unwrap(0)
            }
            _ -> panic as "unexpected binary operator"
          }
        })

      result == sum
    })
    |> list.any(fn(x) { x == True })
  })
  |> list.map(fn(x) { x.0 })
  |> list.fold(0, int.add)
}

pub fn example_input() {
  "
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
  "
  |> string.trim()
}
