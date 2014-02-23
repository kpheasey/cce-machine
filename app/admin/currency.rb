ActiveAdmin.register Currency do
  permit_params :id, :name, :code

  filter :name
  filter :code

  index do
    column :name
    column :code
    default_actions
  end

  form do |f|
    f.inputs 'Currency Details' do
      f.input :name
      f.input :code
    end
    f.actions
  end

end
