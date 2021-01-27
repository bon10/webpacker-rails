class CreatePhoto < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.references :post, foreign_key: true
      t.string :title
      t.text :image_data
      t.string :image_url
      t.timestamps #created_at, updated_atを自動で作成
    end
  end
end