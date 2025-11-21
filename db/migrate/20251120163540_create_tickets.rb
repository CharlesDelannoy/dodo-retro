# frozen_string_literal: true

class CreateTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :tickets do |t|
      t.references :retrospective, null: false, foreign_key: true
      t.references :retrospective_column, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.text :content, null: false
      t.integer :position, default: 0

      t.timestamps
    end

    add_index :tickets, [:retrospective_id, :position]
  end
end
