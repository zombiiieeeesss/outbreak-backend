defmodule API.Web.FriendshipControllerTest do
  use API.Web.ConnCase

  @base_url "/v1/friendships"

  setup do
    {:ok, user_one} = API.User.create(%{
      "username" => "Dude",
      "email" => "dude@dude.dude",
      "password" => "dudedooood"
    })

    {:ok, user_two} = API.User.create(%{
      "username" => "Dudette",
      "email" => "dudette@dude.dude",
      "password" => "dudettedooood"
    })

    {:ok, token, _full_claims} = Guardian.encode_and_sign(user_one)
    {:ok, %{user_one: user_one, user_two: user_two, token: token}}
  end

  describe "#create" do
    test "with valid params", %{conn: conn, user_two: user_two, token: token} do
      res =
        conn
        |> put_req_header("authorization", token)
        |> post(@base_url, %{requestee_id: user_two.id})

      assert res.status == 201

      body = json_response(res)
      assert body.id
    end

    test "with invalid params", %{conn: conn, token: token, user_two: user_two} do
      res =
        conn
        |> put_req_header("authorization", token)
        |> post(@base_url, %{requestee_id: 2 * user_two.id})
      assert res.status == 422
    end

    test "with invalid auth credentials", %{conn: conn} do
      res = post(conn, @base_url, %{})
      assert res.status == 401
    end
  end
end
