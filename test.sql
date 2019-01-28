--using postgresql

-- scenario 1 

create table table_1 (
id bigserial,
numbers integer,
name_number text
);

create table table_2(
id bigserial,
numbers_evens integer,
number_odds integer,
total integer,
name_total text
);

create table table_3(
id bigserial,
nominal double precision,
addtional_number integer,
total double precision
);


--scenario 2
insert into table_1 (numbers, name_number)
SELECT serA.el, replace(cash_words(serA.el::money)::text,'dollars and zero cents','')
FROM generate_series(2, 1000000) serA(el)
LEFT JOIN generate_series(2, 1000000) serB(el) ON serA.el >= POWER(serB.el, 2)
AND serA.el % serB.el = 0
WHERE serB.el IS null;


insert into table_2 (numbers_evens, number_odds, total, name_total)
select genap, ganjil, (genap+ganjil) as total,
replace(cash_words((genap+ganjil)::money)::text,'dollars and zero cents','')
 from
(
(SELECT 
row_number() over() as id,
(case when generate_series %2 = 0 then generate_series else 0 end) as genap
FROM generate_series(1, 1000000)
where (case when generate_series %2 = 0 then generate_series else 0 end) <> 0
) evens
join
(SELECT 
row_number() over() as id,
(case when generate_series %2 <> 0 then generate_series else 0 end) as ganjil
FROM generate_series(1, 1000000)
where (case when generate_series %2 <> 0 then generate_series else 0 end) <> 0
) odds
on evens.id = odds.id
);


insert into table_3 (nominal, addtional_number, total)
select 
(2000000) + row_number() over()
, ((2000000) + row_number() over()) * 0.03
, ((2000000) + row_number() over()) * 0.03 + (2000000) + row_number() over()
from generate_series(1,10000);
