class ReplaceBodyStringToTextInReviews < ActiveRecord::Migration
  def change
    remove_column :reviews, :body
    add_column :reviews, :body, :text
  end
end
