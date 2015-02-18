module Ocr

  class Image
    attr :width
    attr :height
    attr :max
    attr :data

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

      @data = content[offset ... -1].unpack('C*')
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
      raise "Invalid y" if (y < 0 or y >= @height)
      first = y * @width
      last  = (1 + y) * @width - 1
      @data[first .. last].map {|c| c.ord}
    end

    def vert_scanline(x)
      raise "Invalid x" if (x < 0 or x >= @width)
      (0 ... @height).map {|y| @data[x + y * @width].ord }
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
      f << "P5\n#{@width} #{@height}\n#{@max}\n#{@data.pack('C*')}\0"
      f.close
    end

    private

    def scan(bytes, pos, delim)
      first, last = pos, pos
      while bytes[last] != delim
        last += 1
      end
      return bytes[first..last].strip, last + 1
    end
  end

end