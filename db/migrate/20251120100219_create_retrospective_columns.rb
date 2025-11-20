# frozen_string_literal: true

class CreateRetrospectiveColumns < ActiveRecord::Migration[8.0]
  def change
    create_table :retrospective_columns do |t|
      t.references :retrospective_type, null: false, foreign_key: true
      t.string :name, null: false
      t.string :color
      t.integer :position, null: false

      t.timestamps
    end
  end
end
