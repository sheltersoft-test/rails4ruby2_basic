ActiveAdmin.register LanguageSkill do

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
  includes :brand
  
  menu :if => proc{ current_admin_user }, parent: 'Settings'

	permit_params :brand_id, :is_active, :is_deleted,
                language_skill_localizations_attributes: [:id, :name, :language_code, :is_active, :is_deleted, :_destroy]

  filter :id
  # Index page definition
  index pagination_total: false do
    selectable_column
    id_column
    column :brand
    column :name do |l|
      l.localize(I18n.locale).try(:name)
    end
    column :created_at
    actions
  end

  # Show page definition
  show do
    tabs do
      tab "Details" do
        attributes_table_for language_skill do
          row :id
          row :brand
          row :is_active
          row :is_deleted
          row :created_at
          row :updated_at
        end
      end
      tab "Localizations" do
      	panel "Localizations" do
          table_for language_skill.language_skill_localizations do
            column :id
            column :name
            column :language_code
            column :is_active
            column :is_deleted
          end
        end
      end
    end
  end

  form multipart: true do |f|
    tabs do
      f.semantic_errors *f.object.errors.keys
      tab "Details" do
        f.inputs "Language Skill Details" do
          f.input :brand, required: true
          f.input :is_active
          f.input :is_deleted
        end
      end
      tab "Localizations" do
      	f.inputs "Localizations" do
          f.has_many :language_skill_localizations, new_record: "Add a Localization", allow_destroy: true do |ff|
            ff.semantic_errors *ff.object.errors.keys

            ff.input :name, required: true
            ff.input :language_code, as: :select, collection: Settings.locale.languages.map{|d| d['code']}
            ff.input :is_active
            ff.input :is_deleted
          end
        end
      end
    end
    f.actions
  end

end
