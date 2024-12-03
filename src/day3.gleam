import aoc24/lib
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string

pub fn main() {
  let day = 3

  io.println("")

  let ex_p1 = example_input() |> part1()
  io.println(
    "[day "
    <> int.to_string(day)
    <> "][part 1] example: "
    <> int.to_string(ex_p1),
  )

  let real_p1 = lib.puzzle_input(day) |> part1()
  io.println(
    "[day "
    <> int.to_string(day)
    <> "][part 1] real: "
    <> int.to_string(real_p1),
  )

  io.println("")

  let ex_p2 = example_input() |> part2()
  io.println(
    "[day "
    <> int.to_string(day)
    <> "][part 2] example: "
    <> int.to_string(ex_p2),
  )

  let real_p2 = lib.puzzle_input(day) |> part2()
  io.println(
    "[day "
    <> int.to_string(day)
    <> "][part 2] real: "
    <> int.to_string(real_p2),
  )

  io.println("")
}

pub fn example_input() {
  "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
}

pub fn part1(input: String) {
  case input {
    "mul(" <> remaining -> {
      let split = remaining |> string.split(")")
      case split {
        [] -> 0
        [el, ..] -> {
          case string.split(el, ",") {
            [a, b] -> {
              let left = int.parse(a)
              let right = int.parse(b)

              case left, right {
                Ok(x), Ok(y) -> {
                  io.debug(el)
                  let mul = x * y
                  mul + part1(remaining)
                }
                _, _ -> {
                  io.debug("continuing with: " <> remaining)
                  part1(remaining)
                }
              }
            }
            _ -> {
              io.debug("continuing with: " <> remaining)
              part1(remaining)
            }
          }
        }
      }
    }
    "" -> 0
    other -> {
      other
      |> string.drop_start(1)
      |> part1()
    }
  }
}

pub fn part2(input: String) {
  todo
}
