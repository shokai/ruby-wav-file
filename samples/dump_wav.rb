#!/usr/bin/env ruby
# using this script and Excel, you can make a graph.
# => http://www.flickr.com/photos/shokai/4081858478/sizes/o/

require 'rubygems'
require 'wav-file'

if ARGV.size < 2
  puts 'ruby dump_wav.rb input.wav dump.txt'
  exit 1
end

format = nil
dataChunk = nil
File.open(ARGV[0]){|file|
  format, chunks = WavFile::readAll(file)
  puts format.to_s
  chunks.each{|c|
    puts "chunk - #{c.name} #{c.size}"
    dataChunk = c if c.name == 'data'
  }
}

bit = 's*' if format.bitPerSample == 16 # int16_t
bit = 'c*' if format.bitPerSample == 8 # signed char
wavs = dataChunk.data.unpack(bit) # read binary

open(ARGV[1],'w'){|dump|
  wavs.each{|i|
    dump.puts i
    puts i
  }
}
puts wavs.size

