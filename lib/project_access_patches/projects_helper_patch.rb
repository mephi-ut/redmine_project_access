module ProjectAccessPatches
module ProjectsHelperPatch
  def self.included(base)
    base.class_eval do
      alias_method :project_settings_tabs_without_project_access,
                   :project_settings_tabs unless method_defined? :project_settings_tabs_without_project_access

      def project_settings_tabs
        tabs = project_settings_tabs_without_project_access
        action = { :name => 'project_access',
                   :controller => 'project_access',
                   :action => :index,
                   :partial => 'project_access/settings',
                   :label => :label_project_access }
        tabs << action if !@project.is_public &&
                          @project.module_enabled?('redmine_project_access') &&
                          (User.current.admin? || User.current.allowed_to?(:edit_project_access, @project))
        return tabs
      end

    end
  end
end
end
