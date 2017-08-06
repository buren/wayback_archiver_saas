class AddStatsToArchivation < ActiveRecord::Migration[5.1]
  def change
    add_column :archivations, :stats, :jsonb, null: false, default: '{}'
  end
end
