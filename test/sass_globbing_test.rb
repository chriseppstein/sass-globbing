require 'test/unit'
require 'sass'
require 'sass-globbing'

class SassGlobbingTest < Test::Unit::TestCase

  def test_can_import_globbed_files
    css = render_file("all.sass")
    assert_match /deeply-nested/, css
    assert_match %r{No files to import found in doesnotexist/\*\\/foo\.\*}, css
  end

private
  def render_file(filename)
    fixtures_dir = File.expand_path("fixtures", File.dirname(__FILE__))
    full_filename = File.expand_path(filename, fixtures_dir)
    syntax = File.extname(full_filename)[1..-1].to_sym
    engine = Sass::Engine.new(File.read(full_filename),
                              :syntax => syntax,
                              :filename => full_filename,
                              :cache => false,
                              :read_cache => false,
                              :load_paths => [fixtures_dir])
    engine.render
  end
end
