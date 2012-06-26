require_dependency 'principal'

module ProjectAccessPatches
module UserPatch
  def self.included(base)
    base.class_eval do
      def allowed_to?(action, context, options={}, &block)
        if context && context.is_a?(Project)
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
        elsif context && context.is_a?(Array)
          # Authorize if user is authorized on every element of the array
          context.map do |project|
            allowed_to?(action, project, options, &block)
          end.inject do |memo,allowed|
            memo && allowed
          end
        elsif options[:global]
          # Admin users are always authorized
          return true if admin?

          # authorize if user has at least one role that has this permission
          roles = memberships.collect {|m| m.roles}.flatten.uniq
          roles << (self.logged? ? Role.non_member : Role.anonymous)
          roles.detect {|role|
            role.allowed_to?(action) &&
            (block_given? ? yield(role, self) : true)
          }
        else
          false
        end
      end
    end
  end
end
end
