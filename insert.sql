DO
$$ DECLARE
    roles text[] := '{"CLIENT", "COACH", "ADMIN"}';
    manNames text[] := '{"Антон", "Андрей", "Арсений", "Александр", "Борис", "Булат", "Виктор", "Иван", "Василий", ' ||
                        '"Максим", "Роберт", "Денис", "Даниил", "Михаил", "Кирилл", "Алексей", "Богдан", "Николай", ' ||
                       '"Артем", "Владимир", "Вадим", "Олег", "Юрий", "Сергей", "Роман", "Илья", "Дмитрий"}';
    womanNames text[] := '{"Алина", "Жанна", "Анна", "Кристина", "Диана", "Ангелина", "Евгения", "Лилия", "Виктория", ' ||
                         '"Екатерина", "Вера", "Ксения", "Дарья", "Татьяна", "Ирина", "Ольга", "Ульяна", "Варвара", ' ||
                         '"Вероника", "Юлия", "Алла", "Софья", "Мария", "Марина", "Любовь", "Светлана", "Полина", ' ||
                         '"Нина", "Наталья", "Маргарита"}';
    surnames text[] := '{"Петров", "Максимов", "Иванов", "Жамков", "Пупкин", "Денисов", "Алексеев", "Богданов", "Штангов", ' ||
                       '"Красиков", "Антонов", "Мишин", "Китаев", "Дождев", "Тучкин", "Пупкин", "Николаев", "Дорохов", ' ||
                       '"Петряев", "Красоткин", "Галиев", "Семёнов", "Шипачев", "Радулов", "Стулов", "Китов", "Морев", ' ||
                       '"Молотов", "Войнов", "Драконов", "Кошкин", "Ежов", "Васильев", "Викторов", "Победилов", "Кораблев", ' ||
                       '"Романов", "Сергеев", "Дмитриев", "Ильин"}';
    sport_spheres text[] := '{"Йога", "Аэробика", "Пилатес", "Стрип-дэнс", "Степпинг", "Гимнастика", "Цигун", "Тай-бо", "Сайклинг", ' ||
                            '"Боди-балет", "Ки-бо", "Тайчи", "Кунг-фу", "Каларипаятту"}';
    curr_person text := '';
    coach_sport text := '';
    generate_sex int := 0;
    group_name text := '';
    sex bool := false;
    group_names text[] := '{"", "", "", "", "", "", "", "", "", "",' ||
                          '"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""}';
    cur_group_name text := '';
    cur_max_count int := 0;
    cur_count int := 0;
    added_person_id int := 0;
    training_coach_id int := 0;
    group_persons_id bigint[];
begin
    for i in 1..3 loop
        insert into role values (DEFAULT, roles[i]);
    end loop;
    for i in 1..14 loop
        insert into sport_sphere values (DEFAULT, sport_spheres[i]);
    end loop;
    for i in 1..30 loop
            curr_person := concat(womanNames[round(random() * 29) + 1], ' ', surnames[round(random() * 39) + 1], 'а');
            generate_sex := round(random());
            sex := false;
            if generate_sex = 1 then
                sex := true;
                curr_person = concat(manNames[round(random() * 26) + 1], ' ', surnames[round(random() * 39) + 1]);
            end if;
            insert into person values (DEFAULT, substr(md5(random()::text), 0, 10), curr_person,
                                       null, concat('+7', (9000000000 + round(random() * 999999999))::varchar(255)), concat(substr(md5(random()::text), 0, 10), '@gmail.com'),
                                       (timestamp '01.01.1970' + random() * (timestamp '01.01.2004' - timestamp '01.01.1970'))::date, sex, (select id from role where name='COACH'));
            added_person_id := (select currval(pg_get_serial_sequence('person', 'id')));
            coach_sport := sport_spheres[round(random() * 13) + 1];
            insert into sport_sphere_coach_price values (added_person_id, (select id from sport_sphere where name=coach_sport), round(random() * 5000) + 500);
            group_name := concat('Группа 2 ', curr_person, ' ', coach_sport);
            insert into groups values (DEFAULT, group_name, added_person_id, (select id from sport_sphere where name=coach_sport), round(random() * 9) + 1, 0, round(random() * 9) + 1);
            insert into group_chat values (DEFAULT, added_person_id, concat('Чат группы 1 ', curr_person, ' ', coach_sport));
            group_names[i] := group_name;
    end loop;
    for i in 1..600 loop
            curr_person := concat(womanNames[round(random() * 29) + 1], ' ', surnames[round(random() * 39) + 1], 'а');
            generate_sex := round(random());
            sex := false;
            if generate_sex = 1 then
                sex := true;
                curr_person = concat(manNames[round(random() * 26) + 1], ' ', surnames[round(random() * 39) + 1]);
            end if;
            insert into person values (DEFAULT, substr(md5(random()::text), 0, 10), curr_person,
                                       null, concat('+7', (9000000000 + round(random() * 999999999))::varchar(255)), concat(substr(md5(random()::text), 0, 10), '@gmail.com'),
                                       (timestamp '01.01.1970' + random() * (timestamp '01.01.2004' - timestamp '01.01.1970'))::date, sex, (select id from role where name='CLIENT'));
            added_person_id := (select currval(pg_get_serial_sequence('person', 'id')));
            for j in 1..30 loop
                    cur_group_name := group_names[j];
                    cur_max_count := (select max_count from groups where name=cur_group_name);
                    cur_count := (select count from groups where name=cur_group_name);
                    if cur_max_count >= cur_count + 1 then
                        insert into group_person values ((select id from groups where name=cur_group_name), added_person_id);
                        update groups set count=cur_count + 1 where name=cur_group_name;
                        insert into list_person values ((select id from group_chat where person_id=(select coach_id from groups where name=cur_group_name)), added_person_id);
                        insert into transactions values (DEFAULT, (timestamp '01.10.2022' + random() * (timestamp '05.11.2022' - timestamp '01.10.2022'))::date, (select coach_id from groups where name=cur_group_name),
                                                         (select price from sport_sphere_coach_price where coach_id=(select coach_id from groups where name=cur_group_name) and sport_sphere_id=(select sport_sphere_id from groups where name=cur_group_name)));
                        exit;
                    end if;
            end loop;
    end loop;
    for i in 1..30 loop
            training_coach_id := (select coach_id from groups where name=group_names[i]);
            for j in 1..round(random() * 8) + 1 loop
                    insert into training values (DEFAULT, (timestamp '01.01.2022' + random() * (timestamp '05.12.2022' - timestamp '01.01.2022'))::timestamp,
                                                 training_coach_id, concat('zoom.us/', substr(md5(random()::text), 0, 5)),
                                                 (select id from groups where name=group_names[i]));
            end loop;
    end loop;
end $$;