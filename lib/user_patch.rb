require_dependency 'user'

module UserPatch
  def self.included(base)
    base.class_eval do
      alias_method :rpa_allowed_to?, :allowed_to? unless method_defined? :rpa_allowed_to?

      def allowed_to?(action, context, options={}, &block)
        rpa_allowed_to?(action, context, options, &block) ||
          (context &&
          context.is_a?(Project) &&
          context.check_for_non_member(User.current))
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

