module RailsSprite
  class StylesheetGenerator

    def self.generate options={}
      zoom = options.fetch(:zoom, 1).to_i
      css_class_prefix = options[:css_class_prefix]
      css_class_shared = options[:css_class_shared]
      css_extend = options[:css_extend] 
      image_scope_name = options[:image_scope_name]
      file_infos = options[:file_infos]
      stylesheet_to = options[:stylesheet_to]

      result = {:max_w => options[:max_w] / zoom, :max_h => options[:max_h] / zoom}
      styles = []

      file_infos.each do |file_info|
        style = {}

        style[:width] = "#{file_info[:width] / zoom}px"
        style[:height] = "#{file_info[:height] / zoom}px"
        style[:x] = "#{file_info[:x] / zoom}px"
        style[:y] = "#{file_info[:y] / zoom}px"
        style[:class] = "#{css_class_prefix}#{file_info[:file_purename]}"

        styles << style
      end

      result[:styles] = styles
      result[:image_scope_name] = image_scope_name
      result[:css_class_shared] = css_class_shared

      css_filt_content = case css_extend
                         when '.css.scss.erb', '.scss.erb'
                           composite_css_scss_erb(result)
                         when '.css', '.scss'
                           composite_css_scss(result)
                         else
                         end

      system "mkdir -p #{::File.dirname(stylesheet_to)}"

      ::File.open(stylesheet_to, 'w') do |file|
        file.write(css_filt_content)
      end

      result
    end

    def self.composite_css_scss result
      styles = []

      styles << <<-END_CSS
// 将下面3行，放入页面中(仅供参考)
// .#{result[:css_class_shared]} {
//   background-image: url(<%= image_path("#{result[:image_scope_name]}") %>);
// }
END_CSS

      styles << <<-END_CSS
.#{result[:css_class_shared]} {
  background-repeat: no-repeat;
  background-size: #{result[:max_w]}px #{result[:max_h]}px;
}
END_CSS

      result[:styles].each do |style|
        styles << <<-END_CSS
.#{style[:class]} {
  background-position: #{style[:x]} -#{style[:y]};
  height: #{style[:height]};
  width: #{style[:width]};
}
        END_CSS
      end

      styles.join("\n")
    end

    def self.composite_css_scss_erb result
      styles = []

      styles << <<-END_CSS
.#{result[:css_class_shared]} {
  background-image: url(<%= image_path("#{result[:image_scope_name]}") %>);
  background-repeat: no-repeat;
  background-size: #{result[:max_w]}px #{result[:max_h]}px;
}
END_CSS

      result[:styles].each do |style|
        styles << <<-END_CSS
.#{style[:class]} {
  background-position: #{style[:x]} -#{style[:y]};
  height: #{style[:height]};
  width: #{style[:width]};
}
        END_CSS


#  .#{style[:class]} {
#    background: url(<%= image_path("#{result[:image_scope_name]}") %>) #{style[:x]} -#{style[:y]} no-repeat;
#  }
      end

      styles.join("\n")
    end

  end
end
