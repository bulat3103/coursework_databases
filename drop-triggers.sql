drop trigger if exists remove_list_person on group_chat;

drop trigger if exists remove_group_person on groups;

drop trigger if exists get_money_from_account on transactions;

drop trigger if exists create_empty_coach on person;

drop trigger if exists check_person_eat_calendar on eat_calendar;

drop trigger if exists create_group_chat on group_chat;

drop trigger if exists check_coach_birthday on person;

drop trigger if exists check_update_eat_calendar on eat_calendar;

drop trigger if exists check_update_training_date on training;

drop trigger if exists check_group_count_for_training on training;