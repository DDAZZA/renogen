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

`$ gem install renogen`

or add the following to your Gemfile when using Bundler

    gem 'renogen', require: false, group: :development

and run `bundle install`.

Now, you may initialize your repository with a `change_log` directory and a basic `.renogen` config file:

    $ renogen init # optional  Creates directory for notes

<a name="Usage"></a>
## Usage

### Adding YAML feature notes

You can create a new file within the 'next' version folder (default: `change_log/next/`) manually:

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

You can also use the `new` command to create a feature note YAML file in the 'next' version folder:

    $ renogen new TICKET_NAME # creates ./change_log/next/TICKET_NAME.yml
    
If you have configured [rules and templates for them](#Rules), you may also pass the `type` option:

    $ renogen new --type bug TICKET_NAME # creates ./change_log/next/bugs/TICKET_NAME.yml
    
That way, you can have specific templates for the feature type you're describing.

### Generating Release Notes From Feature Notes

To generate your notes run the following command

    $ renogen generate <VERSION> # e.g v1.2.1

Unfortunatly renogen can't write documentation for your change.
By default renogen uses the yaml file stratagy to extract your notes

    $ renogen generate --help # list available command options

#### Usage Examples

Prepend your notes to a changelog file (TODO make command simple)

    $ renogen generate --format markdown v1.2.1 > CHANGELOG.md | cat - CHANGELOG > CHANGELOG.tmp && mv CHANGELOG.tmp CHANGELOG`

Writes notes to html file

    $ renogen generate --format html v1.2.1 > v1_2_1.html

Print all notes since v1.0.0 as text

    $ renogen generate --format text -l v1.0.0 v1.2.1


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
| `file_rules`         | Rules for feature note files matching defined patterns. See [Rules](#Rules). | `{}` (none) | |
| `group_rules`        | Rules for different groups of feature notes in a note file. See [Rules](#Rules). | `{}` (none) | |


<a name="Rules"></a>
### Rules

Renogen comes with a simple rule validator that can help you to ensure all feature notes comply to the specific form you
require. There are two different types of rules: One for feature note files and one for the groups defined within those
files. You can use the file rules to require the existence of specific headings/group names in feature note files. You
can use group rules to ensure the contents of the groups are meeting all requirements.


#### File Rules

Let's start with an example `.renogen` config file to describe this feature:

```yaml
file_rules:
  "bugs/**/*.yml":
    keys:
      required:
      - Title
      - Link
      - Tickets
      - Severity
      optional:
      - Tasks
      - Migrations
  "**/*.yml":
    keys:
      required:
      - Title
      - Link
      optional:
      - Tasks
      - Migrations
```

As you can see, each a file rule consists of a file name matching pattern and a set of required and/or optional keys,
ie. each file that matches the pattern must have all the required keys and may have the optional keys, but no other
keys. Please note that order is important --- each file will only be validated against the first rule which's pattern
matches the name. In the example above, the file `bugs/ABC-1234.yml` will have to include the headings `Title`, `Link`,
`Tickets` and `Severity`. It may contain the headings `Tasks` and `Migrations`. The file `features/DEF-456` on the other
hand only has to provide `Title` and `Link` and may have the same optional headings.

At the moment, Renogen only supports whitelisting.

***Attention!*** Renogen is case-sensitive!


#### Group Rules

While you can define the required and allowed headings of feature note files with file rules, you can use group rules to
describe the contents under those headings. For example, the `file_rules` defined in the `.renogen` configuration file
above might be accompanied by the following `group_rules`:

```YAML
group_rules:
  Title:
    type: String
  Link:
    type: String
  Tickets:
    type: Array
    items:
      type: String
  Severity:
    type: String
  Tasks:
    type: Array
    items:
      type: Hash
      keys:
        required:
        - Summary
        optional:
        - Detailed
      items:
        Summary:
          type: String
        Detailed:
          type: String
  Migrations:
    type: Array
    items:
      type: Hash
      keys:
        required:
        - Name
        - Tables
        - Description
        - Revertible
      items:
        Name:
          type: String
        Tables:
          type: Array
        Description:
          type: String
        Revertible:
          type: Boolean
```

As you can see in the above example, the group rules can get quite detailed. Let's have a look at an example
feature note file that is accepted by Renogen with the above config:

```yaml
# ./change_log/next/bugs/123.yml
Title: Ensure bubblebar gets called once
Link: https://some.where.example/123
Tickets:
- "123"
Severity: medium
Tasks:
- Summary: "`rake fix_bubblebar`"
  Detailed: Run the rake task and log the results. Task must be run after migrations.
Migrations:
- Name: "20170423101010_add_last_run_to_bubblebars"
  Tables:
  - bubblebars
  Description: "Adds a DATETIME column `last_run` to the `bubblebars` table"
  Revertible: true
```

There are different validators available which specific configuration options each. See the section below for a
documentation of each type. All have in common that the heading/group name on which the rule is applied is the key of
the `group_rules` YAML dictionary. There is a special wildcard key `:*:` that will match all headings/group names
without a specific rule entry. ***Again, do not forget that renogen is case-sensitive.*** 


##### Supported Validators

Which validator is used for a specific heading/group is specified using the `type` option. Choose between `Hash`,
`Array`, `String` and `Boolean`.


###### Hash

This validator checks that a value is a YAML dictionary. It supports key whitelisting and checking for mandatory keys as
well as validating the dictionary values. There are the following configuration options:

* `keys`

  Validates the dictionary keys using whitelisting. Supports the following sub-options:

  - `required`
  
    A list of required dictionary keys. Validated YAML dictionaries without the given keys are rejected.
    
  - `optional`
  
    A list of optional dictionary keys. Validated YAML dictionaries with keys not included in `required` or `optional`
    are rejected.
    
  Once again, all checks are case-sensitive.
  
* `items`

  Validates the dictionary values using another validator. Takes the option `type` and may take other config options for
  the chosen validator. Validated YAML dictionary values are rejected when they are not validated positively against the
  configured validator.


###### Array

This validator checks that a value is a YAML list. It can also validate the list values against another validator. To
use that feature, there is the `items` configuration option which itself takes the option `type` and other configuration
options for the specific validator.


###### String

This validator checks that a value is a String. At the moment, there are no configuration options available.


###### Boolean

This validator checks that a value is either `true` or `false`.


#### Validating Feature Note Files

When a feature note file does not adhere to the configured rules, generating the release notes will fail with an error
message on STDERR and an exit code of `255`.


#### Creating New Feature Note Files

The `new` command of Renogen tries to be smart when creating a feature note file with rules present. It will create a
YAML file with all supported keys present with `REPLACE ME` values and the expected types. So, for instance, a file
created using the above rule configurations will look like this:

```yaml
# $ renogen new 123
# ./change_log/next/123.yml
---
Title: REPLACE ME
Link: REPLACE ME
Tasks:
- replace me
Migrations:
- replace me
```

When you pass a `--type` option, the feature note file will be created in a directory named after the type given plus a
plural `s`, eg., `$ renogen new --type bug 678` will create the file `./change_log/next/bugs/678.yml`. As there is a
specific file rule for that path, the created YAML is different:

```yaml
# $ renogen new --type bug 678
# ./change_log/next/bugs/678.yml
---
Title: REPLACE ME
Link: REPLACE ME
Tickets:
- replace me
Severity: REPLACE ME
Tasks:
- replace me
Migrations:
- replace me
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

`$ renogen -I. -Rlib/my_project/renogen_formatter 1.2.3`

### Why does renogen not use renogen?
The amount of activity and contributes for this project is small and so it is more practical to use a text file.

<a name="License"></a>
## License

Renogen is a programming tool to generate a log of source code changes

Copyright (C) 2015-2017 David Elliott

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
