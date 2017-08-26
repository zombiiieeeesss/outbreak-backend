defmodule API.Web.FriendRequestControllerTest do
  use API.Web.ConnCase

  @base_url "/v1/friend-requests"

  setup do
    user_one = create_user()
    user_two = create_user()

    {:ok, token, _full_claims} = Guardian.encode_and_sign(user_one)
    {:ok, %{user_one: user_one, user_two: user_two, token: token}}
  end

  describe "#create" do
    test "with valid params", %{conn: conn, user_one: user_one, user_two: user_two, token: token} do
      res =
        conn
        |> put_req_header("authorization", token)
        |> post(@base_url, %{requested_user_id: user_two.id})

      assert res.status == 201

      body = json_response(res)

      assert body.id
      assert body.status == "pending"
      assert body.requesting_user_id == user_one.id
      assert body.friend.id == user_two.id
    end

    test "with invalid params", %{conn: conn, token: token, user_two: user_two} do
      res =
        conn
        |> put_req_header("authorization", token)
        |> post(@base_url, %{requested_user_id: 2 * user_two.id})
      assert res.status == 422
    end

    test "with invalid auth credentials", %{conn: conn} do
      res = post(conn, @base_url, %{})
      assert res.status == 401
    end
  end

  describe "#index" do
    test "with a valid request", %{conn: conn, token: token, user_one: user_one} do
      create_friend_request(%{requesting_user_id: user_one.id})
      create_friend_request(%{requested_user_id: user_one.id})
      create_friend_request(%{requesting_user_id: user_one.id})
      create_friend_request(%{requested_user_id: user_one.id})

      res =
        conn
        |> put_req_header("authorization", token)
        |> get(@base_url)

      assert res.status == 200

      body = json_response(res)
      assert length(body) == 4

      [fr | _tail] = body
      assert fr.id
      assert fr.status == "pending"
      assert fr.requesting_user_id
      assert fr.friend
    end
  end

  describe "#delete" do
    test "with a valid request", %{conn: conn, token: token, user_one: user_one} do
      fr = create_friend_request(%{requested_user_id: user_one.id})

      res =
        conn
        |> put_req_header("authorization", token)
        |> delete("#{@base_url}/#{fr.id}")

      assert res.status == 200

      refute DB.Repo.get(DB.FriendRequest, fr.id)
    end

    test "when the friend request does not exist", %{conn: conn, token: token} do
      res =
        conn
        |> put_req_header("authorization", token)
        |> delete("#{@base_url}/0")

      assert res.status == 400
    end
  end

  describe "#update" do
    test "with a valid request", %{conn: conn, token: token, user_one: user_one} do
      fr = create_friend_request(%{requesting_user_id: user_one.id, status: "pending"})

      res =
        conn
        |> put_req_header("authorization", token)
        |> patch("#{@base_url}/#{fr.id}", %{status: "accepted"})

      assert res.status == 201

      body = json_response(res)

      assert body.id == fr.id
      assert body.status == "accepted"
      assert body.requesting_user_id == user_one.id
      assert body.friend.id == fr.requested_user_id

      fr = DB.Repo.get(DB.FriendRequest, fr.id)
      assert fr.status == "accepted"
    end

    test "when the friend request does not exist", %{conn: conn, token: token} do
      res =
        conn
        |> put_req_header("authorization", token)
        |> patch("#{@base_url}/0", %{status: "accepted"})

      assert res.status == 400
    end
  end
end
