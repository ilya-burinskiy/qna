class AddIndexToQuestionsOnCreatedAt < ActiveRecord::Migration[6.1]
  def change
    add_index :questions, :created_at
  end
end
