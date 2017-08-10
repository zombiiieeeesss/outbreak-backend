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

  describe "POST /v1/games" do
    setup do
      {:ok, user} = API.User.create(@user_params)
      {:ok, token, full_claims} = Guardian.encode_and_sign(user)
      {:ok, %{user: user, token: token, claims: full_claims}}
    end

    test "with valid params", %{conn: conn, token: token} do
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
end
