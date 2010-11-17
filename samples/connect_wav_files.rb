#!/usr/bin/env ruby
# connect files
require 'rubygems'
require 'wav-file'

if ARGV.size < 3
  puts 'ruby connect_wav_files.rb input1.wav input2.wav output.wav'
  exit 1
end

out_file = ARGV.pop

formats = ARGV.uniq.map{|file_name|
  WavFile::readFormat open(file_name)
}
for i in 0..formats.size-2 do
  if formats[i] != formats[i+1]
    puts 'different format!'
    exit 1
  end
end

format = formats.first
dataChunk = WavFile::readDataChunk(open(ARGV.shift))

ARGV.each{|f|
  data = WavFile::readDataChunk(open(f))
  dataChunk.data += data.data
}

puts format

open(out_file, "w"){|out|
  WavFile::write(out, format, [dataChunk])
}
