require 'test/unit'
require 'sass'
require 'sass-globbing'

class SassGlobbingTest < Test::Unit::TestCase

  def test_can_import_globbed_files
    css = render_file("all.sass")
    assert_match css, /deeply-nested/
  end

private
  def render_file(filename)
    full_filename = File.expand_path("fixtures/#{filename}", File.dirname(__FILE__))
    syntax = File.extname(full_filename)[1..-1].to_sym
    Sass::Engine.new(File.read(full_filename),
      :syntax => syntax,
      :filename => full_filename,
      :cache => false,
      :read_cache => false).render
  end
end
