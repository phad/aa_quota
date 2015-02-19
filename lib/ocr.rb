require './lib/ocr/image'
require './lib/ocr/split'
require './lib/ocr/tight_crop'

KNOWN_CHARS = {
  'OGYzOGU5N2FlZGFhYzZmMzY2OTU1NzM5NGQwNWNlYWQxNGFmOTgwYQ==' => '0',
  'ZDg0YjJkN2I2N2Q4ZWU3NzRiZDhiNjdmYjI2YWExOGIzYjJlMmUwNQ==' => '1',
  'NWQ1MjFjMTUyNWJjZDhlYjU3MzMyYzMxNWFiYjM3N2ZmYWYxZWZhZg==' => '2',
  'MDkwODNjNjQ1NTFmMjBkZWY1NzQzMTNmNzVkYmM3NmIyNmZiZTVlMA==' => '3',
  'NDFkNTg4NzBkMzM2YWVkOTA2NzMxMzM5YWFhNDU1ZjhmZjQyZGFjMw==' => '4',
  'unknown5' => '5',
  'ZGIxOGVlOWI0MWY0NzFlNDQ3YWQyMDI2OGIzNmFjN2IxNGI2OGI1OQ==' => '6',
  'unknown7' => '7',
  'MzI5Mjc4MGRiNzZmYmIzY2E5NWM0MzQ3NzVhYjI4MGE5ZTIwOWUzNQ==' => '8',
  'OTYxYjg1ZjVmZTFhYTVlOTUxM2VmNDRhOTg3NTBkNGJkNjNiYjNlNg==' => '9',
  'MDI1YmZmYzg2YzY1ZTc3ODRiOTMwMGY4NGY1ZDc0Mjg5YTI2NDE0Zg==' => '.',
  'MmMzYWVlNTgxZTk3MGM4Y2NmZWU4MTJjY2Q5OGM5ODcxZDE2MzdkYQ==' => 'G',
  'NjI2YzEwZDRjYTg4MmJkOWZkZDhlZDU0MjRlYjkyNzU5MWMyZjliYw==' => 'B'
}

i = Ocr::Image.new
i.read_pgm(ARGV[0])

splits = Ocr::Split::split(i)

quota = splits.each_with_index.map do |j, idx|
  fp = j.fingerprint.strip
  c = KNOWN_CHARS[fp]
  if c.nil?
    puts "Unrecognized char with fingerprint: #{fp}"
    j.write("image-#{fp}.pgm")
  end
  c
end.join

puts quota
