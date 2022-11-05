create or replace function create_empty_coach() returns trigger as
$$
begin
    if new.role_id = (select id from role where name='COACH')
    then
        insert into coach (person_id) values (new.id);
    end if;
    return new;
end
$$ language plpgsql;

create or replace function remove_group_person() returns trigger as
$$
begin
    delete from group_person where group_id = old.id;
    return old;
end
$$ language plpgsql;

create or replace function remove_list_person() returns trigger as
$$
begin
    delete from list_person where chat_id = old.id;
    delete from list_message where chat_id = old.id;
    return old;
end
$$ language plpgsql;

create or replace function get_money_from_account() returns trigger as
$$
declare
    personMoney integer := 0;
begin
    personMoney = (select money from coach where new.coach_id = person_id);
    personMoney = personMoney + new.money;
    update coach set money = personMoney where person_id = new.coach_id;
    return new;
end
$$ language plpgsql;

create or replace function check_person_eat_calendar() returns trigger as
$$
BEGIN
    if(select count(*) from eat_calendar where new.coach_id = coach_id and new.date = date) = 1
    then
        return null;
    end if;
    return new;
end
$$ language plpgsql;

create or replace function create_group_chat() returns trigger as
$$
begin
    insert into list_person (chat_id, person_id) values (new.id, new.person_id);
    return new;
end
$$ language plpgsql;

create or replace function check_coach_birthday() returns trigger as
$$
begin
    if (new.role_id = (select id from role where name='COACH') and date_part('year', age(new.birthday)) < 18)
    then
        return null;
    end if;
    return new;
end
$$ language plpgsql;

create or replace function check_update_eat_calendar() returns trigger as
$$
begin
    if new.date is null and new.info is null
    then
        return null;
    end if;
    if new.date < now()
    then
        return null;
    end if;
    return new;
end
$$ language plpgsql;

create or replace function check_update_training_date() returns trigger as
$$
begin
    if new.training_date is null
    then
        return null;
    end if;
    if new.training_date < now()
    then
        return null;
    end if;
    return new;
end
$$ language plpgsql;

create or replace function check_group_count_for_training() returns trigger as
$$
begin
    if (select count from groups where id = new.group_id) < (select max_count from groups where id = new.group_id)
    then
        raise exception 'Группа не укомплектована!';
    end if;
    return new;
end
$$ language plpgsql;

create or replace function coach_filtration(sportSphere varchar(255) default null, minPrice int default 0, maxPrice int default 100000, minRate int default 0, maxRate int default 5) returns setof coach as
$$
begin
    if sportSphere is null
    then
        return query select * from coach
                     join sport_sphere_coach_price on coach.person_id = sport_sphere_coach_price.coach_id
                     where (sport_sphere_coach_price.price between minPrice and maxPrice) and (coach.rating between minRate and maxRate);
        return;
    end if;
    return query select * from coach
                 join sport_sphere_coach_price on coach.person_id = sport_sphere_coach_price.coach_id
                 join sport_sphere on sport_sphere_coach_price.sport_sphere_id = sport_sphere.id
                 where (sport_sphere_coach_price.price between minPrice and maxPrice) and (coach.rating between minRate and maxRate) and sport_sphere.name = sportSphere;
    return;
end
$$ language plpgsql;

create or replace function get_person_trainings(personId integer) returns setof training as
$$
begin
    return query select * from training
                 join group_person gp on training.group_id = gp.group_id
                 where gp.person_id = personId;
    return;
end
$$ language plpgsql;

create or replace function get_person_eat_calendar(personId integer) returns setof eat_calendar as
$$
begin
    return query select * from eat_calendar where person_id = personId;
    return;
end
$$ language plpgsql;

create or replace function get_all_person_in_group(groupId integer) returns setof person as
$$
begin
    return query select * from person
                 join group_person gp on person.id = gp.person_id
                 where gp.group_id = groupId;
    return;
end
$$ language plpgsql;

create or replace function get_all_person_in_group_chat(chatId integer) returns setof person as
$$
begin
    return query select * from person
                 join list_person lp on person.id = lp.person_id
                 where lp.chat_id = chatId;
    return;
end
$$ language plpgsql;

create or replace function get_all_messages_in_group_chat(chatId integer) returns setof list_message as
$$
begin
    return query select * from list_message where chat_id = chatId;
    return;
end
$$ language plpgsql;