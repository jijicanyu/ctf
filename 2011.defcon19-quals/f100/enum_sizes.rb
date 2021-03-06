#!/usr/bin/env ruby
require 'zlib'

data = File.read(ARGV[0])

data.force_encoding('ascii-8bit')

def put data, start, value
  data[start+0] = (value>>24).chr
  data[start+1] = ((value>>16)&0xff).chr
  data[start+2] = ((value>>8)&0xff).chr
  data[start+3] = (value&0xff).chr
end

fnames = []

2.upto(19024) do |width|
#width = ARGV[1].to_i
  height = 19025 / width


  put data, 0x10, width
  put data, 0x14, height

  crc = Zlib::crc32(data[0x0c,0x0d+4])

  p data[0x1d,4]

  put data, 0x1d, crc

  p data[0x1d,4]

  fname = "#{width}x#{height}.png"
  fnames << fname
  File.open("f100/#{fname}",'w') do |f|
    f << data
  end

end

File.open("f100/index.html","w") do |f|
  f << fnames.map{ |f| "<img src='#{f}'></img><br/>" }.join
end
