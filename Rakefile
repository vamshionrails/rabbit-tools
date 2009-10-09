require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = gem.rubyforge_project = "rabbit-tools" # http://rabbit-tools.rubyforge.org/
    gem.summary = %Q{RabbitMQ tools}
    gem.description = "Command line tools for the RabbitMQ message broker."
    gem.email = "s@juretta.com"
    gem.homepage = "http://github.com/juretta/rabbit-tools"
    gem.authors = ["Stefan Saasen"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    gem.bindir = 'bin'
    gem.executables = ['rabbitstatus']
    gem.add_dependency('visionmedia-terminal-table', '>=1.2.0')
    gem.add_dependency('popen4', '>=0.1.2')
    gem.files = FileList["[A-Z]*.*", "{bin,generators,lib,test,spec}/**/*"].exclude("rdoc").to_a.flatten
    gem.extra_rdoc_files = ["README.md"]
  end

  # Gemcutter support (Jeweler -> 1.2.1)
  Jeweler::GemcutterTasks.new
  Jeweler::RubyforgeTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end


task :inject_version do 
  if File.exist?('VERSION')
    major, minor, patch = File.read('VERSION').split("\.")
    version = "#{major}.#{minor}.#{patch}".strip
    file = 'lib/rabbit-tools.rb'
    lines = IO.readlines(file).join
    
    r = /(VERSION = "([^\"]+)")/
    current = nil
    if lines =~ r
      current = $2.dup
    end

    if current && !version.eql?(current)
      File.open(file, 'w') do |f|
        f << lines.gsub(r) do |match|
          "VERSION = \"#{version}\""
        end
      end
      `git add #{file}`
      `git commit -m 'Injected version information (#{version})'`
    end
  end
end

task :build => [:inject_version]
task :release => [:inject_version]
task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rabbit-tools #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

