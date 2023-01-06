
select * from PortfolioProject..Death
where continent is not null
order by 3,4


-- Selecting the Data for Analysis

select location,date, total_cases,new_cases,total_deaths, population
from PortfolioProject..Death
where continent is not null
order by 1,2


-- Looking at total cases vs Total Deaths

-- Death Rates by country
select location,date, total_cases,total_deaths, Round((total_deaths/total_cases) * 100,2) as DeathPercentage
from PortfolioProject..Death
where location like '%states%' and continent is not null
order by 1,2


-- Total Cases vs Population
select location,date, total_cases,population,(total_cases/population) * 100 as PercentOfPopulationInfected
from PortfolioProject..Death
--where location like '%India%'
order by 1,2


-- Countries with highest infection rate
select location, population, MAX(total_cases)as HighestInfectionCount, Max((total_cases/population)) * 100 as PercentOfPopulationInfected
from PortfolioProject..Death
group by location, population
order by PercentOfPopulationInfected desc


-- Death count by Continent
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..Death
where continent is not null
group by continent
order by TotalDeathCount desc

-- Death count by countries
select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..Death
where continent is not null
group by location
order by TotalDeathCount desc


-- Global Numbers
	select date, sum(cast(new_cases as int)) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/sum(New_cases) * 100 as DeathPercentage
	from PortfolioProject..Death
	where continent is not null
	group by date
	order by 1,2



-- Vaccination Dataset
select * from PortfolioProject..Vaccination

-- Joining two datasets
-- Total Population Vs Vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(Convert(bigint,vac.new_vaccinations)) OVER( partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..Death as dea
join PortfolioProject..Vaccination as vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Using CTE

with PopVsVac  as (
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(Convert(bigint,vac.new_vaccinations)) OVER( partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..Death as dea
join PortfolioProject..Vaccination as vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
)

select *, (RollingPeopleVaccinated/population)* 100 as RollingPeopleVaccinatedInPercent  from PopVsVac
