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







-- --

with calls_cte as (
        select 
            caller_id as person_id, 
            duration 
        from Calls 
        union all 
        select 
            callee_id as person_id, 
            duration 
        from Calls
    ),
    person_country_cte as (
        select 
            p.id as person_id,
            c.name as country 
        from Person p join Country c 
        on substr(p.phone_number,1,3)= c.country_code
    )
    select 
        pcc.country 
    from person_country_cte pcc join calls_cte cc
    on pcc.person_id = cc.person_id
    group by pcc.country
    having avg(duration) > (select avg (duration) from calls_cte)







-- --

-- Write your SQL query here

with cte_june as (
        select 
            customer_id,sum (o.quantity*p.price) total_june_spend
        from Orders o join Product p 
        on o.product_id = p.product_id
        where strftime('%Y',order_date) = '2020' 
            and strftime('%m', order_date) ='06' 
        group by customer_id
    ),
    cte_july as (
        select 
            customer_id,sum (o.quantity*p.price) total_july_spend
        from Orders o join Product p 
        on o.product_id = p.product_id
        where strftime('%Y',order_date) = '2020' 
            and strftime('%m', order_date) ='07' 
        group by customer_id
    ),
    cte_required_cust as (
        select 
        * 
        from cte_june cjn join cte_july cjl 
        on cjn.customer_id=cjl.customer_id
        where cjn.total_june_spend>=100 and cjl.total_july_spend>=100
    )
    select
        customer_id,name
    from customers 
    where customer_id in (select distinct customer_id from cte_required_cust )
    order by customer_id asc

OR

select 
    customer_id, name
from customers
where customer_id in (
    select
        customer_id
    from Orders o join Product p 
    on o.product_id = p.product_id
    where order_date between '2020-01-01' and '2020-12-31'
    group by customer_id
    having 
        sum (
            case 
                when order_date between '2020-06-01' and '2020-06-30'
                then o.quantity * p.price
                else 0
            END
         ) >=100
         and 
         sum (
            case
                when order_date between '2020-07-01' and '2020-07-31'
                then o.quantity * p.price
                else 0
            end 
         )>=100
)
order by customer_id asc







-- --

-- Write your SQL query here

select distinct account_id
from (
    select 
        li1.account_id
        -- li1.account_id, li1.login login1, li2.login login2
    from LogInfo li1 join LogInfo li2
    on li1.account_id = li2.account_id
        and li1.ip_address != li2.ip_address
        and li1.login <=li2.logout
        and li2.login <=li1.logout
) a
 

 OR

-- Write your SQL query here

select distinct account_id
from (
    select 
        li1.account_id
        -- li1.account_id, li1.login login1, li2.login login2
    from LogInfo li1 join LogInfo li2
    on li1.account_id = li2.account_id
        and li1.ip_address <> li2.ip_address
        and li1.login <=li2.logout
        and li2.login <=li1.logout
) a





-- --

-- Write your SQL query here

select p.player_id,
    p.player_name,
    count(p.player_id) as grand_slams_count
from ( 
    select Wimbledon as id from Championships
    union all
    select Fr_open as id from Championships
    union all
    select US_open as id from Championships
    union all 
    select Au_open as id from Championships
) c join Players p on c.id= p.player_id
group by p.player_id 
order by p.player_id asc
 






-- Advance String Functions | Regex and Clause ======================================================

select 
    p.product_name, 
    sum (o.unit ) as unit
from Products p join Orders o 
on p.product_id = o.product_id
where strftime('%Y', o.order_date) ='2020'
    and strftime ('%m', o.order_date) = '02'
group by p.product_name 
having sum (o.unit)>=100
order by p.product_name desc

OR

SELECT 
    p.product_name, 
    SUM(o.unit) AS unit
FROM 
    Products p
JOIN 
    Orders o 
    ON p.product_id = o.product_id
WHERE 
    o.order_date LIKE '2020-02-%'
GROUP BY 
    p.product_id
HAVING 
    SUM(o.unit) >= 100
ORDER BY 
    unit DESC, product_name DESC;





-- --

-- Write your SQL query here

select 
    sell_date, 
    count(distinct product) as num_sold,
    group_concat(distinct product ) as products
from (
    select * 
    from Activities 
    order by sell_date asc, product asc 
) a
group by sell_date 
order by sell_date






-- --

-- Write your SQL query here

select * from Patients
where conditions like '%DIAB1%'
order by patient_id asc





-- --

-- Write your SQL query here

select 
    Name  
from 
    students
where
    Marks>75
order by 
    substr(Name,-3) asc, 
    id asc






-- -- 

-- Write your SQL query here

select
    CITY
from STATION
where
    lower(substr(CITY,1,1)) not in ('a', 'e','i','o','u')
    OR
    lower(substr(CITY,-1)) not in ('a', 'e','i','o','u') 







