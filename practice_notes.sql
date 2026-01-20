--HARINI NOTES----

select * from employee_demographics;

select first_name,age,age+(10*100),birth_date
from parks_and_recreation.employee_demographics;

Insert into employee_demographics values(16,'Harini','sri',21,'Female','2004-12-26');

select* from employee_demographics;


select * from employee_demographics 
where first_name = 'Harini';


select * from employee_demographics 
where first_name  like '%i';


select * from employee_demographics
order by age desc
limit 1,1
;

--aliasing--
select gender , avg(age) as Average
from employee_demographics
group by gender
having Average < 40;

--Joins--
select * from employee_demographics;
select * from employee_salary;


select * from employee_demographics inner join
employee_salary on employee_demographics.employee_id = employee_salary.employee_id;
--skipped the record of employee id '2,16'--;

--alaising and join --;

select dem.employee_id , age, occupation 
from employee_demographics as dem
inner join employee_salary as sal
on dem.employee_id = sal.employee_id;

-- Outer join

select *
from employee_demographics as dem
left outer join employee_salary as sal
on dem.employee_id = sal.employee_id;

-- Self join

select emp1.employee_id as emp_santa,
emp1.first_name as first_name_santa,
emp1.last_name as last_name_santa,
emp2.employee_id  emp_name,
emp2.first_name as first_name_emp,
emp2.last_name as last_name_emp
 from employee_demographics emp1
join employee_salary emp2 on 
emp1.employee_id + 1 = emp2.employee_id;


-- Joining multiple joins 
select *
from employee_demographics as dem
	inner join employee_salary as sal
	on dem.employee_id = sal.employee_id 
	inner join parks_departments par
    on sal.dept_id = par.department_id;
	

Insert into  employee_salary values(16,'Harini','sri','data analyst',76000,1);



-- Union 
select first_name , last_name , 'young man' as Label
 from employee_demographics
 where age <25 and gender = 'male'
union 
select first_name , last_name , 'young lady' as Label
 from employee_demographics
 where age < 25 and gender = 'female'
union
select first_name,last_name , 'Highly paid needs bonus' as Label
from employee_salary
where salary > 70000
order by first_name asc;

-- String functions 

select length('harini');
select upper('harini');
select lower('HARini');
select trim('           hari   ');
select ltrim('               hari');
select rtrim('harini        ');
select locate('i','harini');

select first_name,last_name,
concat(first_name,' ',last_name) as full_name
from employee_demographics; 

select first_name,last_name,
substring(first_name,2,2),
replace(first_name,'ni','.')
from employee_demographics;

select first_name,last_name,age,
case
	when age <= 30 then 'young'
    when age between 30 and 50 then 'old'
    when age >= 50 then 'gods favorite'
end as age_metrics
from employee_demographics;


-- pay increase and bonus
-- <= 50000 -> 5 % bonus
-- > 50000 -> 7 % bonus
-- finance dept -> 10% bonus

select first_name,last_name,salary,
case
	when salary <= 50000 then salary + (salary*0.05)
    when salary > 50000 then salary *1.07
    when dept_id = 6 then salary* 1.10
end as BONUS
from employee_salary
order by first_name,last_name;


-- Sub query

select * from employee_demographics 
where employee_id IN 
					( select employee_id 
						from employee_salary
						where dept_id = 1)
;

select employee_id from employee_salary
where dept_id = 1;

select gender,  avg(avg_age) as AVERAGE from
(select gender , avg(age) as avg_age,max(age) as max_age, min(age),count(age)
from employee_demographics
group by gender) as Agg_table
group by gender
;

-- group by clause
select gender,avg(salary)
from employee_demographics dem
join employee_salary as sal
on dem.employee_id = sal.employee_id
group by gender;

-- window functions

select dem.first_name,dem.last_name,gender,sum(salary) over(partition by gender order by dem.first_name ) 
as rolling_total
from employee_demographics dem
join employee_salary as sal
on dem.employee_id = sal.employee_id
;

-- window ROW_NUMBER() , RANK() , DENSE_RANK()

select dem.first_name,dem.last_name,gender,salary,
ROW_NUMBER() OVER(partition by gender order by salary desc) as row_num,
Rank() OVER(partition by gender order by salary desc) as rank_num,
 dense_rank() over(partition by gender order by salary desc) as denserank_num
from employee_demographics dem
join employee_salary as sal
on dem.employee_id = sal.employee_id;


-- CTES -> common table expression

with CTE_ex (Gender,Avg_sal,Max_sal,Min_sal,Count) AS
(
select gender , avg(salary) , max(salary) , min(salary),count(salary)
from employee_demographics dem
join employee_salary sal
on dem.employee_id = sal.employee_id
group by gender
)
select * from 
CTE_ex
;

-- another way to join

with cte1 as 
(
select employee_id,first_name,gender
from employee_demographics
where  first_name like '%a%'
),
cte2 as
(
select employee_id,salary
from employee_salary
where salary > 50000

)
select * from cte1 join cte2 on 
cte1.employee_id = cte2.employee_id 
;

-- temporary table
CREATE temporary TABLE temp_table(
name varchar(50),
age int,
fav_actors varchar(100)
);
insert into temp_table
values
('srini',50,'ajith'),
('rani',40,'surya'),
('thili',25,'vijay'),
('harini',20,'kamal'),
('amsu',55,'rajini');

select * from temp_table;

create temporary table salary_over_50k
select * from employee_salary
where salary > 50000;

select * from salary_over_50k;

-- stored procedures

DELIMITER $$
create procedure large_salaries()
begin
	select * from employee_salary
    where salary > 50000;
    select * from employee_demographics
    where first_name like '%a%';
END $$
DELIMITER ;

call large_salaries();

-- parameters 

DELIMITER $$
create procedure Find_sal_using_id(p_employee_id int)
begin
	select * from employee_salary
    where employee_id = p_employee_id;
END $$
DELIMITER ;

call Find_sal_using_id(1);









