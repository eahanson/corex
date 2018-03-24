defmodule Corex.Format do
  alias Corex.Time
  alias Corex.Extra

  def format(_, nil), do: ""
  def format(:date, date), do: Time.format date, :date
  def format(:integer, integer), do: to_string integer
  def format(:presence, _), do: "•"
  def format(:relative_datetime, datetime), do: format(:relative_datetime, datetime, DateTime.utc_now)
  def format(:string, string), do: string
  def format(:url, url), do: Extra.String.inner_truncate(url, 20)
  def format(_, nil, _), do: ""
  def format(:relative_datetime, older, newer), do: Time.ago(older, newer)
end
