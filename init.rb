require 'redmine'

require 'project_patch'

Redmine::Plugin.register :redmine_cansee do
  name 'Redmine Cansee plugin'
  author 'Igor Zubkov'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

#  permission :cansee, { :cansee => :index }

  project_module :redmine_cansee do
    permission :view_cansee, :cansee => :index
    permission :edit_cansee, :cansee => :update
  end
  menu :project_menu, :cansee, { :controller => 'cansee', :action => 'index' }, :caption => 'Can See', :before => :settings, :param => :project_id
end

