ActiveAdmin.register Market do
  permit_params :id, :name, :permalink, fees_attributes: [:id, :min, :max, :fee, :discount, :_destroy]

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  index do
    column :name
    column :is_active
    default_actions
  end

  form do |m|
    m.inputs 'Market Details' do
      m.input :name
      m.input :permalink
      m.input :is_active
    end
    m.actions
  end

end
