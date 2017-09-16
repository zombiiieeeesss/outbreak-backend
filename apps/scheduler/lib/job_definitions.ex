defmodule JobDefinitions do
  @moduledoc """
  Example for how job definitions module should look
  """

  def execute(job_name, job_params) do
    # credo:disable-for-next-line
    IO.inspect {job_name, job_params}
    :ok
  end
end
