class RenameNameToFirstNameInUsers < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :name, :first_name
  end
end
