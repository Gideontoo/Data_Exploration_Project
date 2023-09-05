--SQL SCRIPT TO CONDUCT EXPLORATION FOR DATA ON COVID 19
--VIEWS WERE CREATED FOR VISUALIZATION PURPOSES 



select location, date, new_cases,total_cases, total_deaths, population
from CovidDeaths

--overview of the table
select *
from CovidDeaths

--knowing the data types for available data
execute sp_help 'CovidDeaths'


--Data exploration
--Looking at total deaths againts total cases at a given time per country

select location, CAST([date] as date) cast_date,total_cases, total_deaths, 
round((cast(total_deaths as decimal (10,2))/total_cases * 100),2) as total_deaths_against_cases
from CovidDeaths
where [location] not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )

--creating view for total deaths against total cases per country
create view vw_total_deaths_against_cases
as
select location, CAST([date] as date) cast_date,total_cases, total_deaths, 
round((cast(total_deaths as decimal (10,2))/total_cases * 100),2) as total_deaths_against_cases
from CovidDeaths
where [location] not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )


--confirming view created
select *
from vw_total_deaths_against_cases


--looking at total cases against population per country
select [location], CAST([date] as date) as cast_date, total_cases, population, 
round((cast(total_cases as decimal (12,2)) / population * 100),6) as total_cases_against_population
from CovidDeaths
where [location] not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )

--creating view for cases against population per country table

create view vw_total_cases_against_population
as
select [location], CAST([date] as date) as cast_date, total_cases, population, 
round((cast(total_cases as decimal (12,2)) / population * 100),6) as total_cases_against_population
from CovidDeaths
where [location] not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )


--confirming view created
select *
from vw_total_cases_against_population

--looking at highest infection rate for a given population
--exploring the countries with the highest infection rate at a given moment and the percentage of population infected at that given moment

select [location], [population], max(total_cases) as highest_recorded_cases, round((cast(max(total_cases) as decimal (10,2))/[population] * 100 ),2) as highest_infection_rate_per_country
from CovidDeaths
where [location] not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )
group by [location], [population]
order by highest_infection_rate_per_country desc


--creating view for highest infection rate per country table

create view vw_highest_infection_rate_per_country
as
select [location], [population], max(total_cases) as highest_recorded_cases, round((cast(max(total_cases) as decimal (10,2))/[population] * 100 ),2) as highest_infection_rate_per_country
from CovidDeaths
where [location] not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )
group by [location], [population]
--order by highest_infection_rate_per_country desc

--confirming created view
select *
from vw_highest_infection_rate_per_country


--looking at highest death rate for a given population
--exploring the countries with the highest death rate at a given moment and the percentage of population that died at that given moment

select [location],[population], MAX(total_deaths) as highest_death_rate, 
round((CAST(MAX(total_deaths) as decimal (12,2)) / [population] * 100),4) as highest_death_rate_per_country
from CovidDeaths
where [location] not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' ) 
group by [location],[population]
order by population desc

--creating view for highest_death_rate_per_country_table
create view vw_highest_death_rate_per_country
as
select [location],[population], MAX(total_deaths) as highest_death_rate, 
round((CAST(MAX(total_deaths) as decimal (12,2)) / [population] * 100),4) as highest_death_rate_per_country
from CovidDeaths
where [location] not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' ) 
group by [location],[population]
--order by population desc


--confirming the view that was created
select *
from vw_highest_death_rate_per_country






--calculating global numbers
--finding percentage of total cases and total deaths globally
select date, sum(new_cases) as total_cases, sum(new_deaths) as deaths_total, 
round((cast(sum(new_deaths) as decimal (10,2)) /  sum(new_cases) * 100),2) as percentage_of_new_deaths_to_cases
from CovidDeaths
where [location] not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )  
group by date
order by date

--creating view for global rates
create view vw_percentage_of_new_deaths_to_cases
as
select date, sum(new_cases) as total_cases, sum(new_deaths) as deaths_total, 
round((cast(sum(new_deaths) as decimal (10,2)) /  sum(new_cases) * 100),2) as percentage_of_new_deaths_to_cases
from CovidDeaths
where [location] not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )  
group by date
--order by date

