create table if not exists role
(
    id bigserial primary key not null,
    name varchar(255) not null
);

create table if not exists person
(
    id bigserial primary key not null,
    password varchar(255) not null,
    name varchar(255) not null,
    image varchar(255),
    phone_number varchar(255) not null unique,
    email varchar(255) not null unique,
    birthday date not null,
    sex boolean not null,
    role_id bigserial not null
        references role(id)
);

create table if not exists coach
(
    person_id bigserial primary key not null
        references person(id),
    rating numeric(3, 2) not null default 0,
    achievements varchar(255) default 'Пока нет достижений',
    info varchar(255) default 'Пока нет информации',
    money int not null
        check (money >= 0) default 0
);

create table if not exists transactions
(
    id bigserial primary key not null,
    date timestamp not null,
    coach_id bigserial not null
        references coach(person_id),
    money int not null
);

create table if not exists sport_sphere
(
    id bigserial primary key not null,
    name varchar(255) not null
);

create table if not exists groups
(
    id bigserial primary key not null,
    name varchar(255) not null unique,
    coach_id bigserial not null
        references coach(person_id),
    sport_sphere_id bigserial not null
        references sport_sphere(id),
    max_count int not null
        check (max_count > 0),
    count int not null
        check (count >= 0 and count <= groups.max_count),
    trains_left int not null
        check (trains_left >= 0)
);

create table if not exists training
(
    id bigserial primary key not null,
    training_date timestamp not null
        check (training_date >= now()),
    coach_id bigserial not null
        references coach(person_id),
    link varchar(255) not null,
    group_id bigserial not null
        references groups(id),
    unique (training_date, coach_id)
);

create table if not exists sport_sphere_coach_price
(
    coach_id bigserial not null
        references coach(person_id),
    sport_sphere_id bigserial not null
        references sport_sphere(id),
    price int not null
        check (price > 0),
    primary key (coach_id, sport_sphere_id)
);

create table if not exists group_person
(
    group_id bigserial not null
        references groups(id),
    person_id bigserial not null
        references person(id),
    primary key (group_id, person_id)
);

create table if not exists eat_calendar
(
    id bigserial primary key not null,
    info varchar(255),
    date date not null
        check (date >= now()),
    person_id bigserial not null
        references person(id),
    coach_id bigserial not null
        references coach(person_id),
    unique (date, coach_id)
);

create table if not exists group_chat
(
    id bigserial primary key not null,
    person_id bigserial not null
        references person(id),
    name varchar(255) not null
);

create table if not exists list_person
(
    chat_id bigserial not null
        references group_chat(id),
    person_id bigserial not null
        references person(id),
    primary key (chat_id, person_id)
);

create table if not exists list_message
(
    id bigserial primary key not null,
    chat_id bigserial not null
        references group_chat(id),
    person_id bigserial not null
        references person(id),
    content varchar(255) not null,
    date_create timestamp not null,
    unique (date_create, person_id)
);