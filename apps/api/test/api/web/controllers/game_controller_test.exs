defmodule API.Web.GameControllerTest do
  use API.Web.ConnCase

  @status "pending"
  @title "Zombieland"
  @round_length 5
  @base_url "/v1/games"

  @game_params %{
    "status" => @status,
    "title" => @title,
    "round_length" => @round_length
  }

  @user_params %{
    "username" => "Dude",
    "email" => "dude@dude.dude",
    "password" => "dudedooood"
  }

  setup do
    {:ok, user} = API.User.create(@user_params)
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
      assert body.status == @status
      assert body.round_length == @round_length

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
    setup context do
      {:ok, game} = API.Game.create(@game_params)
      {:ok, _player} = API.Player.create(context.user.id, game.id)

      {:ok, %{game: game}}
    end

    test "returns a list of games", %{conn: conn, token: token} do
      res =
        conn
        |> put_req_header("authorization", token)
        |> get(@base_url)

      assert res.status == 200
    end
  end
end