class AddBioIdToAuthor < ActiveRecord::Migration[5.2]
  def change
    add_column :authors, :bio, :string
  end
end
