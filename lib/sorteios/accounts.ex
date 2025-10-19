defmodule Sorteios.Accounts do
  use Ash.Domain,
    otp_app: :sorteios

  resources do
    resource Sorteios.Accounts.Token
    resource Sorteios.Accounts.User
  end
end
