select * from feedback;

Alter table feedback
add column feedback_status varchar(10);

SET SQL_SAFE_UPDATES=0;
update feedback
set feedback_status = 
CASE 
	 when rating = 1 AND (LOWER(feedback_text)like '%outage%' OR LOWER(FEEDBACK_TEXT) LIKE '%DOWN%') THEN 'URGENT'
ELSE 'NORMAL'
END;

select * from billing;
select customer_id ,
if (sum(amount_due)>500 , "high value", "standard value") as value_type
from billing
group by customer_id;

-- ____________________________________________________________________________--
-- SESSION_04--
-- -------- INNER JOIN----------

SELECT * FROM CUSTOMER;
SELECT * FROM BILLING;

SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, b.due_date, b.amount_due
FROM customer c 
INNER JOIN BILLING b
ON C.CUSTOMER_ID = B.CUSTOMER_ID;
-- __________________________________

SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME,
(round(sum(amount_due),2)) as total
from customer c
inner join billing b
group by c.CUSTOMER_ID;
-- _________________________________

select * from service_packages;
select* from subscriptions;

select sp.package_name ,count(subscription_id) as no_of_subs 
from service_packages sp 
inner join subscriptions s
on  sp.package_id = s.package_id
group by sp.package_id , sp.package_name;
-- ______________________________________

-------- LEFT JOIN ----------------
SELECT * FROM CUSTOMER;
SELECT * FROM feedback;
select c.customer_id, c.first_name,c.last_name,f.feedback_text
from customer c
left join feedback f
on c.customer_id = f.feedback_id;


SELECT * FROM CUSTOMER;
select* from service_packages;
SELECT * FROM subscriptions;
select c.customer_id,c.last_name, s.package_id,sp.package_name
from customer c 
left join subscriptions s
on c.customer_id = c.CUSTOMER_ID
left join service_packages sp
on s.package_id = sp.package_id;


select* from custOMER;
SELECT * FROM feedback;
select c.customer_id,c.first_name,c.last_name
from customer c
left join feedback f on c.CUSTOMER_ID = f.customer_id 
where f.feedback_id is null;
-- ______________________________________________
--------- RIGHT JOIN -----------
select* from custOMER;
SELECT * FROM feedback;
select f.feedback_text, f.feedback_id , concat(c.first_name, ' ' , c.last_name) as customer_name 
from feedback f 
right join customer c on f.customer_id = c.CUSTOMER_ID;

select* from custOMER;
select * from service_usage;
select su.usage_id,su.data_used, C.CUSTOMER_ID,c.First_name
from service_usage su
right join customer c 
on su.customer_id = c.CUSTOMER_ID;

-- ____________________________________________
------- MULTIPLE JOINS --------
select* from custOMER;
select * from service_usage;
select* from service_packages;
select c.customer_id, c.first_name,c.last_name , sp.package_name,su.data_used,su.minutes_used
from customer c
join subscriptions s on c.CUSTOMER_ID=s.customer_id
join service_packages sp on s.package_id = sp.package_id
join service_usage su on c.CUSTOMER_ID= su.customer_id;
-- __________________________________________________
-------- SUNQUERIES ---------
select * from service_packages;
select package_name , monthly_rate from service_packages 
where monthly_rate = (select max(monthly_rate)from service_packages);

select * from service_usage;
select customer_id , data_used  from service_usage
where data_used = (select min(data_used)from service_usage); 
-- ____________________________________________________
--------- MULTIPLE COLUMN SUQUERY 
select * from customer;
select customer_id , last_interaction_date from customer
where (customer_id , last_interaction_date) in (select customer_id , last_interaction_date from customer
where last_interaction_date > (select avg(last_interaction_date) from customer));

select * from feedback;
set sql_safe_updates=0;

update feedback
set rating = null where rating = ' ' ;

select feedback_id , service_impacted, rating from feedback
where (service_impacted, rating) in (select service_impacted, min(rating)from feedback 
group by service_impacted);
-- ____________________________________________________
------ MULTIPLE_ROW SUBQUERY ----------
select distinct c.customer_id, c.first_name,c.last_name 
FROM CUSTOMER c
JOIN subscriptions s1 on c.customer_id = s1.customer_id
where datediff(s1.end_date , s1.start_date) > all (select avg(datediff(s2.end_date,s2.start_date))from subscriptions s2 
group by s2.customer_id);

-- ___________________________________________________
----- CORRELATED SUBQUERY ------------



















