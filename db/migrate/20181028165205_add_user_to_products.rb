class AddUserToProducts < ActiveRecord::Migration[5.2]
  def change
    # https://stackoverflow.com/a/39937840/4906586
    add_reference :articles, :user, foreign_key: true
    add_reference :catalogs, :user, foreign_key: true
  end
end
