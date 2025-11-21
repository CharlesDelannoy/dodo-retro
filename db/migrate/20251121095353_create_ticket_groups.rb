# frozen_string_literal: true

class CreateTicketGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :ticket_groups do |t|
      t.references :retrospective, null: false, foreign_key: true
      t.string :title
      t.references :created_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
