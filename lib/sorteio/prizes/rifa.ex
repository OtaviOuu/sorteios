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
    defaults [:destroy, :create, :update]
    default_accept [:name, :description]

    read :read do
      prepare build(sort: [inserted_at: :desc])
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

    timestamps()
  end
end
