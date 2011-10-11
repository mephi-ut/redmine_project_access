require_dependency 'project'

module ProjectPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      has_many :project_non_member_users
    end
  end

  module InstanceMethods
    def check_for_non_member(user)
      return true if ProjectNonMemberUser.find(:first,
                                               :conditions => {
                                                 :project_id => self.id,
                                                 :user_id => user.id })
      return true if ProjectNonMemberUser.find(:first,
                                               :conditions =>
                                                 ["project_id = ? AND group_id IN (?)",
                                                 self.id, User.current.groups.map(&:id)])
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

