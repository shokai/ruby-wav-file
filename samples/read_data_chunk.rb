#!/usr/bin/env ruby
# wav file has multiple chunks.
# using WavFile::readDataChunk, you can find data chunk from chunks
require 'rubygems'
require 'wav-file'

if ARGV.size < 1
  puts 'ruby read_data_chunk.rb input.wav'
  exit 1
end

File.open(ARGV[0]){|file|
  format = WavFile::readFormat(file)
  puts format.to_s

  dataChunk = WavFile::readDataChunk(file)
  puts "#{dataChunk.name} #{dataChunk.size}"
}
