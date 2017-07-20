defmodule Registrar.Web.UserControllerTest do
  use Registrar.Web.ConnCase, async: false

  @email "email@email.com"
  @password "password"

  test "Post /user", %{conn: conn} do
    res = post(conn, "/user", %{email: @email, password: @password})
    assert res.status == 201
  end
end
