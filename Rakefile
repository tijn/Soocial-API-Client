require 'rake'
require 'rake/gempackagetask'
# require 'rake/testtask'
require 'rake/rdoctask'


def flog(output, *directories)
  system("find #{directories.join(" ")} -name \\*.rb | xargs flog")
end

desc "Analyze code complexity."
task :flog do
  flog "lib", "lib"
end

desc "rdoc"
Rake::RDocTask.new('rdoc') do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = 'Soocial API Client'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include("lib/**/*.rb", 'README')
  rdoc.main = 'README'
end


gem_spec = Gem::Specification.new do |s|
  s.name = %q{soocial-api-client}
  s.version = "0.1.0"
  s.date = %q{2010-06-29}
  s.authors = ["Tijn Schuurmans"]
  s.email = %q{tijn@soocial.com}
  s.summary = %q{Soocial API client libraries.}
  s.description = %q{Provides a nice API to read and modify contacts data on Soocial.com.}
  s.add_dependency('oauth',  '>= 0.3.6')
  s.files = FileList.new do |fl|
    fl.include("{lib,examples}/**/*")
    fl.include("README")
  end
end

Rake::GemPackageTask.new(gem_spec) do |pkg|
  pkg.need_tar_bz2 = true
  pkg.need_zip = true
  pkg.need_tar = true
end
