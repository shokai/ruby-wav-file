#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# split left/right channels.
require 'rubygems'
require 'wav-file'

if ARGV.size < 2
  puts 'e.g. ruby splitChannelWav.rb input.rb output_left.wav output_right.wav'
  puts '    => make 2 wav files'
  exit 1
end

f = open(ARGV.shift)
format, chunks = WavFile::readAll(f)
f.close

puts format.to_s

dataChunk = nil
chunks.each{|c|
  puts "#{c.name} #{c.size}"
  dataChunk = c if c.name == 'data' # find data chank
}
if dataChunk == nil
  puts 'no data chunk'
  exit 1
end

bit = 's*' if format.bitPerSample == 16 # int16_t
bit = 'c*' if format.bitPerSample == 8 # signed char
wavs = dataChunk.data.unpack(bit) # read binary

off = 32768 if format.bitPerSample == 16
off = 128 if format.bitPerSample == 8

for i in 0..1 do # LR
  wavs_mono = wavs.dup
  for j in 0..wavs_mono.size-1 do
    if j%2 != i
      wavs_mono[j] = off # LRLRLR..
    end
  end
  dataChunk.data = wavs_mono.pack(bit)
  open(ARGV.shift, "w"){|out|
    WavFile::write(out, format, [dataChunk])
  }
end
