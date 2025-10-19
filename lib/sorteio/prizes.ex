defmodule Sorteio.Prizes do
  use Ash.Domain,
    otp_app: :sorteios,
    extensions: [AshPhoenix]

  resources do
    resource Sorteio.Prizes.Rifa do
      define :create_rifa, action: :create
      define :list_rifas, action: :read
    end
  end
end
