require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < ActiveSupport::TestCase
  should_have_many :project_non_member_users
end

