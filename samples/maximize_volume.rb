#!/usr/bin/env ruby
# maximize volume
require 'rubygems'
require 'wav-file'

if ARGV.size < 2
  puts 'ruby maximize_volume.rb input.wav output.wav'
  exit 1
end

in_file = ARGV.shift
out_file = ARGV.shift

format, data = WavFile::read open(in_file)

puts format.to_s

bit = 's*' if format.bitPerSample == 16 # int16_t
bit = 'c*' if format.bitPerSample == 8 # signed char
wavs = data.data.unpack(bit)

puts "max of this file: #{wavs.max}"

volume_ratio = 32768/wavs.max.to_f if format.bitPerSample == 16
volume_ratio = 128/wavs.max.to_f if format.bitPerSample == 8
puts "maximize ratio: #{volume_ratio}"

wavs_fixed = wavs.map{|w|
  (w*volume_ratio).to_i
}
puts "maximized: #{wavs_fixed.max}"

data.data = wavs_fixed.pack(bit)

open(out_file, "w"){|out|
  WavFile::write(out, format, [data])
}
