#!/usr/bin/ruby

require 'date'
require 'json'

raise "No quota given!" unless ARGV.length == 1

QUOTA_BYTES = 100*1e9
SECS_IN_DAY = 24 * 60 * 60

quota_remain_string = ARGV[0]

matched = quota_remain_string.match(/(\d+\.\d+)(\w+)/)

MULT = { 'gb' => 1e9, 'mb' => 1e6, 'kb' => 1e3, 'b' => 1}
bytes_remain = matched[1].to_f * MULT[matched[2].downcase]

today = Date.today

month_start = Date.new(today.year, today.month)

next_month = today.month + 1
next_months_year = today.year
if next_month > 12
  next_month -= 12
  next_months_year += 1
end

next_month_start = Date.new(next_months_year, next_month)

used_bytes = QUOTA_BYTES - bytes_remain

now = Time.now.to_i
secs_elapsed = now - month_start.to_time.to_i
secs_remain  = next_month_start.to_time.to_i - now

percent_time_elapsed = 100.0 * secs_elapsed / (1.0 * secs_elapsed + secs_remain)
percent_quota_used = 100.0 * used_bytes / QUOTA_BYTES
projected_time_quota_expires = now + (bytes_remain / used_bytes) * secs_elapsed

status_color = ''
if percent_quota_used < percent_time_elapsed
  status_color = 'GREEN'
elsif percent_quota_used < 1.1 * percent_time_elapsed
  status_color = 'YELLOW'
else 
  status_color = 'RED'
end

message = "#{status_color}: quota up at #{Time.at(projected_time_quota_expires)} (#{quota_remain_string} remain)"

result = {
  :timestamp => now,
  :status => status_color,
  :message => message,
  :percent_time_elapsed => percent_time_elapsed,
  :percent_quota_used => percent_quota_used,
  :bytes_used => used_bytes.to_i,
  :bytes_remain => bytes_remain.to_i
}

puts JSON.generate(result)