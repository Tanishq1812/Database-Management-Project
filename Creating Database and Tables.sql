-- Project

-- Creating a database - 'Tenant'

create database Tenants;

use Tenants;

-- Creating a table - 'Tenancy_histories'
create table Tenancy_histories(
id int primary key,
profile_id int not null,
house_id int not null,
move_in_date date not null,
move_out_date date ,
rent int not null,
bed_type varchar(255) ,
move_out_reason varchar(255))

-- Creating a table - 'Profiles'
create table Profiles(
profile_id int primary key,
first_name varchar(255) ,
last_name varchar(255),
email varchar(255) not null,
phone varchar(255) not null,
city varchar(255),
pan_card varchar(255) ,
created_at date not null,
gender varchar(255) not null,
referral_code varchar(255),
marital_status varchar(255))

-- Creating a table - 'Houses'
create table Houses(
house_id int primary key,
house_type varchar(255),
bhk_details varchar(255),
bed_count int not null,
furnishing_type varchar(255),
Beds_vacant int not null)

--Creating a table - 'Addresses'
create table Addresses(
ad_id int primary key,
name varchar(255),
description text,
pincode int,
city varchar(255),
house_id int not null)

-- Creating a table - 'Referrals'
create table Referrals(
ref_id int primary key,
profile_id int not null,
referrer_bonus_amount float ,
referral_valid tinyint,
valid_from date,
valid_till date)

-- Creating a table - 'Employment_detail'
create table Employment_detail(
id int primary key,
profile_id int not null,
latest_employer varchar(255),
official_mail_id varchar(255) ,
yrs_experience int,
Occupational_category varchar(255))

-- Adding Constraint as Foreign key in table Tenancy_histories 
--for profile_id with reference profile_id in Profiles
alter table Tenancy_Histories
add constraint fk_profile_id
Foreign key (Profile_id)
References Profiles(profile_id);

-- Adding constraint as foreign key in table Tenancy_histories
-- for house_id with reference house_id in Houses
alter table Tenancy_Histories
add constraint fk_house_id
Foreign key (house_id)
References Houses(house_id);

-- Adding constriant as foreign key in table Addresses
-- for house_id with reference house_id in Houses
alter table Addresses
add constraint fk_house_id_Addresses
Foreign key (house_id)
References Houses(house_id);

-- Adding constraint as foreign key in table Referral 
-- for profile_id with reference profile_id in Profiles
alter table Referrals
add constraint fk_profile_id_Referral
Foreign key (profile_id)
References Profiles(profile_id);

-- Adding constraint as foreign key in table Employment_detail
-- for profile_id with reference profile_id in Profiles
alter table Employment_detail
add constraint fk_profile_id_emp_detail
Foreign key (profile_id)
References Profiles(profile_id);
