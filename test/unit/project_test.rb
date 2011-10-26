require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < ActiveSupport::TestCase
  should_have_many :project_non_member_users

  context "#check_for_non_member" do
    should "return false if user not allowed to project as hidden user" do
      @project = Project.generate!(:is_public => false)
      @user = User.generate!

      assert !@project.check_for_non_member(@user)
    end

    should "return true if user allowed to project as hidden user" do
      @project = Project.generate!(:is_public => false)
      @user = User.generate!

      @pnmu = ProjectNonMemberUser.new
      @pnmu.project_id = @project.id
      @pnmu.user_id = @user.id
      @pnmu.save

      assert @project.check_for_non_member(@user)
    end

    should "return true if user in group which are allowed to access" do
      @project = Project.generate!(:is_public => false)
      @user = User.generate!
      @group = Group.generate!

      @group.users << @user

      @pnmu = ProjectNonMemberUser.new
      @pnmu.project_id = @project.id
      @pnmu.group_id = @group.id
      @pnmu.save

      assert @project.check_for_non_member(@user)
    end
  end
end

