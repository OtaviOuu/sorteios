defmodule Sorteios.Prizes do
  use Ash.Domain,
    otp_app: :sorteios,
    extensions: [AshPhoenix]

  resources do
    resource Sorteios.Prizes.Rifa do
      define :create_rifa, action: :create
      define :list_rifas, action: :read
      define :get_rifa, action: :read, get_by: :id
    end

    resource Sorteios.Prizes.Tickets do
      define :create_ticket, action: :create
      define :list_tickets_from_rifa, action: :read_by_rifa, args: [:rifa_id]
    end
  end
end
