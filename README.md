# RailsSprite

```
  eg.

    image source folder:

      app/assets/images/rails_xxx/sprite_sources

    image sprite source:

      icons/16x16/*.png
      icons/32x32/*.png

    image sprice to:

      app/assets/images/rails_xxx/sprite

    config:

      simple:

      RailsSprite.sprite(
        :root_path => "#{File.dirpath(__FILE__)}/..",
        :scope_name => "rails_xxx/",
        :recipe_path => "icons/16x16",
        :file_extend => '.png',
        :spacing => 10,
        :css_class_shared => 'rails_xxx-icon',
        :css_class_prefix => 'icons-16x16-'
      )

    
```
