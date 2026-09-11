-- 1st Session Assignment======================================================

select product_id from Products where low_fats='Y' and recyclable='Y';

select * from CITY where COUNTRYCODE = 'JPN';

select * from CITY where POPULATION >100000 and COUNTRYCODE = 'USA';

select name from Customer where referee_id != 2 or referee_id is null;

select name, population, area from World where area >= 3000000 OR population >= 25000000; 

select distinct author_id as id from Views where author_id = viewer_id order by author_id asc;

select tweet_id from Tweets where length(content)>15;

select name as Customers from Customers where id not in (select distinct customerId from Orders);


-- Joins======================================================

select p.firstName, p.lastName, a.city, a.state from Person p 
left join Address a 
on p.personId = a.personId;

select EU.unique_id, E.name from Employees E
left join EmployeeUNI EU
on E.id = EU.id;

select p.product_name, s.year, s.price from Product p 
inner join Sales s
on p.product_id = s. product_id

-- --
select sp.name from SalesPerson sp 
where sp.sales_id not in (
select o.sales_id from Orders o inner join Company c 
on o.com_id = c.com_id where c.name = 'RED'
)

OR

SELECT name
FROM SalesPerson
WHERE sales_id NOT IN (
    SELECT sales_id
    FROM Orders
    WHERE com_id = (
        SELECT com_id
        FROM Company
        WHERE name = 'RED'
    )
);

-- --

--To find rows after removing duplicate but keeping the first occurence of duplicate 
SELECT p1.*
FROM Person p1
LEFT JOIN Person p2
  ON p1.email = p2.email
 AND p1.id > p2.id
where p2.id is null
ORDER by id;

--To find duplicate 
SELECT p1.*
FROM Person p1
LEFT JOIN Person p2
  ON p1.email = p2.email
 AND p1.id > p2.id
where p2.id is not null
ORDER by id;

-- to delete duplicate
delete from person p1 
join person p2 
where p1.email = p2.email AND p1.id > p2.id;-

-- --

SELECT 
    s.student_id,
    s.student_name,
    sub.subject_name,
    COALESCE(e.exam_count, 0) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN (
    SELECT 
        student_id,
        subject_name,
        COUNT(*) AS exam_count
    FROM Examinations
    GROUP BY student_id, subject_name
) e
ON s.student_id = e.student_id 
AND sub.subject_name = e.subject_name
ORDER BY s.student_id, sub.subject_name;



-- Sorting and Grouping======================================================

SELECT teacher_id, COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id
ORDER BY teacher_id;

-- --

select 
    class
from Courses
group by class having count(distinct student)>=5


-- --

select activity_date as day, count(distinct user_id) as active_users
from Activity
where activity_date between '2019-06-28' and '2019-07-27' 
group by activity_date
order by day

OR

SELECT 
    activity_date AS day,
    COUNT(DISTINCT user_id) AS active_users
