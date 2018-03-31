defmodule Corex.Test.Mom do
  def user_attrs(tid \\ nil) do
    %{tid: tid, email: "#{tid}@example.com", password: "password123"}
  end
end
