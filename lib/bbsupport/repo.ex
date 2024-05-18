defmodule Bbsupport.Repo do
  use Ecto.Repo,
    otp_app: :bbsupport,
    adapter: Ecto.Adapters.Postgres
end
