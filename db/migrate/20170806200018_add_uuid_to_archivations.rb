class AddUuidToArchivations < ActiveRecord::Migration[5.1]
  def change
    add_column :archivations, :uuid, :string
  end
end
