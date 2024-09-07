-- 1_ Looking at total cases and total deaths and calculating total death percentage w.r.t population




  select iso_code,continent,location,date,population,total_cases,new_cases,total_deaths,new_deaths,
  (cast(total_deaths as float)/cast(total_cases as float))*100 as Death_percentage
  

  from PortfolioProjects..CovidDeaths$   order by continent,location,date

  -- 2)  Looking at total cases and total deaths and calculating total case percentage w.r.t population

  select iso_code,continent,location,date,population,total_cases,new_cases,total_deaths,new_deaths,
  round(((cast(total_cases as float)/cast(population as float)))*100,2) as Total_case_percentage
  
  from PortfolioProjects..CovidDeaths$  
  
  order by continent,location,date ;


  -- 3) Looking for the most impacted locations

  select location,population,max(cast(total_cases as float)) as HighestInfectionCount, max((cast(total_cases as float) /(cast(population as float))))*100 as PecentagePopulationInfected
  from PortfolioProjects..CovidDeaths$  
  group by location,population
  order by PecentagePopulationInfected desc;


-- 4) Showing countires with highest deaths w.r.t population

 select location,max(cast(population as float)) as population,max(cast(total_deaths as float)) as HighestDeathCount, max((cast(total_deaths as float) /(cast(population as float))))*100 as PecentagePopulationDeath
  from PortfolioProjects..CovidDeaths$  
  group by location
  order by PecentagePopulationDeath desc;


  -- 5) Showing continents with highest deaths w.r.t population

   select continent,max(cast(population as float)) as population,max(cast(total_deaths as float)) as HighestDeathCount, max((cast(total_deaths as float) /(cast(population as float))))*100 as PecentagePopulationDeath
  from PortfolioProjects..CovidDeaths$  
  group by continent
  order by PecentagePopulationDeath desc;


  -- 6) GLOBAL Numbers i.e. each day

   select date,sum(daily_total_cases) over (order  by date) as Global_daily_cases,
   sum(daily_total_deaths) over (order  by date) as Global_daily_deaths,

   (sum(daily_total_deaths) over (order  by date) /sum(daily_total_cases) over (order  by date))*100 as Global_death_percentage

   from (


   select date, sum(new_cases) as daily_total_cases,sum(new_deaths) as daily_total_deaths
   from PortfolioProjects..CovidDeaths$
   
   group by date
   )a
   order by date
   ;




   -- 7) GLOBAL Numbers i.e. total cases, deaths and total death percentage
  select sum(daily_total_cases) as total_cases,
   sum(daily_total_deaths)  as total_deaths,


   (sum(daily_total_deaths)  /sum(daily_total_cases) )*100 as total_death_percentage

   from (


   select date, sum(new_cases) as daily_total_cases,sum(new_deaths) as daily_total_deaths
   from PortfolioProjects..CovidDeaths$
   
   group by date
   )a

   ;



   -- 8) An overiew of entire covid data i.e. cases, deaths, vaccines etc

    
    select dea.location,max(cast(dea.population as float)) as population,
	sum(cast(dea.new_cases as float)) as TotalCaseCount, 
	sum(cast(dea.new_deaths as float)) as TotalDeathCount, 
		sum(cast(vac.new_tests as float)) as TotalTestCount, 
	sum(cast(vac.new_vaccinations as float)) as TotalVaccinationCount, 
	avg(cast(vac.tests_per_case as float)) as AvgTestPerCase, 
	max((cast(dea.total_cases as float) /(cast(dea.population as float))))*100 as HighestPercentageCase,

		max((cast(dea.total_deaths as float) /(cast(dea.total_cases as float))))*100 as HighestPercentageCaseDeath,
	max(cast(dea.total_deaths as float) /(cast(dea.population as float)))*100 as HighestPecentagePopulationDeath,
		max(cast(vac.total_vaccinations as float) /(cast(dea.population as float)))*100 as HighestPecentagePopulationVaccinated

from PortfolioProjects..CovidDeaths$ dea
join
PortfolioProjects..CovidVaccinations$ vac on dea.continent =vac.continent
and dea.date = vac.date and dea.iso_code=vac.iso_code and dea.location = vac.location 
--and dea.location='India'

  group by dea.location
  order by HighestPercentageCase desc;



   -- 9) Per day total vaccinations for all the nations


   select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
   sum(convert(float,vac.new_vaccinations)) over (partition by dea.continent,dea.location order by dea.date) as Rolling_count_patients_vaccinated
   from

PortfolioProjects..CovidDeaths$ dea
join
PortfolioProjects..CovidVaccinations$ vac on dea.continent =vac.continent
and dea.date = vac.date and dea.iso_code=vac.iso_code and dea.location = vac.location

order by dea.location,dea.date


-- 10) Percentage of population which is vaccinated i.e. for each day and for all locations

with PopVac as

( select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
   sum(convert(float,vac.new_vaccinations)) over (partition by dea.continent,dea.location order by dea.date) as Rolling_count_patients_vaccinated
   from

PortfolioProjects..CovidDeaths$ dea
join
PortfolioProjects..CovidVaccinations$ vac on dea.continent =vac.continent
and dea.date = vac.date and dea.iso_code=vac.iso_code and dea.location = vac.location


)


select *, (Rolling_count_patients_vaccinated/population)*100 total_percentage_vaccinated_population from PopVac where location='India'

order by location,date;


-- Above data is stored into a temp table

drop table if exists #PopVac
create table #PopVac
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_count_patients_vaccinated numeric
)

insert into #PopVac 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
   sum(convert(float,vac.new_vaccinations)) over (partition by dea.continent,dea.location order by dea.date) as Rolling_count_patients_vaccinated
   from

PortfolioProjects..CovidDeaths$ dea
join
PortfolioProjects..CovidVaccinations$ vac on dea.continent =vac.continent
and dea.date = vac.date and dea.iso_code=vac.iso_code and dea.location = vac.location


select * from #PopVac;



-- View has been created to store data for later visualization

create view PopVacView as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
   sum(convert(float,vac.new_vaccinations)) over (partition by dea.continent,dea.location order by dea.date) as Rolling_count_patients_vaccinated
   from

PortfolioProjects..CovidDeaths$ dea
join
PortfolioProjects..CovidVaccinations$ vac on dea.continent =vac.continent
and dea.date = vac.date and dea.iso_code=vac.iso_code and dea.location = vac.location;


select * from PopVacView;

select * from PortfolioProjects..CovidVaccinations$;