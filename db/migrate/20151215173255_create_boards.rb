class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.integer :turn

      t.timestamps null: false
    end
  end
end
