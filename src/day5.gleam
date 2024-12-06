import aoc24/lib.{str}
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() {
  let day = 5

  io.println("")

  let ex_p1 = example_input() |> part1()
  io.println("[day " <> str(day) <> "][part 1] example: " <> str(ex_p1))

  let real_p1 = lib.puzzle_input(day) |> part1()
  io.println("[day " <> str(day) <> "][part 1] real: " <> str(real_p1))

  io.println("")

  // let ex_p2 = example_input() |> part2()
  // io.println("[day " <> str(day) <> "][part 2] example: " <> str(ex_p2))

  // let real_p2 = lib.puzzle_input(day) |> part2()
  // io.println("[day " <> str(day) <> "][part 2] real: " <> str(real_p2))

  io.println("")
}

pub fn part1(input: String) {
  let split =
    input
    |> string.trim()
    |> string.split("\n")
    |> list.split_while(fn(el) { el != "" })
  let #(ordering_rules, update_pages) = split
  let assert Ok(update_pages) = list.rest(update_pages)

  let ordering_rules =
    list.map(ordering_rules, fn(el) {
      let assert [left, right] = string.split(el, "|")
      let assert Ok(left) = int.parse(left)
      let assert Ok(right) = int.parse(right)
      #(left, right)
    })

  let update_pages =
    list.map(update_pages, fn(el) {
      el
      |> string.trim()
      |> string.split(",")
      |> list.map(fn(n) {
        let assert Ok(res) = int.parse(n)
        res
      })
    })

  let correctly_ordered =
    list.filter(update_pages, fn(el_lst) {
      lib.index_all(el_lst, fn(el, el_index) {
        let rules =
          list.filter(ordering_rules, fn(rule) { el == rule.0 || el == rule.1 })

        case rules {
          [] -> True
          _ -> {
            list.all(rules, fn(rule) {
              let #(left_num, right_num) = rule

              let #(left_lst, right_lst) = list.split(el_lst, el_index + 1)

              let pendant_el = case left_num == el {
                True -> right_num
                False -> left_num
              }

              let occurs_left = case
                list.find(left_lst, fn(x) { x == pendant_el })
              {
                Ok(_) -> True
                Error(Nil) -> False
              }

              let occurs_right = case
                list.find(right_lst, fn(x) { x == pendant_el })
              {
                Ok(_) -> True
                Error(Nil) -> False
              }

              case occurs_left, occurs_right {
                True, False -> right_num == el
                False, True -> left_num == el
                _, _ -> True
              }
            })
          }
        }
      })
    })

  let middle_numbers =
    list.map(correctly_ordered, fn(el) {
      let index = list.length(el) / 2
      lib.item_at_def(el, index)
    })

  list.fold(middle_numbers, 0, int.add)
}

pub fn part2(input: String) {
  todo

  0
}

pub fn example_input() {
  "
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
"
  |> string.trim()
}
