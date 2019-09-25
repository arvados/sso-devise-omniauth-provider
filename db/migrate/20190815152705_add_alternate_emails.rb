class AddAlternateEmails < ActiveRecord::Migration
  def change
    add_column :users, :alternate_emails, :text
  end
end
