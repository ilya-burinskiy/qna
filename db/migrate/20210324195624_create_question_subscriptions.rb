class CreateQuestionSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :question_subscriptions do |t|
      t.references :question, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.index [:user_id, :question_id], unique: true

      t.timestamps
    end
  end
end
