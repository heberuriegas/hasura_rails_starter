class CreateOauthIdentities < ActiveRecord::Migration[6.1]
  def change
    create_table :oauth_identities do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
