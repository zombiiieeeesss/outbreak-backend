defmodule BenchmarkQueries do
  use Benchfella

  setup_all do: Application.ensure_all_started(:db)
  teardown_all _, do: Application.stop(:db)

  bench "search username/email" do
    API.User.search("abc", 2)
  end
end
