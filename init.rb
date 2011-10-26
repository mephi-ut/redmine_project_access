require 'redmine'

require 'user_patch'
require 'project_patch'
require 'projects_helper_patch'

Redmine::Plugin.register :redmine_project_access do
  name 'Redmine Project Access plugin'
  author 'Igor Zubkov'
  description 'This is a plugin for Redmine adds hidden users for project'
  version '0.0.8'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  project_module :redmine_project_access do
    permission :edit_project_access, { :project_access => [:update, :autocomplete_for_users] }
  end
end

