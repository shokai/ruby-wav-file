#!/usr/bin/env ruby
# read and write
require 'rubygems'
require 'wav-file'

if ARGV.size < 2
  puts 'ruby copy_wav.rb input.wav output.wav'
  exit 1
end

f = open(ARGV.shift)
format, chunks = WavFile::readAll(f)
f.close

puts format.to_s
chunks.each{|c|
  puts "#{c.name} #{c.size}"
}

open(ARGV.shift, "w"){|out|
  WavFile::write(out, format, chunks)
}
