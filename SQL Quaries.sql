-- Project 

use Tenant;

select * from Tenancy_History;

select * from profiles;

select * from Houses;

select * from Addresses;

select * from Referral;

select * from Employment_details;

-- Question 1:
-- Write a query to get Profile ID, Full Name and Contact Number of the tenant who has stayed
-- with us for the longest time period in the past

select top 1 a.profile_id,concat(a.first_name,' ',a.last_name)as Full_Name,a.phone as Contact_Number,
datediff(day,min(b.move_in_date),max(b.move_out_date)) as days
from Profiles as a 
inner join Tenancy_History as b
on a.profile_id=b.profile_id
group by a.profile_id,a.first_name,a.last_name,a.phone
order by days desc;

-- Question 2: 
--Write a query to get the Full name, email id, phone of tenants who are married and paying
--rent > 9000 using subqueries

select concat(first_name,' ',last_name)as Full_Name,a.email_id,a.phone,a.marital_status,b.rent
from Profiles as a
left join Tenancy_History as b
on a.profile_id=b.profile_id
where marital_status='Y' and rent>9000;

-- Question 3:
--Write a query to display profile id, full name, phone, email id, city, house id, move_in_date ,
--move_out date, rent, total number of referrals made, latest employer and the occupational category 
--of all the tenants living in Bangalore or Pune in the time period of jan 2015 to jan 2016 sorted by--their rent in descending order
select distinct a.profile_id,concat(first_name,' ',last_name)as FullName,a.phone,a.email_id,a.city,b.house_id,
b.move_in_date,b.move_out_date,b.rent,count(c.referral_valid)over (Partition by c.profile_id) as total_no_of_referrals,
d.latest_employer,d.occupational_category
from Profiles as a
left join Tenancy_History as b
on a.profile_id=b.profile_id
left join Referral as c
on a.profile_id=c.profile_id
left join Employment_details as d
on a.profile_id=d.profile_id
where city in  ('Bangalore' , 'Pune') and ( convert(date, move_in_date) >= '2015-01-01'
and convert(date, move_in_date) <= '2016-01-01') 
group by a.profile_id,a.first_name,a.last_name,a.phone,a.email_id,a.city,b.house_id,
b.move_in_date,b.move_out_date,b.rent,c.profile_id,c.referral_valid,d.latest_employer,d.occupational_category
order by rent desc

-- Question 4:
--Write a sql snippet to find the full_name, email_id, phone number and referral code of all
--the tenants who have referred more than once.
--Also find the total bonus amount they should receive given that the bonus gets calculated
--only for valid referrals.
select concat(a.first_name,' ',a.last_name) as Full_Name,a.email_id ,a.phone as phone_number,a.referral_code,
b.referral_valid,sum(b.referrer_bonus_amount) as total_bonus
from Profiles as a
inner join Referral as b
on a.profile_id=b.profile_id
where a.profile_id in (
    SELECT profile_id
    FROM Referral
    GROUP BY profile_id	
    HAVING COUNT(*) > 1) and referral_valid=1
group by a.profile_id,a.first_name,a.last_name,a.email_id,a.phone,a.referral_code,b.referral_valid
	
-- Question 5:
--Write a query to find the rent generated from each city and also the total of all cities

SELECT a.city,SUM(b.rent) AS total_rent
FROM Profiles as a
inner join Tenancy_History as b
on a.profile_id=b.profile_id
GROUP BY a.city
WITH ROLLUP;

-- Question 6: 
--Create a view 'vw_tenant' find
--profile_id,rent,move_in_date,house_type,beds_vacant,description and city of tenants who
--shifted on/after 30th april 2015 and are living in houses having vacant beds and its address

create view vw_tenant as select a.profile_id,a.rent,a.move_in_date,b.house_type,b.beds_vacant,
c.description,c.city from Tenancy_History as a 
inner join Houses as b
on a.house_id=b.house_id
inner join Addresses as c
on b.house_id=c.house_id
where move_in_date>='2015-04-30' and beds_vacant>0

select * from vw_tenant;

-- Question 7:
--Write a code to extend the valid_till date for a month of tenants who have referred more
--than one time

select* from Referral;

select distinct Ref_ID,profile_id,
count (profile_id) over (partition by profile_id) as total_referral,valid_from,
dateadd(MONTH,1,valid_till) as extended_month
from Referral
where profile_id in 
(select profile_id from Referral
group by profile_id
having count (Referral.profile_id)>1);

update Referral
set valid_till=DATEADD(month,-1,valid_till)
WHERE profile_id IN (
    SELECT profile_id
    FROM Referral
    GROUP BY profile_id
    HAVING COUNT(*) > 1)
	
-- Question 8:
--Write a query to get Profile ID, Full Name, Contact Number of the tenants along with a new
--column 'Customer Segment' wherein if the tenant pays rent greater than 10000, tenant falls
--in Grade A segment, if rent is between 7500 to 10000, tenant falls in Grade B else in Grade C
select * from Profiles;

select a.profile_id,concat(a.first_name,' ',a.last_name) as FullName,a.phone,b.rent,
case
    when b.rent > 10000 then 'Grade A'
    when b.rent Between 7500 And 10000 then 'Grade B'
    else 'Grade C'
end as Customer_Segment
from Profiles as a
inner join Tenancy_History as b
on a.profile_id=b.profile_id

-- Question 9:
--Write a query to get Fullname, Contact, City and House Details of the tenants who have not
--referred even once

select concat(a.first_name,' ',a.last_name) as FullName,a.phone as Contact,a.city,c.*
from Profiles as a
inner join Tenancy_History as b
on a.profile_id=b.profile_id
left join Houses as c
on b.house_id=c.house_id
left join Referral as d
on a.profile_id=d.profile_id
where d.profile_id is null

-- Question 10:
--Write a query to get the house details of the house having highest occupancy

select a.name,a.description,a.city,a.pincode,b.house_type,b.bhk_type,b.bed_count,b.furnishing_type,b.beds_vacant,b.house_id
from Addresses as a
left join Houses as b
on a.house_id=b.house_id
where bed_count - beds_vacant = (select max(bed_count - beds_vacant) from houses)
