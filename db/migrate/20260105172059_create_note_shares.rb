class CreateNoteShares < ActiveRecord::Migration[7.1]
  def change
    create_table :note_shares do |t|
      t.references :note, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    remove_index :note_shares, column: [:note_id, :user_id], if_exists: true

  end
end