-- --

-- Write your SQL query here

select
    CITY
from STATION
where
    lower(substr(CITY,1,1)) not in ('a', 'e','i','o','u')
    AND
    lower(substr(CITY,-1)) not in ('a', 'e','i','o','u') 








-- Window Functions 1 ======================================================


with cte_rank as (
        select 
            *,
            sum(weight) over (order by turn asc) as moving_sum
        from Queue
    )
    select 
        person_name
    from cte_rank 
    where 
        moving_sum <=1000 
    order by 
        moving_sum desc
    limit 1

OR

SELECT person_name
FROM (
    SELECT person_name,
           SUM(weight) OVER (ORDER BY turn) AS moving_sum
    FROM Queue
) AS tb
WHERE moving_sum <= 1000
ORDER BY moving_sum DESC
LIMIT 1;








-- -- 

-- 7 day movign average - Rows between | Range between | row_number


-- Write your SQL query here

with cte_total_single_day as (
        select 
            visited_on, 
            sum (amount) as total_single_day
        from 
            Customer
        group by 
            visited_on
    ),
    cte_seven_day_window_total as (
        select
            visited_on,
            sum (total_single_day) over ( 
                    order by visited_on
                    rows between 6 preceding and current row 
                ) as amount,
            avg (total_single_day) over (
                    order by visited_on
                    rows between 6 preceding and current row
                ) as avg_amount,
            count(*) over (
                    order by visited_on
                    rows between 6 preceding and current row 
                ) as total_days
        from 
            cte_total_single_day
    )
    select 
        visited_on,
        amount,
        round(avg_amount, 2) as average_amount
    from 
        cte_seven_day_window_total
    where 
        total_days=7
    order by 
        visited_on asc


OR 
-- mySQL

WITH cte_total_single_day AS (
    SELECT 
        visited_on, 
        SUM(amount) AS total_single_day
    FROM Customer
    GROUP BY visited_on
),
cte_seven_day_window_total AS (
    SELECT
        visited_on,

        SUM(total_single_day) OVER (
            ORDER BY visited_on
            RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW
        ) AS amount,

        avg(total_single_day) OVER (
            ORDER BY visited_on
            RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW
        ) AS average_amount,

        COUNT(*) OVER (
            ORDER BY visited_on
            RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW
        ) AS total_days

    FROM cte_total_single_day
)
SELECT 
    visited_on,
    amount,
    ROUND(average_amount, 2) AS average_amount
FROM cte_seven_day_window_total
WHERE total_days = 7
ORDER BY visited_on;


OR

-- need 7 day window even if some dates are missing

with cte_single_day_total as (
        select 
            visited_on,
            sum(amount) as single_day_amount
        from 
            Customer
        group by 
            visited_on
    )
    select 
        c1.visited_on,
        sum (c2.single_day_amount) as amount,
        round (avg (c2.single_day_amount),2) as average_amount
    from 
        cte_single_day_total c1 join cte_single_day_total c2
    on 
        c2.visited_on 
            between date(c1.visited_on, '-6 DAY') and c1.visited_on
    group by 
        c1.visited_on
    having 
        count(c1.visited_on)=7
    order by 
        c1.visited_on


OR

-- with some dates missing will be included in window, need calender based 7 day window**

with cte_single_day_total as (
        select 
            visited_on,
            sum(amount) as single_day_amount
        from 
            Customer
        group by 
            visited_on
    )
    select 
        c1.visited_on,
        sum (c2.single_day_amount) as amount,
        round (avg (c2.single_day_amount),2) as average_amount
    from 
        cte_single_day_total c1 join cte_single_day_total c2
    on 
        c2.visited_on 
            between date(c1.visited_on, '-6 DAY') and c1.visited_on
    group by 
        c1.visited_on
    order by 
        c1.visited_on






-- -- 

-- Write your SQL query here

with cte_department_wise_salary_rank as (
        select
            *,
            dense_rank() 
            over (partition by departmentId order by salary desc) as d_rank_salary
        from 
          Employee
    )
    select 
        d.name as Department,
        c1.name as Employee,
        c1.salary as Salary
    from Department d join cte_department_wise_salary_rank c1
    on 
        d.id=c1.departmentId    
    where 
        d_rank_salary in (1,2,3)
    Order by 
        d.id asc,
        c1.salary desc,
        c1.id asc        

OR

WITH RankedSalaries AS (
    SELECT
        d.name AS Department,
        e.name AS Employee,
        e.salary AS Salary,
        DENSE_RANK() OVER (
            PARTITION BY e.departmentId
            ORDER BY e.salary DESC
        ) AS salary_rank
    FROM
        Employee e
    JOIN
        Department d
    ON
        e.departmentId = d.id
)
SELECT
    Department,
    Employee,
    Salary
FROM
    RankedSalaries
