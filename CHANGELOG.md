# NEXT

## New Feature
### Rules For Changelog Entries

Renogen now comes with a simple rule validator which allows to check changelog item files to be validated against a
specific ruleset. See the [README](README.md#Rules) for details.

## Breaking Changes
### Refactored Command Line Parser

Instead of `OptionParser`, this version uses `Thor` to parse the command line argumentes. This comes with a slight
change in the way the `renogen` command can be used to generate the changelog.

Before

    renogen SOME_VERSION_STRING
    
The new version of renogen will not recognize `SOME_VERSION_STRING` as such. You may use the following commands
instead:

    renogen -- SOME_VERSION_STRING
    
    renogen generate SOME_VERSION_STRING

The other commands `init` and `new` are not affected by this change.    

# 1.2.0
## Improvement
* Formatters may define their own header text for releases
* Allow using a custom release date
* Allow including Ruby files (useful for using custom formatters)

# 1.1.1
## Minor
* Fixed gemspec date

# 1.1.0
## Improvement
* Added 'new' argument to create new template ticket

# 1.0.1
## Minor Improvement
* Allow empty content under heading in change file

# 1.0.0
Initial Release
