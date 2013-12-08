ActiveAdmin.register Market do
  permit_params :id, :name, fees_attributes: [:id, :min, :max, :fee, :discount, :_destroy]

  index do
    column :name
    default_actions
  end

  form do |m|
    m.inputs "Market Details" do
      m.input :name
      m.has_many :fees do |f|
        f.input :min
        f.input :max
        f.input :fee
        f.input :discount
        f.input :_destroy, label: 'Delete this fee', as: :boolean
      end
    end
    m.actions
  end

end
