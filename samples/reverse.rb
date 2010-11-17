#!/usr/bin/env ruby
# reverse wav file

require 'rubygems'
require 'wav-file'

if ARGV.size < 2
  puts 'ruby reverse.rb input.rb output.wav'
  exit 1
end

f = open(ARGV.shift)
format = WavFile::readFormat(f)
dataChunk = WavFile::readDataChunk(f)
f.close

puts format

if dataChunk == nil
  puts 'no data chunk'
  exit 1
end

bit = 's*' if format.bitPerSample == 16 # int16_t
bit = 'c*' if format.bitPerSample == 8 # signed char
wavs = dataChunk.data.unpack(bit) # read binary
dataChunk.data = wavs.reverse.pack(bit) # reverse

open(ARGV.shift, "w"){|out|
  WavFile::write(out, format, [dataChunk])
}

