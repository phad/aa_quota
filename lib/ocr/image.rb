require "base64"
require 'digest/sha1'

module Ocr

  class Image
    attr :width
    attr :height
    attr :max
    attr :data

    def initialize
      @width = 0
      @height = 0
      @max = 0
      @data = []
    end

    def initialize(width = 0, height = 0, max = 0, data = [])
      @width = width
      @height = height
      @max = max
      @data = data
    end

    def assert(condition, &block)
      unless condition
        yield if block
        exit!
      end
    end

    def read_pgm(filename)
      content = File.read(filename)
      offset = 0

      line, offset = scan(content, offset, "\n")
      if line != 'P5'
        raise "Not a PGM file"
      end

      line, offset = scan(content, offset, "\n")
      dims = line.split(' ')
      @width, @height = dims.first.to_i, dims.last.to_i

      line, offset = scan(content, offset, "\n")
      @max = line.to_i

      @data = content[offset .. -1].unpack('C*')
      nil
    end

    def to_s
      "w:#{@width} h:#{height} max:#{@max} data:#{@data.size}b"
    end

    def point(x, y)
      raise "Invalid x" if (x < 0 or x >= @width)
      raise "Invalid y" if (y < 0 or y >= @height)
      @data[x + y * @width].ord
    end

    def horiz_scanline(y)
      raise "Invalid y: #{y}" if (y < 0 or y >= @height)
      first = y * @width
      last  = (1 + y) * @width - 1
      scanline = @data[first .. last].map {|c| c.ord}
      assert(scanline.length == @width) { p "scanline not #{@width} px wide" }
      scanline
    end

    def vert_scanline(x)
      raise "Invalid x: #{x}" if (x < 0 or x >= @width)
      scanline = (0 ... @height).map {|y| @data[x + y * @width].ord }
      assert(scanline.length == @height) { p "scanline not #{@height} px high" }
      scanline
    end

    def invert
      m = 0
      d = @data.map do |b|
        c = 255 - b
        m = [c, m].max
        c
      end
      @data, @max = d, m
      nil
    end

    def crop(bbox)
      raise "Invalid x_min: #{bbox} #{self}" if bbox[:x_min] < 0 or bbox[:x_min] >= bbox[:x_max] or bbox[:x_min] > @width
      raise "Invalid x_max: #{bbox} #{self}" if bbox[:x_max] < 0 or bbox[:x_max] > @width
      raise "Invalid y_min: #{bbox} #{self}" if bbox[:y_min] < 0 or bbox[:y_min] >= bbox[:y_max] or bbox[:y_min] > @height
      raise "Invalid y_max: #{bbox} #{self}" if bbox[:y_max] < 0 or bbox[:y_max] > @height

      new_width  = bbox[:x_max] - bbox[:x_min]
      new_height = bbox[:y_max] - bbox[:y_min]
      new_max = 0
      new_data = []
      (bbox[:y_min] ... bbox[:y_max]).each do |y|
        segment = horiz_scanline(y)[bbox[:x_min], new_width]
        new_max = [new_max, segment.max].max
        new_data.concat segment
      end
      Image.new(new_width, new_height, new_max, new_data)
    end

    def posterize(threshold)
      m = 0
      d = @data.map do |b|
        c = ((b >= threshold) ? 255 : 0)
        m = [c, m].max
        c
      end
      @data, @max = d, m
      nil
    end

    def write(filename)
      f = File.open(filename, 'w')
      f << content
      f.close
    end

    def fingerprint
      Base64.encode64(Digest::SHA1.hexdigest(content))
    end

    private

    def content
      "P5\n#{@width} #{@height}\n#{@max}\n#{@data.pack('C*')}\0"
    end

    def scan(bytes, pos, delim)
      first, last = pos, pos
      while bytes[last] != delim
        last += 1
      end
      return bytes[first..last].strip, last + 1
    end
  end

end