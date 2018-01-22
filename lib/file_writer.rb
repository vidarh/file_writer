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

  # Overwrite the file
  #
  # @param String contents The new contents for the file.
  #
  def write(contents)
    backup = fname + "~"

    existing = File.exists?(fname)

    if existing
      mode   = File.stat(fname).mode
      begin
        File.rename(fname, backup)
      rescue SystemCallError
        FileUtils.cp(fname,fname+"~")
      end
    else
      mode = nil
    end

    File.open(fname, "wb+", mode) do |f|
      if f.syswrite(contents) != contents.bytesize
        raise SystemCallError.new("FileWriter#write: syswrite returned unexpected length")
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
