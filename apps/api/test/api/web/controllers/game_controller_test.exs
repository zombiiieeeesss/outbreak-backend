defmodule API.Web.GameControllerTest do
  use API.Web.ConnCase

  @title "Zombieland"
  @round_length 5
  @base_url "/v1/games"

  @game_params %{
    "title" => @title,
    "round_length" => @round_length
  }

  setup do
    user = create_user()
    {:ok, token, full_claims} = Guardian.encode_and_sign(user)
    {:ok, %{user: user, token: token, claims: full_claims}}
  end

  describe "#create" do
    test "with valid params", %{conn: conn, token: token, user: user} do
      res =
        conn
        |> put_req_header("authorization", token)
        |> post(@base_url, @game_params)
      assert res.status == 201

      body = json_response(res)
      assert body.id
      assert body.title == @title
      assert body.status == "qualifying"
      assert body.round_length == @round_length
      assert body.owner_id == user.id

      [assoc_user] =
        DB.Game
        |> DB.Repo.get(body.id)
        |> DB.Repo.preload(:users)
        |> Map.get(:users)
      assert assoc_user.id == user.id
    end

    test "with invalid params", %{conn: conn, token: token} do
      res =
        conn
        |> put_req_header("authorization", token)
        |> post(@base_url, %{})
      assert res.status == 422
    end

    test "with invalid auth credentials", %{conn: conn} do
      res = post(conn, @base_url, %{})
      assert res.status == 401
    end
  end

  describe "#index" do
    setup %{user: user} do
      game = create_game()
      {:ok, player} = API.Player.create(user.id, game.id)

      {:ok, %{game: game, player: player}}
    end

    test "returns a list of games", %{conn: conn, token: token, player: player} do
      res =
        conn
        |> put_req_header("authorization", token)
        |> get(@base_url)

      player_result = %{id: player.id, status: player.status}
      [body] = json_response(res)

      assert res.status == 200
      assert player_result == body.player
    end
  end
end
