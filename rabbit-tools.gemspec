# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rabbit-tools}
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stefan Saasen"]
  s.date = %q{2009-10-07}
  s.default_executable = %q{rabbitstatus}
  s.email = %q{s@juretta.com}
  s.executables = ["rabbitstatus"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    "lib/rabbit-tools.rb",
     "lib/rabbit-tools/helper.rb",
     "lib/rabbit-tools/status.rb"
  ]
  s.homepage = %q{http://github.com/juretta/rabbit-tools}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{RabbitMQ tools}
  s.test_files = [
    "test/rabbit-tools_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<visionmedia-terminal-table>, [">= 0"])
    else
      s.add_dependency(%q<visionmedia-terminal-table>, [">= 0"])
    end
  else
    s.add_dependency(%q<visionmedia-terminal-table>, [">= 0"])
  end
end