defmodule Registrar.Web.UserControllerTest do
  use Registrar.Web.ConnCase, async: false

  @email "email@email.com"
  @password "password"

  test "POST /user", %{conn: conn} do
    res = post(conn, "/user", %{email: @email, password: @password})
    assert res.status == 201
  end

  test "POST /user/login with correct credentials", %{conn: conn} do
    Registrar.User.create_user(%{"email" => @email, "password" => @password})
    res = post(conn, "/user/login", %{email: @email, password: @password})
    assert res.status == 200
  end

  test "POST /user/login with incorrect credentials", %{conn: conn} do
    Registrar.User.create_user(%{"email" => @email, "password" => @password})
    res = post(conn, "/user/login", %{email: @email, password: "hacking"})
    assert res.status == 401
  end
end
