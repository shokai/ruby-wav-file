#!/usr/bin/env ruby
# compare formats
require 'rubygems'
require 'wav-file'

if ARGV.size < 2
  puts 'ruby compare_formats.rb input1.wav input2.wav'
  exit 1
end

formats = ARGV.map{|file_name|
  format = WavFile::readFormat open(file_name)
  puts format.to_s
  puts '==='
  format
}

if formats[0] == formats[1]
  puts 'same format'
else
  puts 'different format'
end


