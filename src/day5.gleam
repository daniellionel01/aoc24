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

  let ex_p2 = example_input() |> part2()
  io.println("[day " <> str(day) <> "][part 2] example: " <> str(ex_p2))

  let real_p2 = lib.puzzle_input(day) |> part2()
  io.println("[day " <> str(day) <> "][part 2] real: " <> str(real_p2))

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
    list.filter(update_pages, list_complies_with_rules(_, ordering_rules))

  let middle_numbers =
    list.map(correctly_ordered, fn(el) {
      let index = list.length(el) / 2
      lib.item_at_def(el, index)
    })

  list.fold(middle_numbers, 0, int.add)
}

pub fn part2(input: String) {
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

  let incorrectly_ordered =
    list.filter(update_pages, fn(el_lst) {
      !list_complies_with_rules(el_lst, ordering_rules)
    })

  let sorted =
    list.map(incorrectly_ordered, fn(lst) { sort_by_rules(lst, ordering_rules) })

  let middle_numbers =
    list.map(sorted, fn(el) {
      let index = list.length(el) / 2
      lib.item_at_def(el, index)
    })

  list.fold(middle_numbers, 0, int.add)
}

fn complies_with_rule(
  lst: List(Int),
  rule: #(Int, Int),
  el: Int,
  el_index: Int,
) -> Bool {
  let #(left_num, right_num) = rule

  let #(left_lst, right_lst) = list.split(lst, el_index + 1)

  let pendant_el = case left_num == el {
    True -> right_num
    False -> left_num
  }

  let occurs_left = case list.find(left_lst, fn(x) { x == pendant_el }) {
    Ok(_) -> True
    Error(Nil) -> False
  }

  let occurs_right = case list.find(right_lst, fn(x) { x == pendant_el }) {
    Ok(_) -> True
    Error(Nil) -> False
  }

  case occurs_left, occurs_right {
    True, False -> right_num == el
    False, True -> left_num == el
    _, _ -> True
  }
}

fn get_applying_rules(el: Int, rules: List(#(Int, Int))) {
  list.filter(rules, fn(rule) { el == rule.0 || el == rule.1 })
}

fn el_complies_with_rules(
  el_lst: List(Int),
  rules: List(#(Int, Int)),
  el: Int,
  el_index: Int,
) -> Bool {
  let applying_rules = get_applying_rules(el, rules)

  case applying_rules {
    [] -> True
    _ -> {
      list.all(applying_rules, complies_with_rule(el_lst, _, el, el_index))
    }
  }
}

fn list_complies_with_rules(el_lst: List(Int), rules: List(#(Int, Int))) -> Bool {
  lib.index_all(el_lst, fn(el, el_index) {
    el_complies_with_rules(el_lst, rules, el, el_index)
  })
}

fn sort_by_rules(lst: List(Int), rules: List(#(Int, Int))) {
  let compliant = list_complies_with_rules(lst, rules)
  case compliant {
    True -> lst
    False -> {
      let first =
        list.index_map(lst, fn(el, index) {
          #(index, el, el_complies_with_rules(lst, rules, el, index))
        })
        |> list.filter(fn(el) { !el.2 })
        |> list.first()

      case first {
        Error(Nil) -> panic as "could not match a non compliant element"
        Ok(#(el_index, el, _)) -> {
          let assert Ok(rule) =
            get_applying_rules(el, rules)
            |> list.filter(fn(rule) {
              !complies_with_rule(lst, rule, el, el_index)
            })
            |> list.first

          let #(left, right) = rule
          let pendant = case left == el {
            True -> right
            False -> left
          }

          let lst = list.filter(lst, fn(x) { x != pendant })

          let split_index = case left == el {
            True -> el_index + 1
            False -> el_index
          }
          let #(before, after) = list.split(lst, split_index)

          let lst =
            before
            |> list.append([pendant])
            |> list.append(after)

          sort_by_rules(lst, rules)
        }
      }
    }
  }
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
