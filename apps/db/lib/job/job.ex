defmodule DB.Job do
  @moduledoc """
  This module encapsulates the functionality of the `job` table,
  providing create and retrieve utility functions, as well as
  Ecto changesets.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias DB.{Job, Repo}

  schema "jobs" do
    field :execute_at, :integer
    field :params, :binary
    field :status, :string

    timestamps()
  end

  @fields [:execute_at, :params, :status]

  def create(attrs) do
    %Job{}
    |> changeset(attrs)
    |> Repo.insert
  end

  def delete(id) do
    Job
    |> Repo.get(id)
    |> Repo.delete
  end

  def fetch(time_into_future) do
    time = :erlang.system_time(:second) + time_into_future
    query = from j in Job, where: j.execute_at < ^time and j.status != "failed"
    Repo.all(query)
  end

  def set_failed(job) do
    job
    |> changeset(%{status: "failed"})
    |> Repo.update
  end

  def get_failed_jobs do
    query = from j in Job, where: j.status == "failed"
    Repo.all(query)
  end

  def job_count do
    Job
    |> Repo.all
    |> length
  end

  defp changeset(struct, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
