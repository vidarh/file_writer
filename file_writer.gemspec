# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'file_writer/version'

Gem::Specification.new do |spec|
  spec.name          = "file_writer"
  spec.version       = FileWriter::VERSION
  spec.authors       = ["Vidar Hokstad"]
  spec.email         = ["vidar@hokstad.com"]

  spec.summary       = "Overwrite/replace files in a safe way with backups"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/vidarh/file_writer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
