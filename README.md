# Renogen

Renogen or Re(lease) No(tes) Gen(erator) is a development tool to separate feature notes from product versions.

This renogen can not do and will have to be reviewed manually

- Order the notes in the orrect order (e.g. if a task has to be run before/after something else)
- Remove Duplicate notes that might be added (e.g. 2 tickets might want to run the same task)

## Contents

- [Installation](#Installation)
- [Usage](#Usage)
- [Configuration](#Configuration)
- [Frequently Asked Questions](#FAQ)
- [License](#License)

<a name="Installation"></a>
## Installation

To install Renogen, use the following command:

```
$ gem install renogen
```

or add the following to your Gemfile when using Bundler

```
gem 'renogen', require: false, group: :development
```

and run

```
bundle install
```

Now, you may initialize your repository with a `change_log` directory and a basic `.renogen` config file:

```
$ renogen init` # optional  Creates directory for notes
```

<a name="Usage"></a>
## Usage

To generate your notes run the following command

```
$ renogen <VERSION> # e.g v1.2.1
```

Unfortunatly renogen cant write documentation for your change.
By default renogen uses the yaml file stratagy to extract your notes

```
$ renogen --help # list available command options
```

### Adding YAML feature notes

You can create a new file within the 'next' version folder (default: `change_log/next/`) manually:

Example feature note:

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

You can also use the `new` command to create a feature note YAML file in the 'next' version folder:

```
$ renogen new TICKET_NAME # creates ./change_log/next/TICKET_NAME.yml`
```

### Usage Examples

Prepend your notes to a changelog file (TODO make command simple)

```
$ renogen --format markdown v1.2.1 > CHANGELOG.md | cat - CHANGELOG > CHANGELOG.tmp && mv CHANGELOG.tmp CHANGELOG
```

Writes notes to html file

```
$ renogen --format html v1.2.1 > v1_2_1.html
```

Print all notes since v1.0.0 as text

```
$ renogen --format text -l v1.0.0 v1.2.1
```

<a name="Configuration"></a>
## Configuration

Renogen tries to read the file `.renogen` in the working directory to load its configuration. The file is in YAML format
with the following keys:

|       key            | meaning | default value | configuration example |
|----------------------|----------|---------------|-----------------------|
| `single_line_format` | A template for generating a single line of text from a YAML dictionary in a feature note file. Each dictionary key in the template gets replaced by the value for that key. | `summary (see link)` | `[#ticket](https://github.com/renogen/issue/ticket): summary` |
| `supported_keys`     | YAML dictionary keys allowed in dictionary feature notes. Ignored for dictionaries where rules apply. | `%w[identifier summary link]` | |
| `input_source`       | The format of the feature note files. Currently, only `yaml` is supported. | `yaml` | |
| `output_format`      | The default output format when generating release notes. | `markdown` | `html` |
| `changelog_path`     | The directory where the feature note files are stored. | `./change_log` | `./doc/src/changes` |
| `default_headings`   | The headings/group names that will be printed into a feature note file created by the `new` command. Ignored when there is a rule defined for the given file name. | `%w[Summary Detailed Tasks]` | `%w[Title Description Deployment]` |
| `allowed_values`     | Allowed values for default headings.  See [Allowed Values](#AllowedValues). | `{}` (none) |  |

<a name="AllowedValues"></a>
## Allowed Values

Allowed values enables you to specify a range of allowed values for any default heading. This can be an array, string or
regular expression:

```yaml
default_headings:
  - Products
  - Countries
  - User Facing
Products: !ruby/regexp '/\b(Foo|Bar)\b/'
Countries: [UK, AUS, FR]
User Facing: Yes
```

<a name="FAQ"></a>
## Frequently Asked Questions

### Custom formatter

You can use your own formatter quite easily.

For example, put this in `lib/my_project/renogen_formatter.rb`:

```ruby
require 'renogen/formatters'

class MyProject::RenogenFormatter < Renogen::Formatters::Base
  register :xml

  def write_header(header)
    "<release><header>#{header}</header>"
  end

  def write_group(group)
    "<group><title>#{group}</title>"
  end

  def write_group_end
    "</group>"
  end

  def write_change(change)
    "<change>#{change}</change>"
  end

  def write_footer(*)
    "</release>"
  end
end
```

You have to include that file when running renogen:

```
$ renogen -I. -Rlib/my_project/renogen_formatter 1.2.3
```

### Why does renogen not use renogen

The amount of activity and contributes for this project is small and so it is more practical to use a text file.

### How can I run from source

```
$ git clone git@github.com:DDAZZA/renogen.git
$ cd ./renogen/
$ bundle install
$ bundle exec ./bin/renogen test
```

## License

Renogen is a programming tool to generate a log of source code changes

Copyright (C) 2015-2020 David Elliott

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
