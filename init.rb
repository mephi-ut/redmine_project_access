require 'redmine'

require 'project_patch'

Redmine::Plugin.register :redmine_project_access do
  name 'Redmine Cansee plugin'
  author 'Igor Zubkov'
  description 'This is a plugin for Redmine adds hidden users for project'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  project_module :redmine_project_access do
    permission :edit_project_access, { :project_access => [:index, :update, :autocomplete_for_users] }
  end
  menu :project_menu, :project_access, { :controller => 'project_access', :action => 'index' }, :caption => :label_project_access, :before => :settings, :param => :project_id
end

