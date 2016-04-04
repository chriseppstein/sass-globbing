require 'test/unit'
require 'sass'
require 'sass-globbing'

class SassGlobbingTest < Test::Unit::TestCase

  def test_can_import_globbed_files
    css, _ = render_file("all.sass")
    assert_match /deeply-nested/, css
    assert_match %r{No files to import found in doesnotexist/\*\\/foo\.\*}, css
  end

  def test_inline_sourcemap_has_content
    _, sourcemap = render_file("all.sass")
    sourcemap_json = sourcemap.to_json(:css_uri => 'css_uri', :type => :inline)
    assert_match /\.deeply-nested/, sourcemap_json
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
    engine.render_with_sourcemap("sourcemap_uri")
  end
end
