require 'rails_sprite/sprite_util'
require 'rails_sprite/library/rmagick'

module RailsSprite
  def self.sprite options={}
    ::RailsSprite::SpriteUtil.new( options ).perform
  end
end
