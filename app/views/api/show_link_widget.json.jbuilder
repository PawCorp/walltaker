json.name "Walltaker Link #{@link.id}"
json.description "Shows the current wallpaper for #{@link.user.username}'s link."
json.version 1
json.data do
  json.content_url link_url @link
  json.wallpaper @link.post_thumbnail_url || ''
end
json.layouts do
  json.small_layout do
    json.size "small"
    json.styles do
      json.colours do
        json.background_colour do
          json.color "#00000066"
        end
      end
    end
    json.layers do
      json.child! do
        json.rows do
          json.child! do
            json.height 12
            json.cells do
              json.child! do
                json.width 12
                json.image do
                  json.data_ref "wallpaper"
                end
              end
            end
          end
        end
      end
    end
  end
  json.large_layout do
    json.size "large"
    json.styles do
      json.colours do
        json.background_colour do
          json.color "#00000066"
        end
      end
    end
    json.layers do
      json.child! do
        json.rows do
          json.child! do
            json.height 12
            json.cells do
              json.child! do
                json.width 12
                json.image do
                  json.data_ref "wallpaper"
                end
              end
            end
          end
        end
      end
      if @set_by.present?
        json.child! do
          json.rows do
            json.child! do
              json.height 10
            end
            json.child! do
              json.height 2
              json.cells do
                json.child! do
                  json.width 12
                  json.background_color_style "background_colour"
                  json.padding 0.5
                  json.text do
                    json.string "From: #{@set_by.username}"
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
