class CreateShifts < ActiveRecord::Migration[6.0]
  def change
    create_table :shifts do |t|
      t.integer :user_id
      t.boolean :draft, default: false
      t.date :workday

      t.timestamps
    end
  end
end