WHERE
    salary_rank <= 3
ORDER BY
    Department,
    Salary DESC,
    Employee;




-- --

-- IFNULL() function

with cte_salary_ranking as (
        select
            *,
            dense_rank() over (order by salary desc) as rn 
        from 
            Employee
    )
    select
        IFNULL ((
            select 
                distinct salary 
            from 
                cte_salary_ranking
            where rn=2
        ), NULL) as SecondHighestSalary





-- --

-- using dense_rank()

with cte_grading as (
    select
        *,
        dense_rank () over (
                partition by student_id 
                order by grade desc, course_id asc 
            ) as rn    
    from
        Enrollments 
    )
    select 
        student_id, course_id, grade
    from 
        cte_grading
    where rn=1
    order by 
        student_id asc


OR

-- using rank() 

WITH cte AS (
    SELECT 
        student_id,
        course_id,
        grade,
        RANK() OVER (
            PARTITION BY student_id 
            ORDER BY grade DESC, course_id
        ) AS rnk
    FROM Enrollments
)
SELECT 
    student_id,
    course_id,
    grade
FROM cte
WHERE rnk = 1;







-- Window Functions 2 ======================================================

with cte_product_ranking as (
        select
            p.product_name, 
            p.product_id, 
            o.order_id,
            o.order_date,
            dense_rank() over (
                    partition by p.product_name, p.product_id
                    order by order_date desc
                ) as rn 
        from 
            Orders o join Products p
        on 
            o.product_id = p.product_id
    )
    select 
        product_name, 
        product_id, 
        order_id,
        order_date
    from 
        cte_product_ranking
    where rn=1
    order by 
        product_name asc,
        product_id asc,
        order_id asc

OR

SELECT product_name, product_id, order_id, order_date
FROM (
    SELECT product_name, P.product_id, order_id, order_date, RANK() OVER (PARTITION BY product_name ORDER BY order_date DESC) rnk
    FROM Orders O
    JOIN Products P
    On O.product_id = P.product_id
) temp
WHERE rnk = 1
ORDER BY product_name, product_id, order_id




-- --

-- Write your SQL query here

with cte_group_ids_by_ranking as (
        select 
            log_id,
            log_id - rank() over(order by log_id) as rn
        from 
            Logs
    )
    select 
        min(log_id) as start_id, 
        max(log_id) as end_id
    from 
        cte_group_ids_by_ranking
    group by 
        rn 
    order by 
        start_id





-- --

-- Write your SQL query here

with cte_window_of_days_between_dates as (
        select
            *,
            lead(visit_date,1,'2021-01-01') over (
                    partition by user_id 
                    order by visit_date asc
                ) as next_date
        from 
        user_visits 
    )
    select 
        user_id,
        max(julianday(next_date) - julianday(visit_date)) as biggest_window 
    from 
        cte_window_of_days_between_dates
    group by 
        user_id
    order by 
        user_id

OR

WITH cte AS (
  SELECT 
    user_id, 
    visit_date,
    LEAD(visit_date, 1) OVER (
      PARTITION BY user_id 
      ORDER BY visit_date
    ) AS next_visit
  FROM user_visits
),
cte2 AS (
  SELECT 
    user_id,
    visit_date,
    COALESCE(next_visit, '2021-01-01') AS dt
  FROM cte
)
SELECT 
  user_id, 
  MAX(julianday(dt) - julianday(visit_date)) AS biggest_window
FROM cte2
GROUP BY user_id
ORDER BY user_id;






-- --


-- Write your SQL query here

with cte_next_row_values as (
        select 
            *,
            lead(sold_num) over (
                    partition by sale_date
                    order by fruit
                ) next_row_value,
            count (*) over (
                    partition by sale_date
                ) as fruit_count 
        from 
            Sales
    )
    select 
        sale_date,
        ( sold_num -next_row_value ) as diff
    from 
        cte_next_row_values
    where 
        next_row_value is not null
        and fruit_count=2
    order by 
        sale_date asc

OR

WITH ranked_sales AS (
  SELECT
    sale_date,
    fruit,
    sold_num,
    COUNT(*) OVER (PARTITION BY sale_date) AS fruit_count,
    LAG(sold_num) OVER (PARTITION BY sale_date ORDER BY fruit) AS prev_sold_num
  FROM Sales
),
diffs AS (
  SELECT
    sale_date,
    CASE
      WHEN fruit = 'oranges' THEN prev_sold_num - sold_num
      ELSE NULL
    END AS diff
  FROM ranked_sales
  WHERE fruit_count = 2
)
SELECT sale_date, diff
FROM diffs
WHERE diff IS NOT NULL
ORDER BY sale_date;




-- --

