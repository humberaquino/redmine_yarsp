class AddUserStoriesView < ActiveRecord::Migration
  def up
    #add a foreign key
    execute <<-SQL
CREATE VIEW `user_stories`
AS select
   `i`.`id` AS `id`,
   `i`.`project_id` AS `project_id`,
   `i`.`subject` AS `subject`,
   `i`.`description` AS `description`,
   `i`.`status_id` AS `status_id`,
   `i`.`assigned_to_id` AS `assigned_to_id`,
   `i`.`done_ratio` AS `done_ratio`,
   `i`.`estimated_hours` AS `estimated_hours`,
   `s`.`name` AS `status_name`,
   `cv_sprint`.`value` AS `sprint`,
   `cv_market`.`value` AS `market`,
   `cv_urgency`.`value` AS `urgency`,
   `cv_size`.`value` AS `size`,
   `cv_tech`.`value` AS `tech`,
   `u`.`login` AS `login`,
   `p`.`name` AS `project_name`,
   `i`.`fixed_version_id` AS `fixed_version_id`
from (((((((((`issues` `i` join `issue_statuses` `s` on((`i`.`status_id` = `s`.`id`))) join `projects` `p` on((`p`.`id` = `i`.`project_id`))) join `trackers` `t` on((`t`.`id` = `i`.`tracker_id`))) left join `custom_values` `cv_sprint` on(((`cv_sprint`.`customized_id` = `i`.`id`) and (`cv_sprint`.`custom_field_id` = (select `custom_fields`.`id` from `custom_fields`
where (`custom_fields`.`name` = 'Sprint')))))) left join `custom_values` `cv_market` on(((`cv_market`.`customized_id` = `i`.`id`) and (`cv_market`.`custom_field_id` = (select `custom_fields`.`id` from `custom_fields`
where (`custom_fields`.`name` = 'Market value')))))) left join `custom_values` `cv_urgency` on(((`cv_urgency`.`customized_id` = `i`.`id`) and (`cv_urgency`.`custom_field_id` = (select `custom_fields`.`id` from `custom_fields`
where (`custom_fields`.`name` = 'Urgency')))))) left join `custom_values` `cv_size` on(((`cv_size`.`customized_id` = `i`.`id`) and (`cv_size`.`custom_field_id` = (select `custom_fields`.`id` from `custom_fields`
where (`custom_fields`.`name` = 'Size')))))) left join `custom_values` `cv_tech` on(((`cv_tech`.`customized_id` = `i`.`id`) and (`cv_tech`.`custom_field_id` = (select `custom_fields`.`id` from `custom_fields`
where (`custom_fields`.`name` = 'Technical value')))))) left join `users` `u` on((`u`.`id` = `i`.`assigned_to_id`)))
where (`t`.`name` = 'User story') order by `i`.`id`;
    SQL
  end
 
  def down
    execute <<-SQL
       DROP VIEW user_stories
    SQL
  end
end
