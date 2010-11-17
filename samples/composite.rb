#!/usr/bin/env ruby
# composite wav files
require 'rubygems'
require 'wav-file'

if ARGV.size < 4
  puts 'e.g. ruby composite.rb base.wav input1.wav 1 3 10 out.wav'
  puts '     => put "input1.wav" on 1,3,10(sec)'
  exit 1
end

out_file = ARGV.pop
base_file = ARGV.shift
input_file =ARGV.shift
times = ARGV.map{|i|i.to_f}.uniq.sort


format1, data1 = WavFile::read open(base_file)
format2, data2 = WavFile::read open(input_file)

puts format1.to_s
if format1 != format2
  puts 'file formats are different!'
  puts format2.to_s
  exit 1
end


bit = 's*' if format1.bitPerSample == 16 # int16_t
bit = 'c*' if format1.bitPerSample == 8 # signed char
wavs1 = data1.data.unpack(bit)
wavs2 = data2.data.unpack(bit)

times.each{|t|
  offset = format1.hz * t * format1.channel
  next if offset+wavs2.size > wavs1.size
  print "#{t}(sec)..."
  for i in 0..wavs2.size-1 do
    wav1 = wavs1[i+offset]
    wav2 = wavs2[i] * 0.3 # volume down
    wavs1[i+offset] = ((wav1+wav2)/2).to_i
  end
  puts ''
}

data1.data = wavs1.pack(bit)

open(out_file, "w"){|out|
  WavFile::write(out, format1, [data1])
}
