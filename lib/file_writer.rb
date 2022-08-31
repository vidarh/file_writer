require "file_writer/version"
require "fileutils"

#
# Overwrite files safely
#
class FileWriter
  # The filename of the file to overwrite
  attr_reader :fname

  # Create new FileWriter
  #
  # @param String fname The name of he file to overwrite
  def initialize(fname)
    @fname = fname
  end

  SPLIT_SIZE = 65536

  # Overwrite the file
  #
  # @param String contents The new contents for the file.
  #
  def write(contents)
    backup = fname + "~"

    existing = File.exists?(fname)

    if existing
      fmode   = File.stat(fname).mode
      begin
        File.rename(fname, backup)
      rescue SystemCallError
        FileUtils.cp(fname,fname+"~")
      end
    else
      fmode = nil
    end

    File.open(fname, "wb+", fmode) do |f|
      size    = contents.bytesize

      #
      #We do this rather than f.write or f.syswrite as it
      # gives substantially better latency in a threaded
      # environment as of MRI 2.7.2 than a single write,
      # at the cost of throughput
      #
      # See tests/latency.rb for a test case, and try
      # replacing the below with
      #
      # ```
      #     written = File.write(contents)
      # ```
      #
      written = 0
      while (size - written) > SPLIT_SIZE
        if (w = f.write(contents[written .. (written+SPLIT_SIZE-1)])) != SPLIT_SIZE
          raise SystemCallError.new("FileWriter#write: write returned unexpected length (#{w.inspect})")
        end
        written += w
      end
      written += f.write(contents[written .. -1])

      if written != size
        raise SystemCallError.new("FileWriter#write: write returned unexpected length")
      end
      f.flush
      f.fsync
    end
  end

  # Overwrite the file
  #
  # @param String fname The name of the file to overwrite
  # @param String contents The new contents for the file.
  #
  def self.write(fname, contents)
    FileWriter.new(fname).write(contents)
  end
end
