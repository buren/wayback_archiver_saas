class AddHostToArchivations < ActiveRecord::Migration[5.1]
  def change
    add_column :archivations, :host, :string
    add_index :archivations, :host

    remove_index :archivations, :url
  end
end
