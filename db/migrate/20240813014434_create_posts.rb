class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.string :username
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
