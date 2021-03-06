require './lib/ocr/image'
require './lib/ocr/split'
require './lib/ocr/tight_crop'

KNOWN_CHARS = {
  # Green background
  'OGYzOGU5N2FlZGFhYzZmMzY2OTU1NzM5NGQwNWNlYWQxNGFmOTgwYQ==' => '0',
  'ZDg0YjJkN2I2N2Q4ZWU3NzRiZDhiNjdmYjI2YWExOGIzYjJlMmUwNQ==' => '1',
  'NWQ1MjFjMTUyNWJjZDhlYjU3MzMyYzMxNWFiYjM3N2ZmYWYxZWZhZg==' => '2',
  'MDkwODNjNjQ1NTFmMjBkZWY1NzQzMTNmNzVkYmM3NmIyNmZiZTVlMA==' => '3',
  'NDFkNTg4NzBkMzM2YWVkOTA2NzMxMzM5YWFhNDU1ZjhmZjQyZGFjMw==' => '4',
  'YWM3MDgyOGZkN2UzOTM0YWIwODQ5MGJhMTIwZmY0MTc5MWJiMjc4Yg==' => '5',
  'ZGIxOGVlOWI0MWY0NzFlNDQ3YWQyMDI2OGIzNmFjN2IxNGI2OGI1OQ==' => '6',
  'ZmM0YTVmYzcwMDQ5M2RkMjRiNTRiN2Y4OGFiNDY2OTk4MzE2MTY4MA==' => '7',
  'MzI5Mjc4MGRiNzZmYmIzY2E5NWM0MzQ3NzVhYjI4MGE5ZTIwOWUzNQ==' => '8',
  'OTYxYjg1ZjVmZTFhYTVlOTUxM2VmNDRhOTg3NTBkNGJkNjNiYjNlNg==' => '9',
  'MDI1YmZmYzg2YzY1ZTc3ODRiOTMwMGY4NGY1ZDc0Mjg5YTI2NDE0Zg==' => '.',
  'MmMzYWVlNTgxZTk3MGM4Y2NmZWU4MTJjY2Q5OGM5ODcxZDE2MzdkYQ==' => 'G',
  'NjI2YzEwZDRjYTg4MmJkOWZkZDhlZDU0MjRlYjkyNzU5MWMyZjliYw==' => 'B',
  # Orange background
  'YTM2OTBhOTI3YzUzNmMwNzRlZmZjMWEyMjE2MDhjNWI2YmEwOGM5ZQ==' => '0',
  'Y2E0NjYwZDljNjhlMTU0MjM4ZDYyMWI1NDc0ZTM1ZTZmYmFiYjcwNA==' => '1',
  'YmRlNWRkOTA1ZGJhYWMyYzE0YmQzMzQxM2MxZDAzOTVlMzExZDhkOQ==' => '2',
  'MGI5MWYwNTI0MmM3NTFhZGUxMjhmNTFjOGYwMTg1ZGY1ZDgxODAyNA==' => '3',
  'NjdhMTU1YTc3OGNmMTE1YWYxZDZkODFkMWVhOWU5YzZlZmE0OGYzOA==' => '4',
  'ZTI0ZDVhM2M5NjFiZWJiNjYyODBkOTMyNjQ4YzI0Yjg1ZmM4NDc0Ng==' => '5',
  'MjU4MzA5MDk5YjNlNzM2YjQ2YzhhNDgxMTYyNWYyZjEyZTIzNGNmNQ==' => '6',
  'YWQ3MmE5YTVhMTk4NWY3MWQ4MDEwMjU2Y2FmNDkwMmM4MTEwZjI0YQ==' => '7',
  'YjUxOWY2ZGU4NDQ4NmYxYjhkNTU4MzQ0NDhmMTU1OTE0OTAyOTJkYQ==' => '8',
  'NzY4MWM0YjI4YzA4MjljZDNiMTkxYzBkZjdiMDEzMDY0Nzg4NzJhZA==' => '9',  
  'ODQ2ZDMzODdlMjUwOTRmNGVjYmJhNDZhMzQ4NDg3ODM2MGUwMWFiNQ==' => 'M',
  # Other background (red?)
  'ZGYwNzc1ZjZiMGEzNWUyYjczODk3MWUzNDBmNWE2ZmRjODBmZDIzNg==' => '9'
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
