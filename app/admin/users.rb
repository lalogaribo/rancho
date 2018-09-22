ActiveAdmin.register User do
  permit_params :name, :email

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Crear usuario' do
      if f.object.new_record?
        f.input :name
        f.input :email
      end
    end
    f.actions
  end
end
