--select * from PortfolioProject.dbo.coviddeaths order by 3,4
select * from PortfolioProject.dbo.coviddeaths
where continent is not null
order by 3,4

--data used 
select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject.dbo.coviddeaths 
where continent is not null
order by 1,2


select location,date,total_cases,total_deaths,max(total_cases)
from PortfolioProject.dbo.coviddeaths 
where continent is not null
group by location
order by 1,2



select location,max(total_deaths) as total_deaths_per_country
from PortfolioProject..coviddeaths
where continent is not null
group by location
order by total_deaths_per_country desc




SELECT location,Max(total_deaths) as total_num_deaths,max(total_cases)as max_total_cases
FROM PortfolioProject.dbo.coviddeaths 
where continent is not null
GROUP BY location
order by max_total_cases desc

SELECT location, Max(total_deaths) as total_num_deaths,max(total_cases)as max_total_cases
FROM coviddeaths 
where location like '%Algeria%' 
GROUP BY location


select location,date,population
from coviddeaths where continent is not null


SELECT location, Max(total_deaths ) as total_num_deaths
FROM coviddeaths 
where continent is not null
group by location
order BY total_num_deaths desc





SELECT continent, Max(total_deaths ) as total_num_deaths
FROM coviddeaths 
where continent is  not null
group by continent
order BY total_num_deaths desc

---global numbers
select date,sum(cast(new_cases as float)),sum(cast(new_deaths as float)),sum(cast(new_deaths as float))/sum(cast(new_cases as float))*100
from PortfolioProject..coviddeaths
where continent is not null
group by date order by 1,2


--total vaccinations vs total vaccinations
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated

from PortfolioProject..coviddeaths dea
join
 PortfolioProject..covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null and  dea.location <> 'Africa'
order by 2,3 

--wth cte
with PopvsVac(Continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated

from PortfolioProject..coviddeaths dea
join
 PortfolioProject..covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null and dea.location <> 'Africa'
--order by 2,3
)
select *,(RollingPeopleVaccinated/population)*100
from PopvsVac

--temp table 
drop table if exists #PercentPopulationVaccinnated
create table #PercentPopulationVaccinnated
(continent nvarchar(255),location nvarchar(255),date datetime,population numeric
,new_vaccinations numeric,RollingPeopleVaccinated numeric)
insert into #PercentPopulationVaccinnated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated

from PortfolioProject..coviddeaths dea
join
 PortfolioProject..covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null and dea.location <> 'Africa'
--order by 2,3

select *,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinnated


--creating view to store data for later 
create view PercentPopulationVaccinated as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated

from PortfolioProject..coviddeaths dea
join
 PortfolioProject..covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null and  dea.location <> 'Africa'