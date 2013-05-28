require 'sass'

class Sass::Engine
  alias old_initialize initialize
  
  def initialize(template, options={})
    old_initialize(template, options)
    self.options[:load_paths].delete(Sass::Globbing::Importer.instance) # in case it's there
    self.options[:load_paths] << Sass::Globbing::Importer.instance
  end
end

