require_dependency 'principal'

module ProjectAccessPatches
module UserPatch
  def self.included(base)
    base.class_eval do

      alias_method :allowed_to_without_project_access?,
                   :allowed_to? unless method_defined? :allowed_to_without_project_access?

      def allowed_to?(action, context, options={}, &block)
        if context && context.is_a?(Project) &&
           context.active? &&
           context.allows_to?(action)
          return true if admin?
          roles = roles_for_project(context)
          return false unless roles
          if roles.detect {|role|
               context.check_for_non_member(User.current) &&
               role.allowed_to?(action) &&
               (block_given? ? yield(role, self) : true)
             }
            return true
          end
        end
        allowed_to_without_project_access?(action, context, options)
      end
    end
  end
end
end
