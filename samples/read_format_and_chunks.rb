#!/usr/bin/env ruby
require 'rubygems'
require 'wav-file'

if ARGV.size < 1
  puts 'ruby read_format_and_chanks.rb input.wav'
  exit 1
end

File.open(ARGV.first){|file|
  format, chunks = WavFile::readAll(file)
  puts format.to_s
  chunks.each{|c|
    puts "chunk - #{c.name} #{c.size}"
  }
}
