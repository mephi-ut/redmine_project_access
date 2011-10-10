class CreateProjectNonMemberUsers < ActiveRecord::Migration
  def self.up
    create_table :project_non_member_users, :id => false do |t|
      t.column :project_id, :integer
      t.column :user_id, :integer
    end
    add_index :project_non_member_users, :project_id
    add_index :project_non_member_users, :user_id
  end

  def self.down
    remove_index :project_non_member_users, :project_id
    remove_index :project_non_member_users, :user_id
    drop_table :project_non_member_users
  end
end

