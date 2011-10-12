require_dependency 'user'

module UserPatch
  def self.included(base)
    base.class_eval do
      alias_method :rpa_allowed_to?, :allowed_to? unless method_defined? :rpa_allowed_to?

      def allowed_to?(action, context, options={}, &block)
        result = rpa_allowed_to?(action, context, options, &block)
        if !result && context && context.is_a?(Project)
          # No action allowed on archived projects
          return false unless context.active?
          # No action allowed on disabled modules
          return false unless context.allows_to?(action)
          # Admin users are authorized for anything else
          return true if admin?

          roles = roles_for_project(context)
          return false unless roles
          roles.detect {|role|
            (context.is_public? || role.member? || context.check_for_non_member(User.current)) &&
            role.allowed_to?(action) &&
            (block_given? ? yield(role, self) : true)
          }
        end
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

  User.send(:include, UserPatch)
end

