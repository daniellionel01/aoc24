import env
import gleam/float
import gleam/http/request
import gleam/httpc
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}

pub fn puzzle_input(day: Int) {
  let assert Ok(req) =
    { "https://adventofcode.com/2024/day/" <> int.to_string(day) <> "/input" }
    |> request.to

  let req = request.set_cookie(req, "session", env.session())

  let assert Ok(resp) = httpc.send(req)

  resp.body
}

pub fn str(n: Int) {
  int.to_string(n)
}

pub fn ftoi(n: Float) {
  float.truncate(n)
}

pub fn update_at(items: List(a), index: Int, item: a) -> List(a) {
  list.index_map(items, fn(el, i) {
    case index == i {
      True -> item
      False -> el
    }
  })
}

pub fn index_all(items: List(a), cb: fn(a, Int) -> Bool) {
  list.index_fold(items, True, fn(acc, cur, index) {
    case acc {
      False -> False
      True -> cb(cur, index)
    }
  })
}

pub fn index_filter(items: List(a), cb: fn(a, Int) -> Bool) {
  list.index_fold(items, [], fn(acc, cur, index) {
    case cb(cur, index) {
      True -> list.append(acc, [cur])
      False -> acc
    }
  })
}

pub fn index_some(items: List(a), cb: fn(a, Int) -> Bool) {
  case items {
    [] -> True
    items -> {
      list.index_fold(items, False, fn(acc, cur, index) {
        acc || cb(cur, index)
      })
    }
  }
}

pub fn item_at(items: List(a), index: Int) -> Option(a) {
  case items {
    [] -> None
    [head, ..rest] -> {
      case index {
        0 -> Some(head)
        _ -> item_at(rest, index - 1)
      }
    }
  }
}

pub fn item_at_def(items: List(a), index: Int) -> a {
  let assert Some(value) = item_at(items, index)
  value
}

pub fn factorial(x: Int) -> Int {
  factorial_loop(x, 1)
}

fn factorial_loop(x: Int, acc: Int) -> Int {
  case x {
    0 -> acc
    1 -> acc
    _ -> factorial_loop(x - 1, acc * x)
  }
}
