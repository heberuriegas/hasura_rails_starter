class AddIdentities < ActiveRecord::Migration[6.1]
  def change
    create_table :identities do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :access_token
      t.string :refresh_token
      t.jsonb :auth_hash, default: {}

      t.timestamps
    end

    add_index :identities, %i[provider uid], unique: true

    remove_column :users, :provider, :string, null: false, default: "email"
    remove_column :users, :uid, :string, null: false, default: "email"
  end
end
