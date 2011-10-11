require 'redmine'

require 'project_patch'

Redmine::Plugin.register :redmine_cansee do
  name 'Redmine Cansee plugin'
  author 'Igor Zubkov'
  description 'This is a plugin for Redmine adds hidden users for project'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  project_module :redmine_cansee do
    permission :edit_cansee, { :cansee => [:index, :update, :autocomplete_for_users] }
  end
  menu :project_menu, :cansee, { :controller => 'cansee', :action => 'index' }, :caption => 'Can See', :before => :settings, :param => :project_id
end

