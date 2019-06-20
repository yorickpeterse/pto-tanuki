# PTO Tanuki

PTO Tanuki is a simple Ruby program for cutting down the amount of TODO noise
whenever you are out of office. When enabled, it will mark TODOs for certain
groups as done, and inform others you are not available whenever they mention
you.

## Usage

First, set your GitLab.com status to `OOO from START until STOP`, with `START`
and `STOP` being the start and end dates, in the format `%Y-%m-%d`. For example:

> OOO from 2019-07-01 until 2019-07-07

The emoji does not matter. If you remove your status (or set it to something
else), PTO Tanuki will not do anything.

Next, get yourself an API private token with the "api" scope. You can now run
PTO Tanuki as follows:

    env GITLAB_TOKEN='...' GROUPS='gitlab-org,gitlab-com' bundle exec ./bin/pto-tanuki

Both `GITLAB_TOKEN` and `GROUPS` environments variables are required. The
`GROUPS` variable is a comma-separated list of groups to enable PTO Tanuki for.
If you receive TODOs from different groups, they will be ignored.

You can also use GitLab CI by forking this repository and setting up a CI
schedule.

## Requirements

* Ruby 2.6 (ish) or newer
* Bundler

## License

All source code in this repository is licensed under the Mozilla Public License
version 2.0, unless stated otherwise. A copy of this license can be found in the
file "LICENSE".
