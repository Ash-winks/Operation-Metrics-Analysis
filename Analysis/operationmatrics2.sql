create database operation_metrics_case_study2;

use operation_metrics_case_study2;

# 1st table users
create table users(
user_id int,
created_at varchar(90),
company_id int,
`language` varchar(90),
activated_at varchar(90),
state varchar(80)
);
select * from users;
show variables like 'secure_file_priv';

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Table 1-users.csv"
INTO TABLE users
FIELDS terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

alter table users add column temp_created_at datetime;
set sql_safe_updates=0;
update users 
set temp_created_at =str_to_date(created_at,'%d-%m-%Y %H:%i');
 alter table users drop column created_at; 
 alter table users change column  temp_created_at  created_at datetime;
 alter table users modify column   created_at datetime after company_id;

alter table users add column temp_activated_at datetime;
update users 
set temp_activated_at =str_to_date(activated_at,'%d-%m-%Y %H:%i');
alter table users drop column activated_at;
alter table users change column temp_activated_at activated_at datetime;


# 2nd table events
create table `events`(
user_id int,
occurred_at varchar(90) ,
event_type varchar(100) ,
event_name varchar(100),
location   varchar(100),
device varchar(200),
user_type int 
);
select * from `events`;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Table 2-events.csv"
INTO TABLE `events`
FIELDS terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;
 
 
 alter table `events` add column temp_occured_at datetime;
 update `events`
 set temp_occured_at=str_to_date(occurred_at,'%d-%m-%Y %H:%i');
 alter table `events` drop column occurred_at;
 alter table `events` change column temp_occured_at occurred_at datetime;
 
 
#3rd table email-events
create table email_events(
user_id int,
occurred_at varchar(100),
`action` varchar(150),
user_type int
);

 LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Table 3-email_events.csv"
INTO TABLE email_events
FIELDS terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from email_events;
select * from `events`;

alter table email_events  add column temp_occured_at datetime;
update email_events
 set temp_occured_at=str_to_date(occurred_at,'%d-%m-%Y %H:%i');
 alter table email_events drop column occurred_at;
 alter table email_events change column temp_occured_at occurred_at datetime;
 alter table email_events modify column occurred_at datetime after user_id;
 
 
 #Write an SQL query to calculate the weekly user engagement.
 with user_events as (
 select user_id ,occurred_at 
 from `events`
 union 
 select user_id ,occurred_at 
 from email_events
 )
 select 
 extract(year from user_events.occurred_at )as year_,
 extract(week from user_events.occurred_at )as week_,
 count(distinct user_events.user_id)as active_users
 from user_events
 join users on user_events.user_id=users.user_id
 group by week_,year_
 order by week_,year_;
 
 #Write an SQL query to calculate the user growth for the product.
 select 
	count(distinct user_id)total_users,
    year ( created_at)as year_,
    week(created_at,1)week_,
    sum(count(user_id))over(order by year(created_at),week(created_at,1))cumulative_sum_of_users_over_time
 from users
 group by year_,week_;
 
 #Write an SQL query to calculate the weekly retention of users based on their sign-up cohort.
 with user_signup as(
 select users.user_id,
 yearweek(users.created_at,1) signup_week
 from users
 ),
 user_activity as(
 select `events`.user_id,
 yearweek(`events`.occurred_at) activity_week
 from `events`
 )
 select
 user_signup.signup_week,
 user_activity.activity_week,
 count(distinct user_activity.user_id)as retained_user
 from user_signup
 join user_activity
 on user_signup.user_id=user_activity.user_id
 where user_activity.activity_week>=user_signup.signup_week
 group by user_signup.signup_week,user_activity.activity_week
 order by retained_user  ;
 
 
 
 # Write an SQL query to calculate the weekly engagement per device.
 
 with user_activity as (
 select user_id,occurred_at,device
 from `events`
 union 
 select user_id,occurred_at,'email'as device
 from email_events
 )
 select device,
 year(occurred_at)as year_,
 week(occurred_at,1)as week_,
 count( distinct user_id) as active_users
 from user_activity
 group by week_,year_,device
 order by active_users desc;
 
 #Write an SQL query to calculate the email engagement metrics.
 SELECT 
    YEAR(occurred_at) AS year_,
    WEEK(occurred_at) AS week_,
    SUM(CASE
        WHEN action = 'sent_weekly_digest' THEN 1
        ELSE 0
    END) total_email_sent,
    SUM(CASE
        WHEN action = 'email_open' THEN 1
        ELSE 0
    END) total_email_opened,
    SUM(CASE
        WHEN action = 'email_clickthrough' THEN 1
        ELSE 0
    END) total_email_clickthroughs,
    SUM(CASE
        WHEN action = 'email_open' THEN 1
        ELSE 0
    END) / COUNT(*) * 100 email_open_rate,
    SUM(CASE
        WHEN action = 'email_clickthrough' THEN 1
        ELSE 0
    END) / COUNT(*) * 100 email_clickthrough_rate
FROM
    email_events
GROUP BY year_ , week_
ORDER BY year_ , week_;
 