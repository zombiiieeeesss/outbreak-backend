defmodule API.Web.PlayerControllerTest do
  use API.Web.ConnCase

  @base_url "/v1/players"

  setup do
    user = create_user()
    game = create_game(%{owner_id: user.id})
    {:ok, token, _full_claims} = Guardian.encode_and_sign(user)

    {:ok, %{user: user, game: game, token: token}}
  end

  describe "#create" do
    test "with valid params", %{conn: conn, game: game, token: token} do
      user_added_to_game = create_user()

      res =
        conn
        |> put_req_header("authorization", token)
        |> post(@base_url, %{game_id: game.id, user_id: user_added_to_game.id})

      assert res.status == 201

      body = json_response(res)
      assert body.id
      assert body.game_id == game.id
      assert body.user_id == user_added_to_game.id
      assert body.status == "user-pending"
    end

    test "when the user does not own the game", %{conn: conn, token: token} do
      user_added_to_game = create_user()
      game = create_game()

      res =
        conn
        |> put_req_header("authorization", token)
        |> post(@base_url, %{game_id: game.id, user_id: user_added_to_game.id})

      assert res.status == 401
    end

    test "with invalid auth credentials", %{conn: conn} do
      res = post(conn, @base_url, %{})
      assert res.status == 401
    end
  end
end
