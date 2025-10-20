defmodule Sorteio.Prizes.Rifa do
  use Ash.Resource,
    otp_app: :sorteios,
    domain: Sorteio.Prizes,
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
      accept [:name, :description, :user_id]
      change relate_actor(:user)
    end

    read :read do
      prepare build(sort: [inserted_at: :desc])
      prepare build(load: [:user])
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
    belongs_to :user, Sorteios.Accounts.User
  end
end
