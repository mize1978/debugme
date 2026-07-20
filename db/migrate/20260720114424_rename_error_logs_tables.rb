class RenameErrorLogsTables < ActiveRecord::Migration[7.2]
  def change
    rename_table :error_logs, :debug_logs
  end
end
