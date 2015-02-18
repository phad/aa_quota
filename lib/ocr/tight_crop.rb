require './lib/ocr/image'

module Ocr

  module TightCrop

    class << self
      def bounding_box(image, threshold)
        vslice = vert_slice(image, threshold)
        keep = vslice.each_with_index.select{|state, _| state}
        y_min = keep.first.nil? ? 0 : keep.first.last
        y_max = keep.last.nil?  ? image.width : keep.last.last

        hslice = horiz_slice(image, threshold)
        keep = hslice.each_with_index.select{|state, _| state}
        x_min = keep.first.nil? ? 0 : keep.first.last
        x_max = keep.last.nil?  ? image.width : keep.last.last
        {:x_min => x_min, :x_max => x_max, :y_min => y_min, :y_max => y_max }
      end

      def vert_slice(image, threshold)
        (0 ... image.height).map do |y|
          scanline = image.horiz_scanline(y)
          scanline.any? {|p| p >= threshold}
        end
      end

      def horiz_slice(image, threshold)
        (0 ... image.width).map do |x|
          scanline = image.vert_scanline(x)
          scanline.any? {|p| p >= threshold}
        end
      end
    end

  end

end