select * from [Portfolio Covid]..['Covid death$']
where continent is not null
order by 3,4

--Data used

select location,date,total_cases,total_deaths,new_cases,population 
from [Portfolio Covid]..['Covid death$']
where continent is not null
order by 1,2

--Understanding the Total Cases & Total Deaths (Shows the likelihood of dying if you contact covid in the country)

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage 
from [Portfolio Covid]..['Covid death$']
--where location like '%America%'
where continent is not null
order by 1,2

--Looking at Total Cases & Population 

select location,date,total_cases,population,(total_cases/population)*100 as Percent_Population_Infected
from [Portfolio Covid]..['Covid death$']
--where location like '%America%'
where continent is not null
order by 1,2

--Looking at Highest infection rate of different Countries

select location,population,max(total_cases) as HighestInfection,max((total_cases/population))*100 as Percent_Population_Infected
from [Portfolio Covid]..['Covid death$']
--where location like '%America%'
where continent is not null
group by location,population
order by Percent_Population_Infected desc

--Showing Highest Death Count per Population

select location,max(cast(total_deaths as int)) as Total_Deaths_Count
from [Portfolio Covid]..['Covid death$']
--where location like '%America%'
where continent is not null
group by location
order by Total_Deaths_Count desc

--Break Down by Continent
--Showing continents with highest death count

select continent,max(total_deaths) as Total_Deaths_Count
from [Portfolio Covid]..['Covid death$']
--where location like '%America%'
where continent is not null
group by continent
order by Total_Deaths_Count desc


--Global Numbers

select sum(new_cases) as Total_cases,sum(new_deaths) as Total_deaths,sum(new_deaths)/sum(new_cases)*100 as Death_Percentage
from [Portfolio Covid]..['Covid death$']
where continent is not null
--Group by date
order by 1,2


--Looking at Total Population and Vaccinations

select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as Population_Vacinated_count 
from [Portfolio Covid]..['Covid death$'] dea
join [Portfolio Covid]..['Covid vacination$'] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--use of CTE
with POPvsVAC (continent, location, date, population,new_vacinations, Population_Vacinated_count)
as(
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as Population_Vacinated_count
from [Portfolio Covid]..['Covid death$'] dea
join [Portfolio Covid]..['Covid vacination$'] vac
 on dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null)
Select *,(Population_Vacinated_count/population)*100 as Population_Vacinated_Count_Percentage  
from POPvsVAC


--Temp Table

Drop table if exists #Percent_Population_Vacinated
create table #Percent_Population_Vacinated
(
countinet nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vacinatios numeric,
Population_Vacinated_count numeric)

insert into #Percent_Population_Vacinated
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as Population_Vacinated_count
from [Portfolio Covid]..['Covid death$'] dea
join [Portfolio Covid]..['Covid vacination$'] vac
 on dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null

Select *,(Population_Vacinated_count/population)*100 as Population_Vacinated_Count_Percentage  
from #Percent_Population_Vacinated


--Creating View to store data for visualization

create view Percent_Population_Vacinated as
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as Population_Vacinated_count
from [Portfolio Covid]..['Covid death$'] dea
join [Portfolio Covid]..['Covid vacination$'] vac
 on dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null

select * from Percent_Population_Vacinated


create view Global_numbers as
select sum(new_cases) as Total_cases,sum(new_deaths) as Total_deaths,sum(new_deaths)/sum(new_cases)*100 as Death_Percentage
from [Portfolio Covid]..['Covid death$']
where continent is not null
--Group by date
--order by 1,2

select * from Global_numbers


create view continents_with_highest_death_count as
select continent,max(total_deaths) as Total_Deaths_Count
from [Portfolio Covid]..['Covid death$']
--where location like '%America%'
where continent is not null
group by continent
--order by Total_Deaths_Count desc

select * from continents_with_highest_death_count


create view Total_Cases_and_Population as 
select location,date,total_cases,population,(total_cases/population)*100 as Percent_Population_Infected
from [Portfolio Covid]..['Covid death$']
--where location like '%America%'
where continent is not null
--order by 1,2

select * from Total_Cases_and_Population


create view Overview_of_Death_percentage as
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage 
from [Portfolio Covid]..['Covid death$']
--where location like '%America%'
where continent is not null
--order by 1,2

select * from Overview_of_Death_percentage