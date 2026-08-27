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



-- ======================================================
