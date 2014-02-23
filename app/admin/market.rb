ActiveAdmin.register Market do
  permit_params :id, :name, :permalink, :is_active, :is_default

  filter :name
  filter :code
  filter :is_active
  filter :is_default

  controller do
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
    f.inputs 'Market Details' do
      f.input :name
      f.input :permalink
      f.input :is_active
      f.input :is_default
    end
    f.actions
  end

end
