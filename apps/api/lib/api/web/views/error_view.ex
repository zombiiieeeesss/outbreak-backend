defmodule API.Web.ErrorView do
  use API.Web, :view

  def render("400.json", %{errors: errors}), do: %{errors: errors}

  def render("422.json", changeset) do
    errors = Ecto.Changeset.traverse_errors(changeset, &format_changeset_errors/1)
    %{errors: errors}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal server error"}}
  end

  def render("401.json", _) do
    %{errors: ["Invalid Token"]}
  end

  defp format_changeset_errors({msg, opts}) do
    Enum.reduce(opts, msg, fn({key, value}, acc) ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
