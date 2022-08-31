#
# To test latency on writing large chunks of data in one go
#

$: << "../lib"

require 'benchmark'
require 'file_writer'

data = " " * (16_777_216*100 + 42)
t1 = Thread.new do
  loop do
    FileWriter.write("./test", data)
  end
end

accum = []
t2 = Thread.new do
  loop do
    b = Benchmark.measure do
      100000.times do
        " "*1024
      end
    end
    accum << b.total
    break if accum.length > 1000
  end

  p accum.sum / accum.size
end

t1.join
t2.join
