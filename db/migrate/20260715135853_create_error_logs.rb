class CreateErrorLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :error_logs do |t|
      t.text :input
      t.text :output
      t.string :category
      t.string :ip_hash
      t.integer :view_count

      t.timestamps
    end
  end
end
