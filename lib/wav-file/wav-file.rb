# -*- coding: utf-8 -*-
module WavFile

  class WavFormatError < StandardError
  end

  class Chunk
    attr_accessor(:name, :size, :data)

    def initialize(file)
      @name = file.read(4)
      @size = file.read(4).unpack("V")[0].to_i
      @data = file.read(@size)
    end

    def to_bin
      @name + [@data.size].pack('V') + @data
    end
  end

  class Format
    attr_accessor(:id, :channel, :hz, :bytePerSec, :blockSize, :bitPerSample)
    
    def initialize(chunk)
      return if chunk.class != Chunk
      return if chunk.name != 'fmt '
      @id = chunk.data.slice(0,2).unpack('c')[0]
      @channel = chunk.data.slice(2,2).unpack('c')[0]
      @hz = chunk.data.slice(4,4).unpack('V').join.to_i
      @bytePerSec = chunk.data.slice(8,4).unpack('V').join.to_i
      @blockSize = chunk.data.slice(12,2).unpack('c')[0]
      @bitPerSample = chunk.data.slice(14,2).unpack('c')[0]
    end

    def to_s
      <<EOS
Format ID:      #{@id}
Channels:       #{@channel}
Sampling Ratio: #{@hz} (Hz)
Byte per Sec:   #{@bytePerSec}
Bit per Sample: #{@bitPerSample} 
Block Size:     #{blockSize}
EOS
    end

    def to_bin
      [@id].pack('v')+
        [@channel].pack('v') +
        [@hz].pack('V') +
        [@bytePerSec].pack('V') +
        [@blockSize].pack('v') +
        [@bitPerSample].pack('v')
    end

    def ==(target)
      @id == target.id && 
        @channel == target.channel &&
        @hz == target.hz &&
        @bytePerSec == target.bytePerSec &&
        @bitPerSample == target.bitPerSample &&
        @blockSize == target.blockSize
    end

  end

  def WavFile.readFormat(f)
    f.binmode
    f.seek(0)
    header = f.read(12)
    riff = header.slice(0,4)
    data_size = header.slice(4,4).unpack('V')[0].to_i
    wave = header.slice(8,4)
    raise(WavFormatError) if riff != 'RIFF' or wave != 'WAVE'
    
    formatChunk = Chunk.new(f)
    formatChunk = Chunk.new(f) if formatChunk.name == "JUNK"
    Format.new(formatChunk)
  end

  def WavFile.readAll(f)
    format = readFormat(f)
    chunks = Array.new
    while !f.eof?
      chunk = Chunk.new(f)
      chunks << chunk
    end
    return format, chunks
  end

  def WavFile.readDataChunk(f)
    format, chunks = readAll(f)
    chunks.each{|c|
      return c if c.name == 'data'
    }
    return nil
  end

  def WavFile.read(f)
    return readFormat(f), readDataChunk(f)
  end

  def WavFile.write(f, format, dataChunks)
    header_file_size = 4
    dataChunks.each{|c|
      header_file_size += c.data.size + 8
    }
    f.write('RIFF' + [header_file_size].pack('V') + 'WAVE')
    f.write("fmt ")
    f.write([format.to_bin.size].pack('V'))
    f.write(format.to_bin)
    dataChunks.each{|c|
      f.write(c.to_bin)
    }
  end

end
