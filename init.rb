require 'redmine'

Redmine::Plugin.register :redmine_yarsp do
  name 'Redmine Yarsp plugin'
  author 'Humber Aquino'
  description 'Simple Scrum plugin for Redmine'
  version '0.1.2'

  # Backlogs menu
  menu :top_menu,
       :backlogs,
       { :controller => 'backlogs', :action => 'index' },
       :caption => 'Backlog',
       :if => Proc.new { BacklogsController.new.current_user_can_use_backlogs }

end
