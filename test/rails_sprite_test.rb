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
      :css_class_prefix => 'icons-32x32-',
      :zoom => 2

      #  :root_path => '.',
      #  :scope_name => "rails_xxx",
      #  :recipe_path => "icons/16x16",
      #  :file_extend => '.png',
      #  :spacing => 10,
      #  :image_to_folder => "app/assets/images",
      #  :image_source_folder => 'app/assets/images/rails_xxx/sprite_sources',
      #  :stylesheet_to => "app/assets/stylesheets/rails_xxx/sprite/icons/16x16.css.scss.erb",
      #  :image_to_file_path => "rails_xxx/sprite/icons/16x16.png"
    )

    util.perform
  end
end
