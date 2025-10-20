defmodule Sorteios.Prizes.Tickets do
  use Ash.Resource,
    otp_app: :sorteios,
    domain: Sorteios.Prizes,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshPhoenix],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "tickets"
    repo Sorteios.Repo
  end

  actions do
    defaults [:read, :destroy]

    read :read_by_rifa do
      primary? true
      argument :rifa_id, :uuid

      filter expr(rifa_id == ^arg(:rifa_id))
    end

    create :create do
      accept [:user_id, :rifa_id]
    end
  end

  policies do
    policy action_type(:create) do
      authorize_if actor_present()
    end

    policy action_type(:read) do
      authorize_if always()
    end
  end

  relationships do
    belongs_to :user, Sorteios.Accounts.User
    belongs_to :rifa, Sorteios.Prizes.Rifa
  end
end
