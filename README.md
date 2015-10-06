# Renogen

Renogen or Re(lease) No(tes) Gen(erator) is a development tool to separate feature notes from product versions.

### Installation

To install Renogen, use the following command:

`$ gem install renogen`

or add the following to your Gemfile

`gem 'renogen', :require => false, :group => :development`

`$ renogen init # optional  Creates directory for notes`
`$ renogen --help # List available options

### Usage

To generate your notes run the following command

`$ renogen <VERSION> # e.g v1.2.1`

Unfortunatly renogen cant write documentation for your change.
By default renogen uses the yaml file stratagy to extract your notes

`$ renogen --help # list available command options`

#### Adding YAML feature notes

Create a new file within the 'next' version folder(default:'change_log/next/')

Example feature note
```yaml
# change_log/next/example.yml
my_formatted_single_line:
  identifier: bug_1
  link: example.com/bug_1
  summary: fixes all issues

unformatted_single_line: "This is an unformatted single line"

my_multiline_note: |
  Title

  description

  Example of usage
    $ foo bar baz
my_list:
  - e.g. run this command
  - e.g. run this as well
```

#### Usage Examples

Prepend your notes to a changelog file(TODO make command simple)

`$ renogen --format markdown v1.2.1 > CHANGELOG.md | cat - CHANGELOG > CHANGELOG.tmp && mv CHANGELOG.tmp CHANGELOG`

Writes notes to html file

`$ renogen --format html v1.2.1 > v1_2_1.html`

Print all notes since v1.0.0 as text

`$ renogen --format text -l v1.0.0 v1.2.1`

### Configuration

<<<<<<< HEAD
TODO
How to set configuration with `.renogen` file
How to change formatted single line
changing the default change log path
=======
TODO 
* `.renogen` file
* single line format
* change log directory
>>>>>>> 32d03ac9390f330a3c33676a94926f8d9a80edd1

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
