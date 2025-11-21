# frozen_string_literal: true

class AddIsRevealedToTickets < ActiveRecord::Migration[8.0]
  def change
    add_column :tickets, :is_revealed, :boolean, default: false, null: false
    add_index :tickets, [:retrospective_id, :is_revealed]
  end
end
