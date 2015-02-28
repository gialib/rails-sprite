require 'test_helper'

class RailsSpriteTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, RailsSprite
  end

  test "perform" do
    util = ::RailsSprite::SpriteUtil.new(
      :root_path => "#{File.dirname(__FILE__)}/./fixtures/testing",
      :scope_name => "rails_xxx/",
      :recipe_path => "icons/32x32",
      :css_class_shared => 'rails_xxx-icon',
      :css_class_prefix => 'icons-32x32-'
    )

    util.perform
  end
end
