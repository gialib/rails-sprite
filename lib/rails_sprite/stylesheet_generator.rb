module RailsSprite
  class StylesheetGenerator

    def self.generate options={}
      css_class_prefix = options[:css_class_prefix]
      css_class_shared = options[:css_class_shared]
      css_extend = options[:css_extend] 
      image_scope_name = options[:image_scope_name]
      file_infos = options[:file_infos]
      stylesheet_to = options[:stylesheet_to]

      result = {}

      styles = []

      file_infos.each do |file_info|
        style = {}

        style[:width] = "#{file_info[:width]}px"
        style[:height] = "#{file_info[:height]}px"
        style[:x] = "#{file_info[:x]}px"
        style[:y] = "#{file_info[:y]}px"
        style[:class] = "#{css_class_prefix}#{file_info[:file_purename]}"

        styles << style
      end


      result[:styles] = styles
      result[:image_scope_name] = image_scope_name
      result[:css_class_shared] = css_class_shared

      # case css_extend
      # when '.css.scss.erb'
      # else
      # end

      system "mkdir -p #{::File.dirname(stylesheet_to)}"

      ::File.open(stylesheet_to, 'w') do |file|
        file.write( composite_css_scss_erb(result) )
      end

      result
    end

    def self.composite_css_scss_erb result
      styles = []

      result[:styles].each do |style|
        styles << <<-END_CSS
.#{style[:class]} {
  background: url(<%= image_path("#{result[:image_scope_name]}") %>) #{style[:x]} -#{style[:y]} no-repeat;
}
        END_CSS
      end


#       styles << <<-END_CSS
# .#{result[:css_class_shared]} {
#   background: url(<%= image_path("#{result[:image_scope_name]}") %>) no-repeat;
# }
#       END_CSS

#      result[:styles].each do |style|
#        styles << <<-END_CSS
#.#{style[:class]} {
#  background-position: #{style[:x]} -#{style[:y]};
#}
#        END_CSS
#      end


      styles.join("\n")
    end

    # def self.generate(style_name, selector, url, images)
    #   styles = []
    #   images.each do |image|
    #     attr = [
    #       "width: #{image[:cssw]}px",
    #       "height: #{image[:cssh]}px",
    #       "background: #{url} #{-image[:cssx]}px #{-image[:cssy]}px no-repeat"
    #     ]
    #     image[:selector] = selector                          # make selector available for (optional) custom rule generators
    #     image[:style]    = send("#{style_name}_style", attr) # make pure style available for (optional) custom rule generators (see usage of yield inside Runner#style)
    #     styles << send(style_name, selector, image[:name], attr)
    #   end
    #   styles << ""
    #   styles.join("\n")
    # end

  end
end
