# Rake task to install the plugin
# Code based on https://github.com/backlogs/redmine_backlogs/blob/master/lib/tasks/install.rake

require 'fileutils'
require 'benchmark'

namespace :redmine do
  namespace :yarsp do

    desc "Install and configure Redmine YARSP"
    task :install => :environment do |t|
      raise "You must specify the RAILS_ENV ('rake redmine:yarsp:install RAILS_ENV=production' or 'rake redmine:yarsp:install RAILS_ENV=development')" unless ENV["RAILS_ENV"]

      puts "\n"
      puts "====================================================="
      puts "             Redmine YARSP Installer"
      puts "====================================================="
      puts "Installing to the #{ENV['RAILS_ENV']} environment."

      # 1. Create trackers if they don't exist
      user_story = create_tracker("User story")
      task = create_tracker("Task")
      #TODO: Make the creation of this tracker optional
      support = create_tracker("Support")

      # 2. Create Issue statuses
      create_issue_status("In Planning")

      # 3. Create custom fields
      create_custom_field_market_value([user_story.id])
      create_custom_field_urgency([user_story.id])
      create_custom_field_technical_value([user_story.id])
      create_custom_field_size([user_story.id])
      create_custom_field_sprint(Tracker.all.map {|v| v.id})

      # 4. Create role 'Backlog'
      create_role("Backlog")

       # 5. Run DB migration
      print "Migrating the database..."
      STDOUT.flush
      db_migrate_task = "redmine:plugins:migrate"
      system("rake #{db_migrate_task} --trace > redmine_yarsp_install.log")
      if $?==0
        puts "done!"
        puts "Installation complete. Please restart Redmine."
      else
        puts "ERROR!"
        puts "*******************************************************"
        puts " An error occurred during database migration."
        puts " Please see redmine_yarsp_install.log for more info."
        puts "*******************************************************"
      end
    end


    # Utility functions

    # Creates tracker
    def create_tracker(name)
      tracker = Tracker.first(:conditions => "name='#{name}'")
      if tracker
        puts "Tracker with name '#{name}' already exists. Skipping creation"
      else
        tracker = Tracker.new(:name => name)
        tracker.save!
        puts "Created Tracker with name '#{name}'"
      end
      return tracker
    end

    def create_issue_status(name)
      status = IssueStatus.first(:conditions => "name='#{name}'")
      if status
        puts "Issue status with name '#{name}' already exists. Skipping creation"
      else
        status = IssueStatus.new(:name => name)
        status.save!
        puts "Created Issue status with name '#{name}'"
      end
      return status
    end

    def create_role(name)
      role = Role.first(:conditions => "name='#{name}'")
      if role
        puts "Role with name '#{name}' already exists. Skipping creation"
      else
        role = Role.new(:name => name)
        role.save!
        puts "Created Role with name '#{name}'"
      end
      return role
    end

    def create_custom_field(options)
      name = options[:name]
      custom_field = CustomField.first(:conditions => "name='#{name}'")
      if custom_field
        puts "Custom Field with name '#{name}' already exists. Skipping creation"
      else
        customField = IssueCustomField.new(options)
        customField.save!
        puts "Created Custom Field with name '#{name}'"
      end
      return custom_field
    end

    def create_custom_field_market_value(tracker_ids = [])
      create_custom_field({
        :name => "Market value",
        :field_format => 'int',
        :min_length => 0,
        :max_length => 100,
        :tracker_ids => tracker_ids,
        :is_required => false,
        :is_for_all => true,
        :is_filter => false,
        :searchable => false})
    end


    def create_custom_field_urgency(tracker_ids = [])
      create_custom_field({
        :name => "Urgency",
        :field_format => 'int',
        :min_length => 0,
        :max_length => 100,
        :tracker_ids => tracker_ids,
        :is_required => false,
        :is_for_all => true,
        :is_filter => false,
        :searchable => false})
    end

    def create_custom_field_technical_value(tracker_ids = [])
      create_custom_field({
        :name => "Technical value",
        :field_format => 'int',
        :min_length => 0,
        :max_length => 100,
        :tracker_ids => tracker_ids,
        :is_required => false,
        :is_for_all => true,
        :is_filter => true,
        :searchable => false})
    end

    def create_custom_field_size(tracker_ids = [])
      create_custom_field({
        :name => "Size",
        :field_format => 'list',
        :tracker_ids => tracker_ids,
        :is_required => false,
        :is_for_all => false,
        :is_filter => true,
        :searchable => true,
        :possible_values => "0.5\n1\n2\n3\n5\n8\n13\n20\n40\n100"})
    end

    def create_custom_field_sprint(tracker_ids = [])
      create_custom_field({
        :name => "Sprint",
        :field_format => 'list',
        :tracker_ids => tracker_ids,
        :is_required => false,
        :is_for_all => false,
        :is_filter => true,
        :searchable => true,
        :possible_values => "Sprint 1\nSprint 2\nSprint 3"})
    end

  end
end