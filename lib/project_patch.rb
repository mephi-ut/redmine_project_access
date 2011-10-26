require_dependency 'project'

module ProjectPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      has_many :project_non_member_users

      # Copy of Project.allowed_to_condition from Project model
      # Returns a SQL conditions string used to find all projects for which +user+ has the given +permission+
      #
      # Valid options:
      # * :project => limit the condition to project
      # * :with_subprojects => limit the condition to project and its subprojects
      # * :member => limit the condition to the user projects
      def self.allowed_to_condition(user, permission, options={})
        base_statement = "#{Project.table_name}.status=#{Project::STATUS_ACTIVE}"
        if perm = Redmine::AccessControl.permission(permission)
          unless perm.project_module.nil?
            # If the permission belongs to a project module, make sure the module is enabled
            base_statement << " AND #{Project.table_name}.id IN (SELECT em.project_id FROM #{EnabledModule.table_name} em WHERE em.name='#{perm.project_module}')"
          end
        end
        if options[:project]
          project_statement = "#{Project.table_name}.id = #{options[:project].id}"
          project_statement << " OR (#{Project.table_name}.lft > #{options[:project].lft} AND #{Project.table_name}.rgt < #{options[:project].rgt})" if options[:with_subprojects]
          base_statement = "(#{project_statement}) AND (#{base_statement})"
        end

        if user.admin?
          base_statement
        else
          statement_by_role = {}
          unless options[:member]
            role = user.logged? ? Role.non_member : Role.anonymous
            if role.allowed_to?(permission)
              statement_by_role[role] = "(#{Project.table_name}.is_public = #{connection.quoted_true}) OR \
              (projects.id IN (SELECT #{Project.table_name}.id \
                               FROM #{Project.table_name}, #{ProjectNonMemberUser.table_name} \
                               WHERE #{Project.table_name}.id = #{ProjectNonMemberUser.table_name}.project_id \
                               AND (#{ProjectNonMemberUser.table_name}.user_id = #{user.id} \
                               OR #{ProjectNonMemberUser.table_name}.group_id IN (#{user.groups.map(&:id).join(',')}))\
                               ) \
                              )"
            end
          end
          if user.logged?
            user.projects_by_role.each do |role, projects|
              if role.allowed_to?(permission)
                statement_by_role[role] = "#{Project.table_name}.id IN (#{projects.collect(&:id).join(',')})"
              end
            end
          end
          if statement_by_role.empty?
            "1=0"
          else
            if block_given?
              statement_by_role.each do |role, statement|
                if s = yield(role, user)
                  statement_by_role[role] = "(#{statement} AND (#{s}))"
                end
              end
            end
            "((#{base_statement}) AND (#{statement_by_role.values.join(' OR ')}))"
          end
        end
      end

    end
  end

  module InstanceMethods
    def check_for_non_member(user)
      if ProjectNonMemberUser.find(:first,
                                   :conditions => {
                                     :project_id => self.id,
                                     :user_id => user.id })
        return true
      end
      if ProjectNonMemberUser.find(:first,
                                   :conditions =>
                                     ["project_id = ? AND group_id IN (?)",
                                     self.id, user.groups.map(&:id)])
        return true
      end
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

