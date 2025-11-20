# frozen_string_literal: true

class CreateRetrospectives < ActiveRecord::Migration[8.0]
  def change
    create_table :retrospectives do |t|
      t.references :team, null: false, foreign_key: true
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.references :retrospective_type, null: false, foreign_key: true
      t.string :title, null: false
      t.string :current_step, null: false, default: 'ice_breaker'
      t.references :current_revealing_user, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
