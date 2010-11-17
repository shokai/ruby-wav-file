#!/usr/bin/env ruby
require 'rubygems'
require 'wav-file'

if ARGV.size < 1
  puts 'ruby readWav.rb input.wav'
  exit 1
end

File.open(ARGV[0]){|file|
  format = WavFile::readFormat(file)
  puts format
}
