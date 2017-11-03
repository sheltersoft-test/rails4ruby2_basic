ActiveAdmin.register Resource do

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
  includes :resource_type, :resource_spec

  permit_params :resource_holder_id, :resource_holder_type, :resource_spec_id, :resource_type_id, :limited, :media, :is_active, :is_deleted

  filter :id
  filter :resource_holder_type
  filter :resource_holder_id, label: "Resource Holder ID"
  filter :resource_type
  filter :resource_spec


  # Index page definition
  index pagination_total: false do
    selectable_column
    id_column
    column :media do |r|
      if r.resource_type.name == "IMAGE"
        image_tag r.media.url(:small), class: "small_image"
      else
        link_to r.media_file_name, r.media.url
      end
    end
    column :resource_holder_type
    column "Resource Holder ID" do |r|
      r.resource_holder_id
    end
    column :resource_type
    column :resource_spec
    column :limited
    column :created_at
    actions
  end

  # Show page definition
  show do
    tabs do
      tab "Details" do
        attributes_table_for resource do
          row :id
          row :media do |r|
            if r.resource_type.name == "IMAGE"
			        image_tag r.media.url(:small), class: "small_image"
			      else
			       link_to r.media_file_name, r.media.url
			      end
          end
          row :resource_holder_type
          row "Resource Holder ID" do |r|
            r.resource_holder_id
          end
          row :resource_type
          row :resource_spec
          row :limited
          row :is_active
          row :is_deleted
          row :created_at
          row :updated_at
        end
      end
    end
  end

  form multipart: true do |f|
    tabs do
      f.semantic_errors *f.object.errors.keys
      tab "Details" do
        f.inputs "Resource Details" do
          f.input :media, :as => :file
          f.input :resource_holder_type, required: true, label: "Holder Type", as: :select, collection: $RESOURCE_HOLDERS, include_blank: false
          f.input :resource_holder_id, required: true, label: "Holder", as: :select, collection: ((f.object.new_record? ? $RESOURCE_HOLDERS[0] : f.object.resource_holder_type).classify.constantize.all.map{|u| [u.name, u.id]})
          f.input :resource_type, required: true
          f.input :resource_spec, required: true
          f.input :limited
          f.input :is_active
          f.input :is_deleted
        end
      end
    end
    f.actions
  end

end
