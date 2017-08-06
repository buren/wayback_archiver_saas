class CreateArchivations < ActiveRecord::Migration[5.1]
  def change
    create_table :archivations do |t|
      t.string :url
      t.string :strategy
      t.integer :status
      t.string :notification_email

      t.timestamps
    end

    add_index :archivations, :url
  end
end
