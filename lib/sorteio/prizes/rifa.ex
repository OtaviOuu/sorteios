defmodule Sorteios.Prizes.Rifa do
  use Ash.Resource,
    otp_app: :sorteios,
    domain: Sorteios.Prizes,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshPhoenix],
    authorizers: [Ash.Policy.Authorizer],
    notifiers: [Ash.Notifier.PubSub]

  postgres do
    table "rifas"
    repo Sorteios.Repo
  end

  actions do
    defaults [:destroy, :update]
    default_accept [:name, :description]

    create :create do
      accept [:name, :description]
      change relate_actor(:owener)
    end

    update :add_ticket do
      argument :ticket_id, :uuid
    end

    read :read do
      prepare build(sort: [inserted_at: :desc])
      prepare build(load: [:owener, :tickets, :tickets_count])
    end
  end

  policies do
    policy action_type(:create) do
      authorize_if actor_attribute_equals(:role, :admin)
    end

    policy action_type(:read) do
      authorize_if always()
    end
  end

  pub_sub do
    module SorteiosWeb.Endpoint

    prefix "prize"
    publish_all :create, [[:id, nil]]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string
    attribute :description, :string

    attribute :status, Sorteios.Prizes.Status do
      default :active
    end

    timestamps()
  end

  relationships do
    belongs_to :owener, Sorteios.Accounts.User
    has_many :tickets, Sorteios.Prizes.Tickets
  end

  aggregates do
    count :tickets_count, Sorteios.Prizes.Tickets do
      public? true
    end
  end
end
