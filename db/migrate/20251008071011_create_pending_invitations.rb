class CreatePendingInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :pending_invitations do |t|
      t.references :team, null: false, foreign_key: true
      t.string :email, null: false
      t.references :inviter, null: false, foreign_key: { to_table: :users }
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end

    add_index :pending_invitations, [:team_id, :email], unique: true
    add_index :pending_invitations, :email
  end
end
