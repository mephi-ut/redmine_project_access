require 'redmine'

Redmine::Plugin.register :redmine_project_access do
  name 'Redmine Project Access plugin'
  author 'Igor Zubkov'
  description 'This is a plugin for Redmine adds hidden users for project'
  version '0.0.10'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  project_module :public_project do
    permission :edit_project_access, { :project_access => [:update, :autocomplete_for_users] }
  end
end

if Rails::VERSION::MAJOR < 3
  require 'dispatcher'
  prepare = Dispatcher
else
  prepare = ActionDispatch::Callbacks
end


prepare.to_prepare do
  begin
    require_dependency 'application'
  rescue LoadError
    require_dependency 'application_controller'
  end

  require_dependency 'project'
  require_dependency 'projects_helper'
  require_dependency 'application_controller'
  require_dependency 'user'

  ApplicationController.send(:include, ProjectAccessPatches::ApplicationControllerPatch)
  Project.send(:include, ProjectAccessPatches::ProjectPatch)
  ProjectsHelper.send(:include, ProjectAccessPatches::ProjectsHelperPatch)
  User.send(:include, ProjectAccessPatches::UserPatch)
end

