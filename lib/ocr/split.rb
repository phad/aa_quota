require './lib/ocr/image'
require './lib/ocr/tight_crop'

module Ocr

  module Split

    class << self

      def split image
        image.posterize(250)
        bbox = TightCrop::bounding_box(image, 255)
        cropped = image.crop(bbox)

        splits = []
        prev_state = false
        x_min = nil
        TightCrop::horiz_slice(cropped, 255).each_with_index do |state, index|
          if state != prev_state
            # F -> T : entering left bound of new image
            # T -> F : exited right bound of image
            if state
              x_min = index 
            end
            if not state
              x_max = index
              bbox = {:x_min => x_min, :x_max => x_max,
                      :y_min => 0, :y_max => cropped.height}
              splits << cropped.crop(bbox)
            end
            prev_state = state
          end
        end
        bbox = {:x_min => x_min, :x_max => cropped.width,
                :y_min => 0, :y_max => cropped.height}
        splits << cropped.crop(bbox)
        splits
      end
        
    end

  end

end