--confirming creation of that view
select *
from vw_percentage_of_new_deaths_to_cases


--calculating total cases and total deaths globally
select sum(new_cases) as global_total_cases, sum(new_deaths) as global_total_deaths, round((cast(sum(new_deaths) as decimal (10,2)) /  sum(new_cases) * 100),2) as percentage_of_new_deaths_to_cases
from CovidDeaths
where [location] not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )  


--looking at cases that are taken to the icu per country
--perentage of someone going to the icu while infected
select location, population, total_cases, icu_patients, round((icu_patients /CAST( total_cases as decimal (12,2)) * 100),3) as percentage_admitted_to_icu
from CovidDeaths
where icu_patients is not null and
[location] not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )  

--cases taken to icu globally
select continent, sum(new_cases) total_new_cases, sum(icu_patients) total_admitted, sum(new_deaths) as total_deaths --round((icu_patients /CAST( total_cases as decimal (12,2)) * 100),3) as percentage_admitted_to_icu
from CovidDeaths
where [location] not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )  
group by continent
order by total_new_cases desc

--looking at percetage of cases that were admtted to the icu
select continent, sum(new_cases) total_new_cases, sum(icu_patients) total_admitted, 
 round((sum(icu_patients) / cast(sum(new_cases) as decimal (10,2)) * 100),3) as percentage_admitted_that_are_infected
from CovidDeaths
where [location] not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )  
group by continent
order by total_new_cases desc

--creating view for percentage_admitted_that_are_infected table
create view vw_percentage_admitted_that_are_infected
as
select continent, sum(new_cases) total_new_cases, sum(icu_patients) total_admitted, 
 round((sum(icu_patients) / cast(sum(new_cases) as decimal (10,2)) * 100),3) as percentage_admitted_that_are_infected
from CovidDeaths
where [location] not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )  
group by continent
--order by total_new_cases desc

--confirming the created view
select *
from vw_percentage_admitted_that_are_infected


--comparing cases taken to the icu in relation to death globally

select continent, sum(new_cases) total_new_cases,sum(icu_patients) total_admitted, sum(new_deaths) as total_deaths
from CovidDeaths
where [location] not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )  
group by continent
order by total_new_cases desc

--creating view for cases taken to the icu in relation to death globally table
create view vw_cases_taken_to_the_icu_in_relation_to_death_globally
as
select continent, sum(new_cases) total_new_cases,sum(icu_patients) total_admitted, sum(new_deaths) as total_deaths
from CovidDeaths
where [location] not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )  
group by continent

--confirming created view
select *
from vw_cases_taken_to_the_icu_in_relation_to_death_globally



--finding number of people vaccinted in relation to total population

--first joining two tables
select *
from CovidDeaths dea
join CovidVaccination vac
on vac.continent =  dea.continent and
vac.date = dea.date and
vac.location = dea.location

--finding total people vaccinated in relation to population and cases
--percentage of people vaccinated compared to total population

select dea.continent, dea.location, dea.date, dea.population, dea.total_cases, dea.total_deaths, sum(vac.new_vaccinations)
over(partition by dea.location order by dea.location, dea.date) as total_vaccinations
from CovidDeaths dea
join CovidVaccination vac
on vac.continent =  dea.continent and
vac.date = dea.date and
vac.location = dea.location


--introducing cte to calculate percentages of  total vaccinations 

with cte_vaccination
as
(
select dea.continent, dea.location, dea.date, dea.population, dea.total_cases, dea.total_deaths, vac.new_vaccinations,  sum(vac.new_vaccinations)
over(partition by dea.location order by dea.location, dea.date) as total_vaccinations
from CovidDeaths dea
join CovidVaccination vac
on vac.continent =  dea.continent and
vac.date = dea.date and
vac.location = dea.location
)
select continent, location, date, population, total_cases, total_deaths, isnull(new_vaccinations,0) total_vaccinations,
isnull(round((cast(total_vaccinations as decimal (12,2)) / population * 100),2),0) as percentage_vaccinated_against_population 
from cte_vaccination


