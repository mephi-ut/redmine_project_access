require_dependency 'project'

module ProjectPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def check_for_non_member(user)
      return true if ProjectNonMemberUser.find(:first, :conditions => { :project_id => self.id, :user_id => user.id })
      false
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

  Project.send(:include, ProjectPatch)
end

