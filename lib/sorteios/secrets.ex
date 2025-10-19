defmodule Sorteios.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        Sorteios.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:sorteios, :token_signing_secret)
  end
end
