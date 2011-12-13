require File.dirname(__FILE__) + '/../../test_helper'

class ProjectsHelperTest < ActionView::TestCase
#  context "#project_settings_tabs" do
#    should "not show access tab if module not enabled" do
#      @project = Project.generate!(:is_public => false)
#      @project.enabled_module_names = [:issue_tracking]
#      assert_equal [], project_settings_tabs
#    end
#
#    should "show access tab if user has :edit_project_access perm" do
#      @project = Project.generate!(:is_public => false)
#      @project.enabled_module_names = [:issue_tracking, :redmine_project_access]
#      @user = User.generate!
#
#      @role = Role.new
#      @role.name = 'Some role'
#      @role.permissions = [:edit_project_access]
#      @role.save!
#
#      @member = Member.new
#      @member.user = @user
#      @member.project = @project
#      @member.roles << @role
#      @member.save!
#
#      assert_equal [], project_settings_tabs
#    end
#  end
end

