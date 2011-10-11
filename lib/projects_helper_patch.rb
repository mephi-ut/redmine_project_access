require_dependency 'projects_helper'

module ProjectsHelperPatch
  def self.included(base)
    base.class_eval do
      alias_method :_project_settings_tabs, :project_settings_tabs unless method_defined? :_project_settings_tabs

      def project_settings_tabs
        tabs = _project_settings_tabs
        action = { :name => 'project_access',
                   :controller => 'project_access',
                   :action => :index,
                   :partial => 'project_access/settings',
                   :label => :label_project_access }
        tabs << action if !@project.is_public && @project.module_enabled?('redmine_project_access')
        return tabs
      end

    end
  end
end

require 'dispatcher'
  Dispatcher.to_prepare do
    begin
      require_dependency 'application'
    rescue LoadError
      require_dependency 'application_controller'
    end

  ProjectsHelper.send(:include, ProjectsHelperPatch)
end

