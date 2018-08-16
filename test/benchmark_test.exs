defmodule BenchmarkTest do
  use ExUnit.Case

  test "benchmark: should not be slower than base case (left value is tolerance)" do
    Mix.Tasks.Benchmark.run(["--json"])

    base_benchmark =
      [File.cwd!(), "benchmark_baseline.json"]
      |> Path.join()
      |> File.read!()
      |> Poison.decode!()

    benchmark =
      [File.cwd!(), "benchmark.json"]
      |> Path.join()
      |> File.read!()
      |> Poison.decode!()

    base_benchmark_locale = get_in(base_benchmark, ["statistics", "locale", "average"])
    base_benchmark_locale? = get_in(base_benchmark, ["statistics", "locale?", "average"])

    benchmark_locale = get_in(benchmark, ["statistics", "locale", "average"])
    benchmark_locale? = get_in(benchmark, ["statistics", "locale?", "average"])

    tolerance = 25
    assert tolerance > (benchmark_locale / base_benchmark_locale - 1) * 100
    assert tolerance > (benchmark_locale? / base_benchmark_locale? - 1) * 100
  end
end
