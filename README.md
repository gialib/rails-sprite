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

        ::RailsSprite.sprite(
          :root_path => "#{::File.dirname(__FILE__)}/..",
          :scope_name => "rails_app_name/",
          :recipe_path => "icons/16x16",
          :css_class_prefix => "u-icons-16x16-",
          :spacing => 10
        )
    
```
