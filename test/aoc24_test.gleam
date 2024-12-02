import aoc24/day2
import aoc24/lib
import gleam/list
import gleam/string
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn puzzle_input_test() {
  let input = lib.puzzle_input(2)

  let assert Ok(first_line) = input |> string.split("\n") |> list.first

  // this line will probably differ with your session
  should.equal(first_line, "38 41 44 47 50 47")
}

pub fn drop_index_test() {
  day2.drop_index([1, 2, 3, 4, 5], 0)
  |> should.equal([2, 3, 4, 5])

  day2.drop_index([1, 2, 3, 4, 5], 1)
  |> should.equal([1, 3, 4, 5])

  day2.drop_index([1, 2, 3, 4, 5], 2)
  |> should.equal([1, 2, 4, 5])
}
