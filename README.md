# BigFiles

WARNING: This is not ready for use yet!

Simple tool to find the largest source files in your project.

To publish new version as a maintainer:

```sh
git log "v$(bump current)..."
# Set type_of_bump to patch, minor, or major
bump --tag --tag-prefix=v ${type_of_bump:?}
rake release
```
