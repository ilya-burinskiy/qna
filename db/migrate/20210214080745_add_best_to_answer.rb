class AddBestToAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :answers, :best, :boolean
    change_column_default :answers, :best, from: nil, to: false
  end
end
