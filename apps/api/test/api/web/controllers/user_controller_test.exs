defmodule API.Web.UserControllerTest do
  use API.Web.ConnCase

  @username "Dude"
  @email "email@email.com"
  @password "password"
  @base_url "/v1/users"

  @user_params %{
    "username" => @username,
    "email" => @email,
    "password" => @password
  }

  describe "#search" do
    setup do
      {:ok, user} = API.User.create(@user_params)
      params = %{
        @user_params |
          "username" => "Duder",
          "email" => "edude@email.com"
      }
      {:ok, searchable_user} = API.User.create(params)
      {:ok, token, _} = Guardian.encode_and_sign(user)

      {:ok, %{token: token, searchable_user: searchable_user}}
    end

    test "by username returns users other than the requesting user",
      %{conn: conn, token: token, searchable_user: searchable_user} do
        res =
          conn
          |> put_req_header("authorization", token)
          |> get(@base_url, %{q: @username})

        assert res.status == 200
        body = json_response(res)
        assert [user] = body.users
        assert user.username == searchable_user.username
    end

    test "by email returns users other than the requesting user",
      %{conn: conn, token: token, searchable_user: searchable_user} do
        res =
          conn
          |> put_req_header("authorization", token)
          |> get(@base_url, %{q: @email})

        assert res.status == 200
        body = json_response(res)
        assert [user] = body.users
        assert user.email == searchable_user.email
    end

    test "with invalid parameter returns an error", %{conn: conn, token: token} do
      res =
        conn
        |> put_req_header("authorization", token)
        |> get(@base_url, %{zombie: "brains"})

      assert res.status == 400
    end

    test "with no parameter returns an error", %{conn: conn, token: token} do
      res =
        conn
        |> put_req_header("authorization", token)
        |> get(@base_url, %{})

      assert res.status == 400
    end
  end

  describe "#create" do
    test "with valid params creates a user", %{conn: conn} do
      res = post(conn, @base_url, @user_params)
      assert res.status == 201

      body = json_response(res)
      assert body.id
      assert body.email == @email
      assert body.username == @username
    end

    test "with invalid params returns a 422", %{conn: conn} do
      API.User.create(@user_params)
      res = post(conn, @base_url, @user_params)
      assert res.status == 422

      body = json_response(res)
      assert body.errors
    end
  end

  describe "#login" do
    test "with correct credentials logs a user in", %{conn: conn} do
      API.User.create(@user_params)

      res = post(conn, "#{@base_url}/login", %{username: String.upcase(@username), password: @password})
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

    test "with incorrect credentials returns 401 Unauthorized", %{conn: conn} do
      API.User.create(@user_params)
      res = post(conn, "#{@base_url}/login", %{username: @username, password: "hacking"})
      assert res.status == 401
    end
  end

  describe "refresh" do
    test "with a valid token creates a new token", %{conn: conn} do
      {:ok, user} = API.User.create(@user_params)
      {:ok, token, _} = Guardian.encode_and_sign(user, :access)

      res =
        conn
        |> put_req_header("authorization", token)
        |> post("#{@base_url}/refresh")

        assert res.status == 201

        headers = response_headers(res)

        assert headers["authorization"]
        assert headers["x-expires"]

        body = json_response(res)
        assert body.auth.token
        assert body.auth.expires_at
    end

    test "with an invalid token returns 401 Unauthorized", %{conn: conn} do
      {:ok, _user} = API.User.create(@user_params)

      res =
        conn
        |> put_req_header("authorization", "badtoken")
        |> post("#{@base_url}/refresh")

      assert res.status == 401
    end
  end
end
