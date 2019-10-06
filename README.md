# PTO Tanuki

PTO Tanuki is a simple Ruby program for cutting down the amount of TODO noise
whenever you are out of office. When enabled, it will mark TODOs for certain
groups as done, ensuring you don't come back from vacation with hundreds of no
longer relevant TODOs.

## Usage

First, set your GitLab.com status to `OOO from START until STOP`, with `START`
and `STOP` being the start and end dates, in the format `%Y-%m-%d`. For example:

> OOO from 2019-07-01 until 2019-07-07

The emoji does not matter. If you remove your status (or set it to something
else), PTO Tanuki will not do anything.

Next, get yourself an API private token with the "api" scope. You can now run
PTO Tanuki using one of the following methods:

1. Locally (e.g. on a Raspberry Pi or a laptop)
1. On a server
2. On GitLab CI, using CI schedules

In all cases, it comes down to running the following command:

    env GITLAB_TOKEN='...' GROUPS='gitlab-org,gitlab-com' bundle exec ./bin/pto-tanuki

Both `GITLAB_TOKEN` and `GROUPS` environments variables are required. The
`GROUPS` variable is a comma-separated list of groups to enable PTO Tanuki for.
If you receive TODOs from different groups, they will be ignored.

How you run this command periodically when running it locally or on a server is
up to you. Most likely you will want to set up a cronjob of some sort.

When using GitLab CI, you will have to fork the repository, then set up a CI
schedule with the following settings:

* Description: whatever you prefer (e.g. "OOO check")
* Interval pattern: [`0 */6 * * *`](https://crontab.guru/#0_*/6_*_*_*). This
  will run the job every 6 hours. Other cron compatible patterns are also fine.
* Cron Timezone: UTC
* Target branch: `master`
* Variables:
  * `GITLAB_TOKEN`: your API token obtained earlier
  * `GROUPS`: the list of groups to run PTO tanuki for
* Activated: Active

## Requirements

* Ruby 2.6 (ish) or newer
* Bundler

## License

All source code in this repository is licensed under the Mozilla Public License
version 2.0, unless stated otherwise. A copy of this license can be found in the
file "LICENSE".
