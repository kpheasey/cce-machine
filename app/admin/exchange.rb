ActiveAdmin.register Exchange do
  permit_params :id, :name, :permalink, :is_active, :is_default, :exchange_market_id,
                fees_attributes: [:id, :min, :max, :fee, :discount, :_destroy],
                exchange_markets_attributes: [:id, :market_id, :code, :_destroy]

  filter :name
  filter :code
  filter :is_active
  filter :is_default

  config.sort_order = 'name'

  controller do
    # use Friendly IDs
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  index do
    column :name
    column :is_active
    column :is_default
    default_actions
  end

  form do |exchange|
    exchange.inputs 'Exchange Details' do
      exchange.input :name
      exchange.input :permalink
      exchange.input :is_active
      exchange.input :is_default
      exchange.input :default_exchange_market, collection: exchange.object.exchange_markets.map{ |em| [em.market.name, em.id] }
      exchange.has_many :exchange_markets do |exchange_market|
        exchange_market.input :market
        exchange_market.input :code
        exchange_market.input :_destroy, as: :boolean, required: false, label: 'Destroy'
      end

    end
    exchange.actions
  end
  
end
