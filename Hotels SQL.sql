--Creating a Temp Table and Converting data into one Table
drop table if exists Hotels
select * into Hotels from [Portfolio Hotel]..Data_of_2018
union
select * from [Portfolio Hotel]..Data_of_2019
union
select * from [Portfolio Hotel]..Data_of_2020

--Joining the Market_segement and Meal_cost table to Temp Table
select * from Hotels
left join [Portfolio Hotel]..market_segment$ on Hotels.market_segment = market_segment$.market_segment
left join [Portfolio Hotel]..meal_cost$ on Hotels.meal = meal_cost$.meal

--Looking in the Market_segment and Meal_cost Data
select * from [Portfolio Hotel]..market_segment$
select * from [Portfolio Hotel]..meal_cost$

-- Looking in to Temp Table Data
select * from Hotels
order by arrival_date_year

--Looking at Total_Revenue by grouping it by arrival_date_year and Type of Hotels
select arrival_date_year,hotel,round(sum((stays_in_week_nights+stays_in_weekend_nights)*adr),2) as revenue
from Hotels
group by arrival_date_year,hotel
order by 1,2


select required_car_parking_spaces/(stays_in_week_nights+stays_in_weekend_nights)*100 as Parking_Percentage
from Hotels