--creating view for percentage vaccinated against population table
create view vw_percentage_vaccinated_against_population 
as
with cte_vaccination
as
(
select dea.continent, dea.location, dea.date, dea.population, dea.total_cases, dea.total_deaths, vac.new_vaccinations,  sum(vac.new_vaccinations)
over(partition by dea.location order by dea.location, dea.date) as total_vaccinations
from CovidDeaths dea
join CovidVaccination vac
on vac.continent =  dea.continent and
vac.date = dea.date and
vac.location = dea.location
)
select continent, location, date, population, total_cases, total_deaths, isnull(new_vaccinations,0) total_vaccinations,
isnull(round((cast(total_vaccinations as decimal (12,2)) / population * 100),2),0) as percentage_vaccinated_against_population 
from cte_vaccination

--confirming tables the created view
select*
from vw_percentage_vaccinated_against_population 



--finding the highest total vaccinations of a country
select dea.continent, dea.location, dea.population, max(vac.total_vaccinations) as highest_vaccinations
from CovidDeaths dea
join CovidVaccination vac
on vac.continent =  dea.continent and
vac.date = dea.date and
vac.location = dea.location
where dea.location not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )  
group by dea.continent, dea.location, dea.population
order by highest_vaccinations desc


--creating view for highest vaccinations table
create view vw_highest_vaccinations
as
select dea.continent, dea.location, dea.population, max(vac.total_vaccinations) as highest_vaccinations
from CovidDeaths dea
join CovidVaccination vac
on vac.continent =  dea.continent and
vac.date = dea.date and
vac.location = dea.location
where dea.location not in ('Africa','Asia', 'Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )  
group by dea.continent, dea.location, dea.population



--cconfirming created view
select *
from vw_highest_vaccinations


--looking at the relationship between total tests and vaccinations given per country
with cte_totals
as
(
select year(cast(date as date)) as date1,continent,  location,  sum(new_tests) as total_tests, sum(new_vaccinations) as total_vaccinations
from CovidVaccination
where location not in ('Africa','Asia', 'international','Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )  
group by continent, location, date
--order by continent, location
)
--highest test and highest number of vaccinations 2020
select date1, continent, location, max(total_tests) as max_tests, max(total_vaccinations) as max_vac
from cte_totals
where date1 = 2020
group by date1, continent, location
order by continent, location


--creating views for total tests and vaccination given
create view vw_total_tests_vs_vaccination
as
with cte_totals
as
(
select year(cast(date as date)) as date1,continent,  location,  sum(new_tests) as total_tests, sum(new_vaccinations) as total_vaccinations
from CovidVaccination
where location not in ('Africa','Asia', 'international','Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )  
group by continent, location, date
--order by continent, location
)
--highest test and highest number of vaccinations 2020
select date1, continent, location, max(total_tests) as max_tests, max(total_vaccinations) as max_vac
from cte_totals
where date1 = 2020
group by date1, continent, location
--order by continent, location

--confirming the view
select *
from vw_total_tests_vs_vaccination


--finding relationship between infected cases, death cases and smoking rates per country
--using male smokers column
--using temp_tables

drop table if exists #total_cases_vs_smokers
select dea.continent, dea.location, dea.population,vac.male_smokers,vac.female_smokers, SUM(new_cases) 
over(partition by dea.location order by dea.location desc) as total_cases
into #total_cases_vs_smokers
from CovidDeaths dea
join CovidVaccination vac
on vac.continent =  dea.continent and
vac.date = dea.date and
vac.location = dea.location
where dea.location not in ('Africa','Asia', 'international','Europe', 'World', 'North America', 'European union', 'South America','United Kingdom',  'oceania' )  

select continent, location, population,male_smokers, max(total_cases) as total_cases,
round((cast(male_smokers as decimal (12,2)) / population * 100),2) as percentage_male_smokers,
round((cast(max(total_cases) as decimal (12,2)) / population * 100),2) as percentage_infected
from #total_cases_vs_smokers
group by continent, location, population,male_smokers
order by continent


--using the same temp table to find relation between female smokers and infected cases
select continent, location, population,female_smokers, max(total_cases) as total_cases,
round((cast(female_smokers as decimal (12,2)) / population * 100),2) as percentage_female_smokers,
round((cast(max(total_cases) as decimal (12,2)) / population * 100),2) as percentage_infected
from #total_cases_vs_smokers
group by continent, location, population,female_smokers
order by continent


