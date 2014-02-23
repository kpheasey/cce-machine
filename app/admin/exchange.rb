ActiveAdmin.register Exchange do
  permit_params :id, :name, :permalink, :is_active, :is_default, :exchange_market_id,
                fees_attributes: [:id, :min, :max, :fee, :discount, :_destroy]

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

  form do |f|
    f.inputs 'Exchange Details' do
      f.input :name
      f.input :permalink
      f.input :is_active
      f.input :is_default
      f.input :default_exchange_market, collection: f.object.exchange_markets.map{ |em| [em.market.name, em.id] }
    end
    f.actions
  end
  
end
