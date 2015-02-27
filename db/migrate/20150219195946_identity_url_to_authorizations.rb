class IdentityUrlToAuthorizations < ActiveRecord::Migration
  def up
    # 1. Add uuid column to users
    add_column :users, :uuid, :string

    # 2. Generate an Arvados uuid for each user
    users = ActiveRecord::Base.connection.select_all "select id from users"
    users.each do |user_id|
      uuid = [CfiOauthProvider::Application.config.uuid_prefix,
              'tpzed',
              rand(2**256).to_s(36)[-15..-1]].
             join '-'
      ActiveRecord::Base.connection.execute "update users set uuid = '#{uuid}' where id = #{user_id['id']}"
    end

    # 3. For each user, create an "authentications" record with:
    #     user_id = user_id
    #     provider = "google"
    #     uid = identity_url
    #     created_at = created_at
    #     updated_at = updated_at

    ActiveRecord::Base.connection.execute "insert into authentications (user_id, provider, uid, created_at, updated_at) select id, 'google', identity_url, created_at, updated_at from users where identity_url like 'https://www.google.com/accounts/o8/%'"

    # 4. Delete identity_url column.
    remove_column :users, :identity_url

    add_index :users, :uuid, :unique => true
    add_index :authentications, [:provider, :uid], :unique => true
  end

  def down
    add_column :users, :identity_url, :string

    auth = ActiveRecord::Base.connection.select_all "select user_id, uid from authentications where provider='google'"
    auth.each do |a|
      ActiveRecord::Base.connection.execute "update users set identity_url = '#{a['uid']}' where id = #{a['user_id']}"
    end

    ActiveRecord::Base.connection.execute "delete from authentications where provider='google'"

    remove_column :users, :uuid, :string
    remove_index :authentications, :column => [:provider, :uid]
  end
end
