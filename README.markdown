# Sass Globbing Plugin

Sass globbing allows you to import many sass or scss files in a single import statement.

## Stylesheet Syntax

Import a folder of files:

```scss
@import "library/mixins/*"
```

Import a tree of files:

```scss
@import "library/**/*"
```

Globbed files are sorted alphabetically before importing them.

Globs are always relative to the current file. The ruby glob file syntax is used, read the [docs][globbing_docs] for more that you can do with it.

## Installation

    $ gem install sass-globbing

## Use with the Sass command line

    $ sass -r sass-globbing --watch sass_dir:css_dir

## Use with compass

Add the following to your compass configuration:

```ruby
require 'sass-globbing'
```

## Use with Ruby on Rails

Ruby on Rails has this capability out of the box starting in Rails 3.1. Do not install this plugin if you use Rails 3.1 or greater.

## Use with plain Ruby

When using in plain ruby, be sure to pass the `filename` option since it is used in determining the import path:

```ruby
require 'sass-globbing'

file    = "path/to.scss"
options = { filename: file, syntax: :scss, ... }
css     = Sass::Engine.new(File.read(file), options).render
```
## Caveats

CSS is order dependent, as such, using this approach within your stylesheets to import styles that depend on the stylesheet's cascade creates an opportunity for styles to change more unpredictably than a manually asserted order. It is recommended that you only use globbing where order is unimportant; E.g. importing of library files.


[globbing_docs]: http://ruby-doc.org/core/classes/Dir.html#method-c-glob
