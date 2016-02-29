# 1.1.5

* Add LICENSE file (MIT).
* Fix homepage of project on rubygems.org.

# 1.1.4

This release was yanked due to bugs.

# 1.1.3

* Fix globbing importing path correctly.

# 1.1.2

* Fix globbing importing path

# 1.1.1

* Fix importing issues when using import-once with sass-globbing
* Fix mtime checks so that globs don't force recompiles of unchanged
  sass files.

# 1.1.0

* Add the ability for a glob to not match any files. Instead a css
  comment is generated that explains that nothing was found (to enable
  debugging).

  Because of this behavior, it is imperitive that the globbing importer
  come after the compass sprite importer in the sass load path. This is
  done for you automatically, but it is something to keep in mind.

* Fix a globbing issue on windows.

# 1.0.0

Initial release.
