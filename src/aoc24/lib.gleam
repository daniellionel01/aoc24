import env
import gleam/http/request
import gleam/httpc
import gleam/int

pub fn puzzle_input(day: Int) {
  let assert Ok(req) =
    { "https://adventofcode.com/2024/day/" <> int.to_string(day) <> "/input" }
    |> request.to

  let req = request.set_cookie(req, "session", env.session())

  let assert Ok(resp) = httpc.send(req)

  resp.body
}
