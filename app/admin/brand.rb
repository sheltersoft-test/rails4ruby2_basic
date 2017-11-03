ActiveAdmin.register Brand do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

	permit_params :name, :prefix, :logo, :description, :phone_number, :email, :is_active, :is_deleted

  filter :id
  filter :name
  filter :prefix
  filter :email

	# Index page definition
  index pagination_total: false do
    selectable_column
    id_column
    column :logo do |l|
      image_tag l.logo.url(:small)
    end
    column :name
    column :prefix
    column :email
    column :created_at
    actions
  end

  # Show page definition
  show do
    tabs do
      tab "Details" do
        attributes_table_for brand do
          row :id
          row :logo do |l|
            image_tag l.logo.url
          end
          row :name
          row :prefix
          row :email
          row :phone_number
          row :is_active
          row :is_deleted
          row :created_at
          row :updated_at
        end
      end
      tab "Description" do
        brand.description
      end
    end
  end

  form multipart: true do |f|
    tabs do
      f.semantic_errors *f.object.errors.keys
      tab "Details" do
        f.inputs "Brand Details" do
          f.input :logo, :as => :file
          f.input :name, required: true
          if f.object.new_record?
            f.input :prefix, required: true
          else
            f.input :prefix, :input_html => { :readonly => true }
          end
          f.input :email
          f.input :phone_number
          f.input :is_active
          f.input :is_deleted
        end
      end
      tab "Description" do
        f.inputs "Description" do
          f.input :description, :as => :text, input_html: {rows: 4}
        end
      end
    end
    f.actions
  end

end
