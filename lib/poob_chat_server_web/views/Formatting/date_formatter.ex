defmodule PoobChatServerWeb.Formatting.DateFormatter do

  def naive_to_iso_string(%NaiveDateTime{} = date) do
    date
    |> DateTime.from_naive!("Etc/UTC")
    |> DateTime.to_iso8601(:extended)
  end
end
