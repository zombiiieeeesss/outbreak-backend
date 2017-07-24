defmodule API.Web.UserControllerTest do
  use API.Web.ConnCase

  @username "dude"
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
  end

  test "POST /user/login with correct credentials", %{conn: conn} do
    API.User.create(@user_params)
    res = post(conn, "/users/login", %{email: @email, password: @password})
    assert res.status == 201

    headers = res.resp_headers
      |> Enum.into(%{})

    assert headers["authorization"]
    assert headers["x-expires"]
  end

  test "POST /user/login with incorrect credentials", %{conn: conn} do
    API.User.create(@user_params)
    res = post(conn, "/users/login", %{email: @email, password: "hacking"})
    assert res.status == 401
  end

  test "POST /user/refresh with a valid token", %{conn: conn} do
    {:ok, user} = API.User.create(@user_params)
    {:ok, token, _} = Guardian.encode_and_sign(user, :access)

    res =
      conn
      |> put_req_header("authorization", token)
      |> post("/users/refresh")

    headers = res.resp_headers
        |> Enum.into(%{})

    assert headers["authorization"]
    assert headers["x-expires"]

    assert res.status == 201
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
