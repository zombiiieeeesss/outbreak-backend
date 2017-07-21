defmodule API.Web.UserControllerTest do
  use API.Web.ConnCase, async: false

  @email "email@email.com"
  @password "password"

  test "POST /user", %{conn: conn} do
    res = post(conn, "/user", %{email: @email, password: @password})
    assert res.status == 201
  end

  test "POST /user/login with correct credentials", %{conn: conn} do
    API.User.create_user(%{"email" => @email, "password" => @password})
    res = post(conn, "/user/login", %{email: @email, password: @password})
    assert res.status == 201

    headers = res.resp_headers
      |> Enum.into(%{})

    assert headers["authorization"]
    assert headers["x-expires"]
  end

  test "POST /user/login with incorrect credentials", %{conn: conn} do
    API.User.create_user(%{"email" => @email, "password" => @password})
    res = post(conn, "/user/login", %{email: @email, password: "hacking"})
    assert res.status == 401
  end

  test "POST /user/refresh with a valid token", %{conn: conn} do
    {:ok, user} = API.User.create_user(%{"email" => @email, "password" => @password})
    {:ok, token, _} = Guardian.encode_and_sign(user, :access)

    res =
      conn
      |> put_req_header("authorization", token)
      |> post("/user/refresh", %{email: @email, password: @password})

    headers = res.resp_headers
        |> Enum.into(%{})

    assert headers["authorization"]
    assert headers["x-expires"]

    assert res.status == 201
  end

  test "POST /user/refresh with a invalid token", %{conn: conn} do
    {:ok, _user} = API.User.create_user(%{"email" => @email, "password" => @password})

    res =
      conn
      |> put_req_header("authorization", "badtoken")
      |> post("/user/refresh", %{email: @email, password: @password})

    assert res.status == 401
  end
end
