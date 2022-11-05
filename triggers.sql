create trigger get_money_from_account
    after insert on transactions for each row
execute procedure get_money_from_account();

create trigger create_group_chat
    after insert on group_chat for each row
execute procedure create_group_chat();

create trigger remove_group_person
    before delete on groups for each row
execute procedure remove_group_person();

create trigger remove_list_person
    before delete on group_chat for each row
execute procedure remove_list_person();

create trigger create_empty_coach
    after insert on person for each row
execute procedure create_empty_coach();

create trigger check_person_eat_calendar
    before insert on eat_calendar for each row
execute procedure check_person_eat_calendar();

create trigger check_coach_birthday
    before insert on person for each row
execute procedure check_coach_birthday();

create trigger check_update_eat_calendar
    before insert or update on eat_calendar for each row
execute procedure check_update_eat_calendar();

create trigger check_update_training_date
    before insert or update on training for each row
execute procedure check_update_training_date();

create trigger check_group_count_for_training
    before insert on training for each row
execute procedure check_group_count_for_training();