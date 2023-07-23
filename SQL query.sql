--creating table

create table project 
( pregnancies int not null,
 glucose int not null,
 blood_pressure int not null,
 skin_thickness int not null,
 insulin int not null,
 bmi numeric(3,1),
 diabetes_pedigree_function numeric(4,3),
 age int not null,
 outcome varchar(20)
)

select * from project

--No of women that are diabetic
SELECT
COUNT(*)
FROM project
WHERE outcome = 'Diabetic'; 

--No. of women that are not diabetic
SELECT 
COUNT(*)
FROM diabetes
WHERE outcome = 'Non-Diabetic';

--creating new table with some extra cloumns
create table diabetes_prediction_in_woman as (
select pregnancies as no_of_times_pregnant,
insulin,
skin_thickness,
diabetes_pedigree_function as family_history,
age,
glucose,
outcome,
blood_pressure,	
	CASE WHEN blood_pressure < 80 THEN 'normal'
          WHEN blood_pressure BETWEEN 80 AND 89 THEN 'stage_1_hypertension'
		  WHEN blood_pressure BETWEEN 90 AND 120 THEN 'stage_2_hypertension'
		  WHEN blood_pressure >= 120 THEN 'hypertensive_crisis'
	END AS diastolic_blood_pressure,
    
	CASE WHEN age BETWEEN 21 AND 49 THEN 'reproductive_age'
         WHEN age BETWEEN 50 AND 70 THEN 'non_reproductive_age'
	END AS age_range,
    
    CASE WHEN bmi < 18.5 THEN 'underweight'
         WHEN bmi BETWEEN 18.5 AND 24.9 THEN 'normal'
         WHEN bmi BETWEEN 25.0 AND 29.9 THEN 'overweight'
         WHEN bmi >= 30 THEN 'obese' 
    END AS body_mass_index
from project);
         
select * from diabetes_prediction_in_woman



--What is the highest number of times a woman got pregnant and the glucose level
  SELECT max (No_of_times_pregnant), 
  glucose AS glucose_level
  FROM diabetes_prediction_in_woman
  group by 2
  order by 1 desc

--the relationship between age_range and diabetes
SELECT COUNT(outcome) AS Diabetes, age_range
FROM diabetes_prediction_in_woman
WHERE outcome = 'Diabetic'
GROUP BY 2;  

--the relationship between blood pressure  and diabetes

select diastolic_blood_pressure , count(outcome) as diabetes
from diabetes_prediction_in_woman
group by 1
order by 2 desc

--the relationship between the body mass index and diabetes

select body_mass_index, count(outcome) as diabetes
from diabetes_prediction_in_woman
group by 1
order by 2 desc

--Does a number of times a woman gets pregnant affect her glucose level and make her prone to being diabetic?

select 
case when no_of_times_pregnant between 0 and 5 then '0-5'
when no_of_times_pregnant between 6 and 10 then '6-10'
when no_of_times_pregnant between 11 and 15 then '11-15'
else '16 and above' 
end as no_of_times_pregnant,
round(avg(glucose),2) as glucose_level
from diabetes_prediction_in_woman
group by 1,2




