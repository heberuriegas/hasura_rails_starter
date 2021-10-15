class CreateOauthAssertions < ActiveRecord::Migration[6.1]
  def change
    create_table :oauth_assertions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps
    end
  end
end
