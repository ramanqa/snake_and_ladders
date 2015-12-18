class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.belongs_to :board, index: true
      t.text :name
      t.integer :position

      t.timestamps null: false
    end
  end
end
