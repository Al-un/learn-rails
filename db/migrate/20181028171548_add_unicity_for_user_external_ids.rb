class AddUnicityForUserExternalIds < ActiveRecord::Migration[5.2]
  def change
    # https://stackoverflow.com/a/3370333/4906586
    add_index :users, :auth0_id, {unique: true}
  end
end
