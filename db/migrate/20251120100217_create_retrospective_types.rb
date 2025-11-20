# frozen_string_literal: true

class CreateRetrospectiveTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :retrospective_types do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end
end
