class AddUserToOwners < ActiveRecord::Migration[5.2]
  def change
    add_reference :owners, :user, null: false, foreign_key: true
  end
end
