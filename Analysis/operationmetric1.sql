use operation_metrics_case1;
select * from job_data;

create table job_data(
ds date,
job_id int,
actor_id int,
`event`varchar(10),
`language`varchar(20),
time_spent int,
org char(1)
);
insert into job_data values
('2020-11-30',21,1001,'skip','English',15,'A'),
('2020-11-30',22,1006,'transfer','Arabic',25,'B'),
('2020-11-29',23,1003,'decision','Persian',20,'C'
),('2020-11-28',23,1005,'transfer','Persian',22,'D'
),('2020-11-28',25,1002,'decision','Hindi',11,'B'
),('2020-11-27',11,1007,'decision','French',104,'D'),
('2020-11-26',23,1004,'skip','Persian',56,'A'
),('2020-11-25',20,1003,'transfer','Italian',45,'C'
),('2020-12-30',27,1010,'skip','Arabic',20,'B'
),('2020-12-30',26,1008,'decision','Arabic',30,'B'
),('2020-12-29',29,1009,'skip','Arabic',25,'D'
),('2020-12-28',28,1011,'transfer','English',27,'A'
),('2020-12-28',33,1013,'decision','Hindi',16,'B'
),('2020-12-27',30,1012,'skip','Arabic',109,'C'
),('2020-12-26',32,1015,'decision','persian',61,'A'
),('2020-12-25',31,1014,'transfer','persian',50,'D'
),('2020-12-30',37,1029,'transfer','persian',20,'D'
),('2020-12-30',43,1031,'transfer','Arabic',30,'A'
),('2020-12-29',40,1016,'decision','persian',25,'B'
),('2020-12-28',38,1023,'decision','persian',27,'C'
),('2020-12-28',46,1030,'decision','Arabic',16,'C'
),('2020-12-27',42,1024,'skip','English',109,'A'
),('2020-12-26',34,1019,'transfer','Hindi',61,'B'
),('2020-12-25',49,1026,'decision','Hindi',50,'D'
),('2021-01-29',36,1021,'transfer','Arabic',25,'C'
),('2021-01-29',47,1022,'skip','Arabic',35,'C'
),('2021-01-28',48,1028,'transfer','Arabic',30,'B'
),('2021-01-27',45,1025,'decision','Hindi',32,'D'
),('2021-01-27',39,1018,'skip','Arabic',21,'B'
),('2021-01-26',35,1020,'skip','persian',114,'A'
),('2021-01-25',44,1027,'skip','persian',66,'B'
),('2021-01-24',41,1017,'decision','English',55,'A'
),('2020-12-30',67,1033,'transfer','Arabic',20,'D'
),('2020-12-30',79,1036,'decision','English',30,'A'
),('2020-12-29',61,1041,'skip','persian',25,'D'
),('2020-12-28',59,1032,'skip','Arabic',27,'B'
),('2020-12-28',52,1045,'decision','Arabic',16,'D'
),('2020-12-27',62,1047,'decision','Arabic',109,'B'
),('2020-12-26',64,1060,'skip','Arabic',61,'C'
),('2020-12-25',65,1049,'decision','persian',50,'C'
),('2021-01-29',54,1055,'transfer','English',25,'D'
),('2021-01-29',81,1038,'decision','persian',35,'D'
),('2021-01-28',80,1059,'skip','English',30,'D'
),('2021-01-27',58,1043,'decision','Arabic',32,'B'
),('2021-01-27',57,1039,'decision','English',21,'C'
),('2021-01-26',55,1048,'decision','Hindi',114,'B'
),('2021-01-25',72,1042,'decision','English',66,'C'
),('2021-01-24',73,1052,'skip','persian',55,'D'
),('2021-01-29',77,1044,'decision','Hindi',25,'A'
),('2021-01-29',68,1037,'skip','persian',35,'C'
),('2021-01-28',78,1063,'decision','Hindi',30,'C'
),('2021-01-27',56,1058,'skip','English',32,'A'
),('2021-01-27',66,1053,'transfer','Hindi',21,'A'
),('2021-01-26',51,1062,'transfer','Hindi',114,'B'
),('2021-01-25',75,1051,'transfer','Arabic',66,'D'
),('2021-01-24',70,1046,'transfer','Hindi',55,'D'
),('2021-02-28',60,1054,'decision','Arabic',30,'C'
),('2021-02-28',74,1035,'skip','Arabic',40,'D'
),('2021-02-27',76,1040,'skip','Arabic',35,'D'
),('2021-02-26',50,1061,'decision','Hindi',37,'B'
),('2021-02-26',69,1056,'skip','Hindi',26,'B'
),('2021-02-25',53,1050,'decision','Arabic',119,'B'
),('2021-02-24',63,1057,'decision','persian',71,'A'
),('2021-02-23',71,1034,'decision','persian',60,'A');

select * from job_data;
use operation_metrics_case1;

# calculate the number of jobs reviewed per hour for each day in November 2020.
SELECT 
    ds,
    COUNT(job_id) AS total_jobs,
    COUNT(job_id) / 24 AS job_per_hour
FROM
    job_data
WHERE
    ds BETWEEN '2020-11-01' AND '2020-11-30'
GROUP BY ds
ORDER BY ds;

#Calculate the 7-day rolling average of throughput (number of events per second).
with throughput as (
select ds,count(event)/sum(time_spent) as event_per_second
from job_data
group by ds
)
select ds,event_per_second,avg(event_per_second)over( order by ds Rows between 6 preceding and current row)as `7-day_rolling_average`
from throughput
order by ds;


#Calculate the percentage share of each language in the last 30 days.
select language ,count(*)*100.0/sum(count(*)) over() as percent_share_of_lang
from job_data
where ds>=date_sub((select max(ds)from job_data),interval 30 day)
group by language 
order by percent_share_of_lang desc;

#Write an SQL query to display duplicate rows from the job_data table.
select ds ,job_id,actor_id,event,language,time_spent,org
from job_data
group by ds ,job_id,actor_id,event,language,time_spent,org
having count(*)>1;


select ds,count(*)as date_count
from job_data
group by ds
having count(*)>1
order by date_count desc