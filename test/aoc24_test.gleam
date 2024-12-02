import aoc24/day2
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn drop_index_test() {
  day2.drop_index([1, 2, 3, 4, 5], 0)
  |> should.equal([2, 3, 4, 5])

  day2.drop_index([1, 2, 3, 4, 5], 1)
  |> should.equal([1, 3, 4, 5])

  day2.drop_index([1, 2, 3, 4, 5], 2)
  |> should.equal([1, 2, 4, 5])
}