FROM 
    (SELECT DISTINCT user_id, activity_date
     FROM Activity
     WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27') AS filtered
GROUP BY 
    activity_date
ORDER BY
    day;

-- --

select product_id, year as first_year, quantity, price 
from Sales
where (product_id, year) in 
( 
    select product_id, min(year) as year
    from Sales 
    group by product_id 
)
order by product_id

OR

SELECT product_id,
       year AS first_year,
       quantity,
       price
FROM Sales
WHERE year = (
    SELECT MIN(year)
    FROM Sales AS s2
    WHERE s2.product_id = Sales.product_id
)
ORDER BY product_id;

-- --

select 
    customer_id 
from Customer 
group by customer_id 
having count(distinct product_key) = (
    select count(distinct product_key) from Product
) 
order by customer_id

-- --

select 
    date_id, 
    make_name, 
    count(distinct lead_id) as unique_leads, 
    count(distinct partner_id) as unique_partners
from DailySales
group by date_id, make_name
order by date_id

-- --


-- Aggregation======================================================

select 
    player_id,
    min(event_date) as first_login
from Activity 
group by player_id

-- --

-- Write your SQL query here

select 
    name as warehouse_name,
    sum(volume_single) as volume
from 
(
    select 
        name,
        (units*unit_volume) as volume_single 
    from 
    (
        select 
            name,
            product_id,
            units 
        from Warehouse w 
    ) wd
    inner join
    (
        select 
            product_id, 
            (Width*Length*Height) as unit_volume
        from Products 
    ) pv 
    on wd.product_id = pv.product_id 
) whs 
group by name

OR

select 
 name as warehouse_name,
 sum (units * Width * Length * Height) as volume
from Warehouse w join Products p 
on w. product_id = p.product_id
group by name 


-- --

-- Write your SQL query here

select 
 customer_number
from 
(
    select customer_number, count(customer_number) cnt 
    from Orders
    group by customer_number
    order by cnt desc
)o 
limit 1

OR

select customer_number
from Orders
group by customer_number
order by count(*) desc 
limit 1;

-- --

select 
    p.project_id, 
    round(avg(experience_years),2) as average_years
from Employee e join Project p
on e.employee_id =p.employee_id
group by project_id

-- -- 

with cust_cte_c as
(
    select 
        customer_id
    from Orders
    where product_name ='C' 
),
cust_cte_b as
(
    select 
        customer_id
    from Orders
    where product_name ='B' 
)
select distinct c.customer_id,c.customer_name from Customers c join Orders o 
on c.customer_id = o.customer_id
where product_name in ('A') 
and
o.customer_id in (select distinct customer_id from cust_cte_b cb)
and
o.customer_id not in (select distinct customer_id from cust_cte_c cc);

OR

with product_bought_cte as
    (
        select 
        customer_id,
        sum(case when product_name='A' then 1 else 0 end) bought_a,
        sum(case when product_name='B' then 1 else 0 end) bought_b,
        sum(case when product_name='C' then 1 else 0 end) bought_c
        from Orders
        group by customer_id
    ),
    target_customers as 
    (
        select distinct customer_id 
        from product_bought_cte
        where bought_a>0 and bought_b>0 and bought_c=0
    )
select c.customer_id, c.customer_name from Customers c join target_customers tc 
on c.customer_id= tc.customer_id 
order by c.customer_id

-- --

-- Write your SQL query here
with guest_details as (
        select 
            guest_team,
            sum(case when host_goals>guest_goals then 0 
                when host_goals<guest_goals then 3 
                else 1 
            end ) guest_points
        from Matches
        group by guest_team 
    ),
    host_details as (
        select 
            host_team,
            sum(case when host_goals<guest_goals then 0 
                when host_goals>guest_goals then 3 
                else 1 
            end ) host_points
        from Matches
        group by host_team
    ),
    required_table as(
        select guest_team as id , guest_points as pts from guest_details
        union all
        select host_team as id, host_points as pts from host_details
    )
    select t.team_id, t.team_name, coalesce(sum(rt.pts),0) as num_points 
    from Teams t left join required_table rt 
    on t.team_id = rt.id
    group by t.team_id
    order by num_points desc, team_id asc

OR 

WITH host_result AS (
    SELECT 
        host_team AS team_id,
        CASE 
            WHEN host_goals > guest_goals THEN 3
            WHEN host_goals = guest_goals THEN 1
            ELSE 0
        END AS points
    FROM Matches
),
guest_result AS (
    SELECT 
        guest_team AS team_id,
        CASE 
            WHEN guest_goals > host_goals THEN 3
            WHEN guest_goals = host_goals THEN 1
            ELSE 0
        END AS points
    FROM Matches
),
all_results AS (
    SELECT * FROM host_result
    UNION ALL
    SELECT * FROM guest_result
),
team_points AS (
    SELECT team_id, SUM(points) AS num_points
    FROM all_results
    GROUP BY team_id
)
SELECT 
    t.team_id,
    t.team_name,
    COALESCE(tp.num_points, 0) AS num_points
FROM Teams t
LEFT JOIN team_points tp ON t.team_id = tp.team_id
ORDER BY num_points DESC, t.team_id ASC;

-- --

with EvalOperands as(
        SELECT 
            e.left_operand,
            e.operator,
            e.right_operand,
            lv.value as left_value,
            rv.value as right_value
        from Expressions e 
        join Variables lv on e.left_operand= lv.name
        join Variables rv on e.right_operand= rv.name
    )
    select
        left_operand, 
        operator, 
        right_operand,
        (case 
            when operator = '>' and left_value > right_value then 'true'
            when operator = '<' and left_value < right_value then 'true'
            when operator = '=' and left_value = right_value then 'true'
            else 'false' 
        end) as value   
    from EvalOperands

-- --

with normalized_cte as (
        select 
        -- always set smaller value as person 1
        (case when from_id < to_id then from_id else to_id end) as person1,
        -- always set bigger value as person 2
        (case when from_id < to_id then to_id else from_id end) as person2,
        duration
        from Calls 
    )
    select person1, person2, 
    count(*) call_count, 
    sum(duration) total_duration  
    from normalized_cte
    group by person1, person2

-- --

with calls_cte as (
        select caller_id as person_id, duration from Calls 
        union all 
        select callee_id as person_id, duration from Calls
    ),
    person_country_cte as (
        select p.id as person_id,c.name as country from Person p join Country c 
        on substr(p.phone_number,1,3)= c.country_code
    ),
    country_wise_avg_call_duration as (
        select pcc.country, avg(duration) avg_duration 
        from person_country_cte pcc join calls_cte cc
        on pcc.person_id = cc.person_id
        group by pcc.country
    )
    select distinct country from country_wise_avg_call_duration
    where avg_duration > (select avg (duration) from calls_cte)

OR

with calls_cte as (
        select caller_id as person_id, duration from Calls 
        union all 
        select callee_id as person_id, duration from Calls
    ),
    person_country_cte as (
        select p.id as person_id,c.name as country from Person p join Country c 
        on substr(p.phone_number,1,3)= c.country_code
    )
    select pcc.country 
    from person_country_cte pcc join calls_cte cc
    on pcc.person_id = cc.person_id
    group by pcc.country
    having avg(duration) > (select avg (duration) from calls_cte)


-- subqueries======================================================

select 
round(sum(tiv_2016)) as tiv_2016 
from Insurance
where tiv_2015 IN (
    select tiv_2015
    from Insurance 
    group by tiv_2015 
    having count(*) > 1
)
and (lat,lon) IN (
    select lat,lon
    from Insurance 
    group by lat,lon 
    having count(*) =1
)

-- --

with all_ids as (
        select requester_id as id from RequestAccepted
        union all
        select accepter_id as id from RequestAccepted
    )
    select id, count(*) as num 
    from all_ids 
    group by id
    order by num desc
    limit 1

select
id, count(*) as num
from (
        select requester_id as id from RequestAccepted
        union all
        select accepter_id as id from RequestAccepted
    ) all_ids   
group by id
order by num desc
limit 1 

-- --

-- Write your SQL query here

select name as results
from (
    select
        mr.user_id, 
        u.name, 
        count(distinct mr.movie_id) num
    from MovieRating mr join Users u 
    on mr.user_id = u.user_id
    group by mr.user_id, u.name
    order by num desc, u.name asc
    limit 1
)
union all
select title as results
from (
    select
        mr.movie_id, 
        m.title, 
        avg(mr.rating) avg_rating
    from MovieRating mr join Movies m 
    on mr.movie_id = m.movie_id
    where strftime('%Y-%m',mr.created_at)='2020-02'
    group by mr.movie_id, m.title
    order by avg_rating desc, m.title asc
    limit 1
)

-- --
-- inplace changes in result set
select 
    (case
        when id%2 !=0 and id = (select max(id) from Seat) then id  
        when id%2 = 0 then id-1
        when id%2 !=0 then id+1
    end ) as id, 
    student
from Seat 
order by id asc

OR

SELECT 
    id,
    -- buit result set with exchanged ids first i.e. 2nd record will be first
    (SELECT s2.student
     FROM Seat s2
     WHERE s2.id = 
         CASE 
             WHEN s1.id % 2 = 1 AND s1.id + 1 <= (SELECT MAX(id) FROM Seat) THEN s1.id + 1
             WHEN s1.id % 2 = 0 THEN s1.id - 1
             ELSE s1.id
         END
    ) AS student
FROM Seat s1
ORDER BY id;


-- --

select 
distinct employee_id
from 
Employees
where 
manager_id not in ( select distinct employee_id from Employees)
AND
salary <30000
order by employee_id desc

-- --

-- Write your SQL query here

select 
    id,
    name
from Students
where 
department_id not in (select distinct id from Departments)
order by id asc;


-- Problem Solving 1 ======================================================

-- --

with cte_dist_id as (
        select 
            user_id, 
            sum(distance) as total_distance 
        from Rides
        group by user_id
    )
    select 
        u.name, 
        coalesce(di.total_distance, 0) as travelled_distance 
    from Users u  
    left join cte_dist_id di on u.id=di.user_id
    order by di.total_distance desc, u.name asc

OR

SELECT 
    users.name, 
    COALESCE(dista.total_distance, 0) AS travelled_distance
FROM 
    users
LEFT JOIN (
    SELECT 
        user_id, 
        SUM(distance) AS total_distance
    FROM 
        rides
    GROUP BY 
        user_id
) AS dista
ON users.id = dista.user_id
ORDER BY 
    travelled_distance DESC, 
    users.name ASC;





-- ======================================================
-- ======================================================
-- ======================================================

-- ======================================================
-- ======================================================

-- ======================================================
-- ======================================================
-- ======================================================
-- ======================================================

-- ======================================================
