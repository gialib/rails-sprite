require 'RMagick'

module RailsSprite
  module Library
    module RMagick

      VALID_EXTENSIONS = [:png, :jpg, :jpeg, :gif, :ico]

      def self.load(filename)
        image = Magick::Image.read(filename)[0]

        {
          :image    => image,
          :width    => image.columns,
          :height   => image.rows
        }
      end

      def self.create(filename, images, width, height)
        target = Magick::Image.new(width, height)
        target.opacity = Magick::QuantumRange
        images.each do |image|
          target.composite!(image[:image], image[:x], image[:y], Magick::SrcOverCompositeOp)
        end
        target.write(filename)
      end

    end # module RMagick
  end # module Library
end # module SpriteFactory
