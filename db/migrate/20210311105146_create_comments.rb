class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true, null: false
      t.references :author, foreign_key: { to_table: 'users' }, null: false
      t.text :body, null: false
      
      t.timestamps
    end
  end
end
