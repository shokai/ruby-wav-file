#!/usr/bin/env ruby
# adjust same format using ffmpeg

require 'rubygems'
require 'wav-file'

if ARGV.size < 2
  puts 'ruby base.wav input1.wav [..input2.wav]'
  exit 1
end

base_file = ARGV.shift

base_format = WavFile::readFormat open(base_file)
puts base_format

ARGV.each{|f|
  format = WavFile::readFormat open(f)
  if format != base_format
    puts `ffmpeg -i #{f} -ac #{base_format.channel} -ar #{base_format.hz} fixed_#{f}`
  else
    puts "#{f} is ok"
  end
}
