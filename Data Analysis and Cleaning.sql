use [Lungs Cancer]

select *
from lung_cancer

/* 
First look at the null values in these columns
*/
select *
from lung_cancer
where pid is null or age is null or gender is null or smoker is null
--There is no null value in these 5 columns

select *
from lung_cancer
where days_to_cancer is null
--In these two columns days_to_cancer and stage_of_cancer so carry these with null values

/*
Now let's convert stage_of_cacer into full form
*/
select distinct(stage_of_cancer)
from lung_cancer

--Now lets make case and enter these values
select stage_of_cancer,
case 
	when stage_of_cancer='IA' then 'First Stage'
	when stage_of_cancer='IB' then 'First Stage'
	when stage_of_cancer='IIA' then 'Second Stage'
	when stage_of_cancer='IIB' then 'Second Stage'
	when stage_of_cancer='IIIA' then 'Third Stage'
	when stage_of_cancer='IIIB' then 'Third Stage'
	when stage_of_cancer='IV' then 'Last Stage'
	else stage_of_cancer
	end as Stage_of_Cancer
from lung_cancer

--Now update the values
update lung_cancer
set stage_of_cancer=case 
	when stage_of_cancer='IA' then 'First Stage'
	when stage_of_cancer='IB' then 'First Stage'
	when stage_of_cancer='IIA' then 'Second Stage'
	when stage_of_cancer='IIB' then 'Second Stage'
	when stage_of_cancer='IIIA' then 'Third Stage'
	when stage_of_cancer='IIIB' then 'Third Stage'
	when stage_of_cancer='IV' then 'Last Stage'
	else stage_of_cancer
	end

--Check again the unique values for any error
select distinct(stage_of_cancer)
from lung_cancer


--Now let's check all the unique values from all columns for any miscalculation
select distinct(gender)
from lung_cancer

select distinct(race)
from lung_cancer

select distinct(smoker)
from lung_cancer

--In race column there is a value that is showing N/A that means there are some null values exist
select *
from lung_cancer
where race= 'N/A'
--There are 261 values are that are N/A

				--Analysis--

--In which age mostly people has cancer due to smoke

select age,count(gender) as Total_Cases
from lung_cancer
group by age
order by Total_Cases desc
--People between age 55 to 64 are more common for cancer

--Which gender has more cancer patients

select gender,count(gender) as Total_Cases 
from lung_cancer
group by gender
order by Total_Cases desc
--Men is the gender with more patients with 31517 rather than women who are 21910

--what is the percentage of race has more patients

--Let's do this by using Temp Table
create table #RacePercentage(
Race varchar(100),
NumberOfPatients bigint,)

--Insert the values into Temp Table
insert into #RacePercentage
select race,count(race) as NumberOfPatients
from lung_cancer
group by race

--Now apply the logic
select Race,NumberOfPatients,(cast(NumberOfPatients as float)/53427)*100 as PercentageOfPatients
from #RacePercentage
where race!='N/A'
order by PercentageOfPatients desc
--So white people are more in cancer

--What is the percentage and number of people are currently smoker and non-smoker
select smoker,count(smoker) as Numbers,(cast(count(smoker) as float)/53427)*100 as Percentage
from lung_cancer
group by smoker
order by Percentage
--Here almost 52% people left smoking and only 48% people are currently smoker


/*
On which stage mostly people are and with age
*/

select stage_of_cancer,age,count(stage_of_cancer) as Total_Number
from lung_cancer
where stage_of_cancer is not null
group by age,stage_of_cancer
order by Total_Number desc
--Here most of the people are on first stage at the age of 64 with 59 cases

/*
What is the average days they spend and reached at which stage
*/

select stage_of_cancer,avg(cast(days_to_cancer as int)) as AverageDays
from lung_cancer
where stage_of_cancer is not null
group by stage_of_cancer
order by AverageDays desc
/*
Almost after 1247 average people are at stage Last
After 1032 days mostly people are at third stage, while second stage is cloose to this with 1028 days
Only 915 after smoking detected.
*/


select distinct(days_to_cancer)
from lung_cancer
where days_to_cancer is not null
order by days_to_cancer asc


/*
Which gender and race have more risk of life according to the stage of cancer
*/

select race,gender,stage_of_cancer
from lung_cancer
where stage_of_cancer is not null and race !='N/A'
group by race,gender,stage_of_cancer
order by race


/*
Top 10 ages whose are currently spending more time in cancer
*/

select Top 10 age,avg(cast(days_to_cancer as int)) as AverageDays
from lung_cancer
where days_to_cancer is not null
group by age
order by AverageDays desc
--Age 69 are more to spend time as an cancer patients 

/*
what are the races who don't left smoking even after got cancer and what are the races left.
*/
select race,count(smoker) as CurrentSmoker
from lung_cancer
where smoker='Current' and race!='N/A'
group by race
order by CurrentSmoker desc
--Former
select race,count(smoker) as FormerSmoker
from lung_cancer
where smoker='Former' and race!='N/A'
group by race
order by FormerSmoker desc