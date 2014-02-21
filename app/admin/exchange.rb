ActiveAdmin.register Exchange do
  permit_params :id, :name, :permalink

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

  form do |e|
    e.inputs 'Exchange Details' do
      e.input :name
      e.input :permalink
      e.input :is_active
    end
    e.actions
  end
  
end
