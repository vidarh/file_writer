$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "file_writer"

def filewriter_tmpname
  t = Time.now.strftime("%Y%m%d")
  "/tmp/filewriter-tests-#{t}-#{$$}-#{rand(0x100000000).to_s(36)}"
end
