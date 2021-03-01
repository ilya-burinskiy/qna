class RenameAssociationsToUser < ActiveRecord::Migration[6.1]
  def up
    rename_index :answers, 'index_answers_on_user_id', 'index_answers_on_author_id'
    rename_column :answers, :user_id, :author_id

    rename_index :questions, 'index_questions_on_user_id', 'index_questions_on_author_id'
    rename_column :questions, :user_id, :author_id

    rename_index :rewards, 'index_rewards_on_user_id', 'index_rewards_on_author_id'
    rename_column :rewards, :user_id, :author_id
  end

  def down
    rename_index :answers, 'index_answers_on_author_id', 'index_answers_on_user_id'
    rename_column :answers, :author_id, :user_id

    rename_index :questions, 'index_questions_on_author_id', 'index_questions_on_user_id'
    rename_column :questions, :author_id, :user_id

    rename_index :rewards, 'index_rewards_on_author_id', 'index_rewards_on_user_id'
    rename_column :rewards, :author_id, :user_id
  end
end

