# Renogen

Renogen or Re(lease) No(tes) Gen(erator) is a development tool to separate feature notes from product versions.

### Installation

To install Renogen, use the following command:

`$ gem install renogen`

or add the following to your Gemfile

`gem 'renogen', :require => false, :group => :development`

`$ renogen init # optional  creates directory for notes`

### Usage

To generate your notes run the following command

`$ renogen <VERSION> # e.g v1.2.1`

Unfortunatly renogen cant write documentation for your change.
By default renogen uses the yaml file stratagy to extract your notes

`$ renogen --help # list available command options`

#### Adding YAML feature notes

Create a file within the next version folder(default:'change_log/next/')

Example feature note
```yaml
# change_log/next/example.yml
MyFormattedSingleLine:
  identifier: bug_1
  link: example.com/bug_1
  summary: fixes all issues

MyMultiLineNote: |
  Title

  description

  Example of usage
    $ foo bar baz
MyList:
  - e.g. run this command
  - e.g. run this as well
```

#### Examples

Prepend your notes to a changelog file(TODO make command simple)

`$ renogen --format markdown v1.2.1 > CHANGELOG.md | cat - CHANGELOG > CHANGELOG.tmp && mv CHANGELOG.tmp CHANGELOG`

Writes notes to html file

`$ renogen --format html v1.2.1 > v1_2_1.html`

Print all notes since v1.0.0 as text

`$ renogen --format text -l v1.0.0 v1.2.1`

### Configuration

TODO 
* `.renogen` file
* single line format
* change log directory

### License

Renogen is a programming tool to generate a log of source code changes

Copyright (C) 2015 David Elliott

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
