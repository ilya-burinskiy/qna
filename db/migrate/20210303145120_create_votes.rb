class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true, null: false
      t.references :voter, foreign_key: { to_table: 'users' }, null: false
      t.integer :status, null: false
      t.index [:voter_id, :votable_type, :votable_id], unique: true

      t.timestamps
    end
  end
end
