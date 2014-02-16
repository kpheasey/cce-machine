ActiveAdmin.register Market do
  permit_params :id, :name, :permalink, fees_attributes: [:id, :min, :max, :fee, :discount, :_destroy]

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  index do
    column :name
    default_actions
  end

  form do |m|
    m.inputs 'Market Details' do
      m.input :name
      m.input :permalink
    end
    m.actions
  end

end
