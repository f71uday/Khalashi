class CreateTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      t.string :booking_id
      t.string :team_id
      t.integer :members
      t.integer :amt_paid
      t.string :name

      t.timestamps
    end
  end
end
