require 'pathname'
require 'singleton'

class Sass::Globbing::Importer < Sass::Importers::Filesystem

  include Singleton

  GLOB = /\*/

  SASS_EXTENSIONS = {
    ".sass" => :sass,
    ".scss" => :scss
  }

  def initialize
    super(".")
  end

  def sass_file?(filename)
    SASS_EXTENSIONS.has_key?(File.extname(filename.to_s))
  end
  
  def syntax(filename)
    SASS_EXTENSIONS[File.extname(filename.to_s)]
  end
  
  def find_relative(name, base, options)
    if name =~ GLOB
      contents = ""
      base_pathname = Pathname.new(base)
      each_globbed_file(name, base_pathname, options) do |filename|
        contents << "@import #{Pathname.new(filename).relative_path_from(base_pathname.dirname).to_s.inspect};\n"
      end
      return nil if contents.empty?
      Sass::Engine.new(contents, options.merge(
        :filename => base_pathname.to_s,
        :importer => self,
        :syntax => :scss
      ))
    else
      super
    end
  end
  
  def find(name, options)
    if options[:filename] # globs must be relative
      find_relative(name, options[:filename], options)
    end
  end
  
  def each_globbed_file(glob, base_pathname, options)
    Dir["#{base_pathname.dirname}/#{glob}"].sort.each do |filename|
      next if filename == options[:filename]
      yield filename if sass_file?(filename)
    end
  end
  
  def mtime(name, options)
    if name =~ GLOB && options[:filename]
      mtime = nil
      each_globbed_file(name, Pathname.new(options[:filename]), options) do |p|
        if mtime.nil?
          mtime = File.mtime(p)
        else
          mtime = [mtime, File.mtime(p)].max
        end
      end
      mtime
    end
  end
  
  def key(name, options)
    ["Glob:" + File.dirname(File.expand_path(name)), File.basename(name)]
  end
  
  def to_s
    "Sass::Globbing::Importer"
  end
  
end