-- Write your SQL query here
with cte_consecutive_seats as (
        select
            *,
            lead(free) over (
                    order by seat_id
                ) as next_free,
            lag (free) over (
                    order by seat_id
                ) as prev_free
        from 
            Cinema
    )
    select 
        seat_id
    from 
        cte_consecutive_seats
    where 
        free=1 and (next_free=1 or prev_free=1)
    order by seat_id







-- Recusive CTE's ======================================================

-- Write your SQL query here

with cte_at_least_1_exam as (
        select 
            student_id
        from 
            Exam
        group by 
            student_id
        having 
            count(*)>=1 
    ),
    cte_max_or_min_exam_score as (
        select 
            exam_id,
            min (score) as min_score,
            max(score) as max_score
        from 
            Exam 
        group by 
            exam_id
    )
    select 
        * 
    from 
        Student 
    where student_id not in (
            select distinct student_id 
            from 
                cte_max_or_min_exam_score c2 join Exam e 
                on e.exam_id = c2.exam_id
            where score=min_score or score=max_score
        )
        and 
            student_id in (
                select 
                    student_id 
                from cte_at_least_1_exam
            )
    order by 
        student_id asc  

OR

with cte_min_max_ranking_on_exam as (
        select 
            s.student_id,
            s.student_name,
            e.exam_id,
            dense_rank() over (
                    partition by exam_id
                    order by score asc
                ) as min_score_rn,
            dense_rank() over (
                    partition by exam_id
                    order by score desc     
                )   as max_score_rn
        from Student s join Exam e 
        on s.student_id = e.student_id
    )
    select distinct c1.student_id,c1.student_name 
    from 
        cte_min_max_ranking_on_exam c1 
    where student_id 
        not in (
            select 
                distinct student_id 
            from 
                cte_min_max_ranking_on_exam
            where max_score_rn=1 or min_score_rn=1
        )
    order by c1.student_id asc





-- -- 

-- Write your SQL query here
with cte_ordered_success_and_failed_dates_with_status as (
        select 
            success_date as dt,
            'succeeded' as status,
            dense_rank() over(order by success_date) as rn
        from Succeeded
        union all
        select 
            fail_date as dt, 
            'failed' as status,
            dense_rank() over(order by fail_date) as rn
        from Failed
    ),
    cte_date_grouping_logic as (
        select 
            *, 
            date(dt,'-' || rn || ' days')  grouping_date
        from 
            cte_ordered_success_and_failed_dates_with_status
        where dt 
                between '2019-01-01' and '2019-12-31'
        order by dt
    )
    select 
        status as period_state, 
        start_date,
        end_date 
    from (
        select 
            grouping_date,
            status,
            min(dt) as start_date,
            max(dt) as end_date
        from 
            cte_date_grouping_logic
        group by 
            grouping_date,
            status
    )
    order by start_date

OR

WITH r AS (
    SELECT 
        fail_date AS date, 
        'failed' AS period_state,
        RANK() OVER (ORDER BY fail_date ASC) AS rk
    FROM failed
    WHERE fail_date BETWEEN '2019-01-01' AND '2019-12-31'

    UNION ALL

    SELECT 
        success_date AS date, 
        'succeeded' AS period_state,
        RANK() OVER (ORDER BY success_date ASC) AS rk
    FROM succeeded
    WHERE success_date BETWEEN '2019-01-01' AND '2019-12-31'
)

SELECT 
    period_state, 
    MIN(date) AS start_date, 
    MAX(date) AS end_date
FROM r
GROUP BY 
    period_state, 
    -- magic logic
    date(date, '-' || rk || ' days')
ORDER BY 
    start_date;





-- --

-- Write your SQL query here

with recursive cte_reporting_employees as (
        select 
            employee_id, 1 as level
        from 
            Employees 
        where manager_id = 1 and employee_id != 1
        union all 
        select 
            e.employee_id, c1.level+1
        from 
            cte_reporting_employees c1 join Employees e
            on 
                c1.employee_id = e.manager_id
        where c1.level <3
    )
    select 
        employee_id 
    from 
        cte_reporting_employees
    order by 
        employee_id asc





-- --

-- Write your SQL query here

with recursive cte_sequence_till_21 as (
        SELECT 1 AS num
        UNION ALL
        SELECT num + 1 
        FROM cte_sequence_till_21
        WHERE num <= 20
    ),
    cte_subtask_sequence_till_max_subtask_count as (
        select 
            task_id, 
            num as subtask_id
        from 
            cte_sequence_till_21 join Tasks
        where 
            num <=subtasks_count
        order by 
            task_id asc
    )
    select 
        * 
    from 
        cte_subtask_sequence_till_max_subtask_count c2 
    where 
        (task_id,subtask_id) not in (
            select
                task_id, 
                subtask_id 
            from 
                Executed        
        )
    order by 
        task_id asc,
        subtask_id asc




-- ======================================================

-- ======================================================
-- ======================================================
-- ======================================================
-- ======================================================

-- ======================================================
