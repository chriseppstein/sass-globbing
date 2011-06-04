require 'sass'

class Sass::Engine
  alias old_initialize initialize
  
  def initialize(template, options={})
    old_initialize(template, options)
    unless self.options[:load_paths].include?(Sass::Globbing::Importer.instance)
      self.options[:load_paths].unshift Sass::Globbing::Importer.instance
    end
  end
end