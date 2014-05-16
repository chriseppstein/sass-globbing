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
      find_glob(name, base, options) { nil }
    else
      super(name, base, options)
    end
  end
  
  def find(name, options)
    if options[:filename] # globs must be relative
      if name =~ GLOB
        find_glob(name, options[:filename], options) { "/* No files to import found in #{comment_safe(name)} */" }
      else
        super(name, options)
      end
    else
      nil
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
      base_pathname = Pathname.new(options[:filename])
      name_pathname = Pathname.new(name)
      if name_pathname.absolute?
        name = name_pathname.relative_path_from(base_pathname.dirname).to_s
      end
      each_globbed_file(name, base_pathname, options) do |p|
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

  protected

  def find_glob(name, base, options)
    contents = ""
    base = base.gsub(File::ALT_SEPARATOR, File::SEPARATOR) if File::ALT_SEPARATOR
    base_pathname = Pathname.new(base)
    each_globbed_file(name, base_pathname, options) do |filename|
      contents << "@import #{Pathname.new(filename).relative_path_from(base_pathname.dirname).to_s.inspect};\n"
    end
    contents = yield if contents.empty?
    return nil if contents.nil? || contents.empty?
    Sass::Engine.new(contents, options.merge(
      :filename => base_pathname.dirname.join(Pathname.new(name)).to_s,
      :importer => self,
      :syntax => :scss
    ))
  end

  def comment_safe(string)
    string.gsub(%r{\*/}, "*\\/")
  end
end
