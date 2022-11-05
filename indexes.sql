create index on training using hash (coach_id, group_id);
create index on list_message using hash (chat_id);
create index on group_chat using hash (person_id);
create index on eat_calendar using hash (person_id, coach_id);
create index on groups using hash (coach_id);