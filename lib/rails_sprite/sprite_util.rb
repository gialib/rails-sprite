require "rails_sprite/stylesheet_generator"

module RailsSprite
  class SpriteUtil
    attr_reader :root_path, :scope_name, :recipe_path, :file_extend,
      :spacing, :image_to_folder, :image_source_folder,
      :stylesheet_to, :image_to_file_path, :css_class_prefix, :css_class_shared,
      :image_scope_name, :stylesheet_scope_name,
      :css_extend, :file_extend_name, :zoom

    #
    #  :css_extend => "",
    #  :root_path => '.',
    #  :scope_name => "rails_xxx",
    #  :recipe_path => "icons/16x16",
    #  :file_extend => '.png',
    #  :spacing => 10,
    #  :image_to_folder => "app/assets/images",
    #  :image_source_folder => 'app/assets/images/rails_xxx/sprite_sources',
    #  :stylesheet_to => "app/assets/stylesheets/rails_xxx/sprite/icons/16x16.css.scss.erb",
    #  :image_to_file_path => "rails_xxx/sprite/icons/16x16.png"
    #
    def initialize options={}
      @root_path                = options.fetch(:root_path, ::Rails.root)

      @scope_name               = options.fetch(:scope_name, '')
      @scope_name               = "#{scope_name}/" unless scope_name.end_with?('/')

      @recipe_path              = options.fetch(:recipe_path, '')
      @recipe_path              = recipe_path.chomp('/') if recipe_path.end_with?('/')

      @file_extend              = options.fetch(:file_extend, '.png').downcase
      @css_extend               = options.fetch(:css_extend, ".css.scss.erb")

      @file_extend_name = file_extend.gsub('.', '')

      @spacing                  = options.fetch(:spacing, 10)
      @stylesheet_scope_name    = "#{scope_name}sprite/#{recipe_path}#{css_extend}"
      @stylesheet_to            = options.fetch(:stylesheet_to, "#{root_path}/app/assets/stylesheets/#{stylesheet_scope_name}")

      @image_source_folder      = options.fetch(
        :image_source_folder, "#{root_path}/app/assets/images/#{scope_name}sprite_sources/#{recipe_path}"
      )

      @image_to_folder          = options.fetch(:image_to_folder, "#{root_path}/app/assets/images")
      @image_scope_name         = "#{scope_name}sprite/#{recipe_path}#{file_extend}"
      @image_to_file_path       = options.fetch(:image_to_file_path, "#{image_to_folder}/#{image_scope_name}")

      @scope_str                = scope_name.chomp('/').gsub('/', '-')
      @recipe_str               = recipe_path.chomp('/').gsub('/', '-')

      @css_class_shared         = options.fetch(:css_class_shared, "rs-#{@scope_str}")
      @css_class_prefix         = options.fetch(:css_class_prefix, "rs-#{@scope_str}-#{@recipe_str}-")

      @zoom                     = options.fetch(:zoom, 1).to_i
    end

    def perform
      file_infos = []

      #  puts "image_source_folder: #{image_source_folder}"
      #  puts "image_to_file_path: #{image_to_file_path}"
      #  puts "stylesheet_to: #{stylesheet_to}"

      counter = 0

      x = 0
      y = 0
      max_w = 0
      max_h = 0

      Dir.entries( image_source_folder ).each do |file_name|
        if file_name != '.' && file_name != '..' && file_name.end_with?(file_extend)
          file_path = "#{image_source_folder}/#{file_name}"

          if ::File.file?(file_path)
            file_name_split = file_name.split('.')
            file_name_split.pop
            file_purename = file_name_split.join('.')

            file_info = {
              :filepath => file_path,
              :filename => file_name,
              :file_purename => file_purename,
              :idx => counter
            }.merge(
              _library.load( file_path )
            )

            file_info[:x] = x
            file_info[:y] = y

            y += (spacing + file_info[:height])

            max_w = [max_w, file_info[:width]].max
            max_h = y

            file_infos << file_info

            counter += 1
          end
        end
      end

      _composite_images(:file_infos => file_infos, :max_w => max_w, :max_h => max_h)
      _composite_css(file_infos, :max_w => max_w, :max_h => max_h)
    end

    private

    def stylesheet_generator
      RailsSprite::StylesheetGenerator
    end

    def _library
      RailsSprite::Library::RMagick
    end

    def _composite_css file_infos, options
      stylesheet_generator.generate(
        :zoom => zoom,
        :css_class_shared => css_class_shared,
        :css_class_prefix => css_class_prefix,
        :file_infos => file_infos,
        :max_w => options[:max_w],
        :max_h => options[:max_h],
        :image_scope_name => image_scope_name,
        :css_extend => css_extend,
        :stylesheet_to => stylesheet_to
      )
    end

    def _composite_images options={}
      target = Magick::Image.new(options[:max_w], options[:max_h])
      target.opacity = Magick::QuantumRange

      options[:file_infos].each do |file_info|
        target.composite!(file_info[:image], file_info[:x], file_info[:y], Magick::SrcOverCompositeOp)
      end

      system "mkdir -p #{::File.dirname(image_to_file_path)}"

      target.write(image_to_file_path)
    end

  end
end
