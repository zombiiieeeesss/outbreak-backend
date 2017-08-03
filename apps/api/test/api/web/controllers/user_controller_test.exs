defmodule API.Web.UserControllerTest do
  use API.Web.ConnCase

  @username "Dude"
  @email "email@email.com"
  @password "password"

  @user_params %{
    "username" => @username,
    "email" => @email,
    "password" => @password
  }

  test "POST /user", %{conn: conn} do
    res = post(conn, "/users", @user_params)
    assert res.status == 201

    body = json_response(res)
    assert body.id
    assert body.email == @email
    assert body.username == @username
  end

  test "POST /user when the changeset is invalid", %{conn: conn} do
    API.User.create(@user_params)
    res = post(conn, "/users", @user_params)
    assert res.status == 422

    body = json_response(res)
    assert body.errors
  end

  test "POST /user/login with correct credentials", %{conn: conn} do
    API.User.create(@user_params)

    #upcase the username here to test the case insensitivity
    res = post(conn, "/users/login", %{username: String.upcase(@username), password: @password})
    assert res.status == 201

    headers = response_headers(res)

    assert headers["authorization"]
    assert headers["x-expires"]

    body = json_response(res)

    assert body.user.id
    assert body.user.email == @email
    assert body.user.username == @username
    assert body.auth.token
    assert body.auth.expires_at
  end

  test "POST /user/login with incorrect credentials", %{conn: conn} do
    API.User.create(@user_params)
    res = post(conn, "/users/login", %{username: @username, password: "hacking"})
    assert res.status == 401
  end

  test "POST /user/refresh with a valid token", %{conn: conn} do
    {:ok, user} = API.User.create(@user_params)
    {:ok, token, _} = Guardian.encode_and_sign(user, :access)

    res =
      conn
      |> put_req_header("authorization", token)
      |> post("/users/refresh")

      assert res.status == 201

      headers = response_headers(res)

      assert headers["authorization"]
      assert headers["x-expires"]

      body = json_response(res)
      assert body.auth.token
      assert body.auth.expires_at
  end

  test "POST /user/refresh with a invalid token", %{conn: conn} do
    {:ok, _user} = API.User.create(@user_params)

    res =
      conn
      |> put_req_header("authorization", "badtoken")
      |> post("/users/refresh")

    assert res.status == 401
  end
end
