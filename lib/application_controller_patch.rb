require_dependency 'application_controller'

module ApplicationControllerPatch
  def self.included(base)
    base.class_eval do
      alias_method :check_project_privacy_without_project_access,
                   :check_project_privacy unless method_defined? :check_project_privacy_without_project_access

      def check_project_privacy
        if @project &&
           !@project.is_public? &&
           @project.module_enabled?('redmine_project_access')
          return true if @project.check_for_non_member(User.current)
        end
        check_project_privacy_without_project_access
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

  ApplicationController.send(:include, ApplicationControllerPatch)
end

