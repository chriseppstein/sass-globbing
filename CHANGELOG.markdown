# 1.1.0

This release adds the ability for a glob to not match any files. Instead
a css comment is generated that explains that nothing was found (to enable
debugging).

Because of this behavior, it is imperitive that the globbing importer
come after the compass sprite importer in the sass load path.

# 1.0.0

Initial release.
