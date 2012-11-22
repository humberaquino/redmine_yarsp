# redmine_yarsp: Yet Another Redmine Scrum plugin

A simple plugin to add scrum capabilities to Redmine.
Currently, it only supports "Product Backlog".

__Obs.: This version is in alpha stage__

## Redmine versions

 This plugin was tested only on Redmine 2.1.2.

## Installation

1. Clone this repo into redmine's plugins directory
```
git clone https://github.com/humberaquino/redmine_yarsp.git
```

2. Change directory to plugin and run
```
rake redmine:yarsp:install RAILS_ENV=production
```

This rake task will create trackers, custom fiels, statuses and roles needed for the plugin to work.
It also will run the plugin's migration task.


## TODO

* Clean up backlog controller code


## Changelog

* 0.1.2
Rake task to setup trackers, status, role and custom fields added.

* 0.1.1
Fix to be able to use mysql and mysql2 gem

* 0.1.0
Initial version with backlog

