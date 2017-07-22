defmodule API.Web.UpController do
  use API.Web, :controller

  def up(conn, _params) do
    checks = %{db: db_check()}

    checks
    |> Map.values
    |> Enum.member?(:error)
    |> if  do
      conn
      |> put_status(503)
      |> json(checks)
    else
      conn
      |> put_status(200)
      |> json(checks)
    end
  end

  defp db_check do
    DB.User.get(1)
    :ok
  rescue
    err -> :error
  end
end
