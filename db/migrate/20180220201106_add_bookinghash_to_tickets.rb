class AddBookinghashToTickets < ActiveRecord::Migration[5.1]
  def change
    add_column :tickets, :bookinghash, :string
  end
end
