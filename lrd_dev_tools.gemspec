Gem::Specification.new do |s|
  s.name = %q{lrd_dev_tools}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Evan Dorn"]
  s.date = %q{2011-10-16}
  s.summary = %q{Development tools for LRD projects.}
  s.description = %q{Compatible with Rails 3.1.   Most of this probably
    won't work with Rails 2.'
  }
  s.add_dependency('mizugumo', '>= 0.2.0')
  s.email = %q{evan@lrdesign.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README"
  ]
  s.files = [
    "LICENSE.txt",
    "README"
  ]
  s.files		+= Dir.glob("lib/**/*")
  s.files		+= Dir.glob("bin/**/*")
  # s.files   += Dir.glob("doc/**/*")
  # s.files   += Dir.glob("spec/**/*")

  s.bindir = 'bin'
  s.executables = [ 'lrd_template' ]

  s.homepage = %q{http://LRDesign.com}
  s.licenses = ["proprietary"]
  s.require_paths = ["lib/"]
  s.rubygems_version = %q{1.3.5}

end

