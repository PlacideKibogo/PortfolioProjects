select Location, date, total_cases , new_cases, total_deaths, population  
from PortfolioProject..CovidDeaths
order by 1,2


-- Looking at Total Cases vs Total Deaths 
-- shows likelohood of dying if you contract covid in your country 
select Location, date, total_cases , total_deaths, (total_deaths/total_cases)*100  as DeathPercentage
from PortfolioProject..CovidDeaths
where LOcation like '%Rwanda%'
order by 1,2

-- Looking at Total cases vs Population 
-- Shows what percentage of population got covid 
select Location, date,population, total_cases ,(total_cases/population)*100  as DeathPercentage
from PortfolioProject..CovidDeaths
where LOcation like '%Rwanda%'
order by 1,2

-- Looking at countries with Highest Infection Rate compared to population 

select Location, population, MAX(total_cases)as HighestInfectionCount ,
MAX((total_cases/population))*100  as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where LOcation like '%Rwanda%'
GROUP by Location, Population 
order by PercentPopulationInfected desc

-- Showing countries with Highest Death Count per Population 

select Location, MAX(cast(Total_deaths as int))as TotalDeathCount
from PortfolioProject..CovidDeaths
--where LOcation like '%Rwanda%'
where continent is not null
GROUP by Location 
order by TotalDeathCount desc

-- Let break THINGS DOWN BY CONTINENT 

select continent, MAX(cast(Total_deaths as int))as TotalDeathCount
from PortfolioProject..CovidDeaths
--where LOcation like '%Rwanda%'
where continent is not null
GROUP by continent 
order by TotalDeathCount desc


-- Showing the continents with the highest death count per population 

select continent, MAX(cast(Total_deaths as int))as TotalDeathCount
from PortfolioProject..CovidDeaths
--where LOcation like '%Rwanda%'
where continent is not null
GROUP by continent 
order by TotalDeathCount desc

--GLOBAL NUMBERS 

select  date, Sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage --total_cases , total_deaths, (total_deaths/total_cases)*100  as DeathPercentage
from PortfolioProject..CovidDeaths
--where LOcation like '%Rwanda%'
where continent is not null 
group by date
order by 1,2


-- Looking at Total Population vs Vaccinations 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.Location ) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidCaccinations vac
ON dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3

-- Use CTE
With PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.Location ) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidCaccinations vac
ON dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
---order by 2,3

)
select *,RollingPeopleVaccinated/Population*100 From PopvsVac




-- TEMP Table 

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.Location ) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidCaccinations vac
ON dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
---order by 2,3

