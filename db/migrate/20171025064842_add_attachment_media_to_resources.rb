class AddAttachmentMediaToResources < ActiveRecord::Migration
  def self.up
    change_table :resources do |t|
      t.attachment :media
    end
  end

  def self.down
    remove_attachment :resources, :media
  end
end
