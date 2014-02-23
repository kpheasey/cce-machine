ActiveAdmin.register Market do
  permit_params :id, :name, :permalink, :is_active, :is_default, :source_id, :target_id

  filter :name
  filter :is_active
  filter :is_default

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  index do
    column :name
    column :source
    column :target
    column :is_active
    column :is_default
    default_actions
  end

  form do |f|
    f.inputs 'Market Details' do
      f.input :name
      f.input :source
      f.input :target
      f.input :permalink
      f.input :is_active
      f.input :is_default
    end
    f.actions
  end

end
