Select *
From PorfolioProject..CovidDeaths$
order by 3,4

--Select *
--From PorfolioProject..CovidVaccinations$
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PorfolioProject..CovidDeaths$
order by 1,2

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PorfolioProject..CovidDeaths$
WHERE location like '%vietnam%'
order by 1,2

--Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From PorfolioProject..CovidDeaths$
--WHERE location like '%china%'
--order by 1,2

--Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From PorfolioProject..CovidDeaths$
--WHERE location like '%state%'
--order by 1,2

--Select Location, date, total_cases, population, (total_cases/population)*100 as InfectedPercentage
--From PorfolioProject..CovidDeaths$
--WHERE location like '%state%'
--order by 1,2

Select Location, date, population, total_cases, (total_cases/population)*100 as InfectedPercentage
From PorfolioProject..CovidDeaths$
WHERE location like '%vietnam%'
order by 1,2

Select Location, date, population, total_cases, (total_cases/population)*100 as InfectedPercentage
From PorfolioProject..CovidDeaths$
WHERE ((total_cases/population)*100 >= 1 and location like '%vietnam%')
order by 1,2

Select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population)*100) as InfectedPercentage
From PorfolioProject..CovidDeaths$
Group by location, population
order by InfectedPercentage desc

Select continent,max(cast(total_deaths as int)) as TotalDeathCount
From PorfolioProject..CovidDeaths$
WHERE continent is not null
Group by continent
order by TotalDeathCount desc

SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PorfolioProject..CovidDeaths$
WHERE continent is not null
Group by date
Order by 1,2

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PorfolioProject..CovidDeaths$ dea
JOIN PorfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
Order by 1,2,3
;

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) OVER(PARTITion by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PorfolioProject..CovidDeaths$ dea
JOIN PorfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null


With PopvsVac(continent, location, date,population,new_vaccinations, RollingPeopleVaccinated) as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) OVER(PARTITion by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PorfolioProject..CovidDeaths$ dea
JOIN PorfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
)

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac



DROP TABLE if exists #PercentPopulationVaccinated
Create Table  #PercentPopulationVaccinated
(
Continent nvarchar(225),
Location nvarchar(225),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)



Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) OVER(PARTITion by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PorfolioProject..CovidDeaths$ dea
JOIN PorfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated



CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) OVER(PARTITion by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PorfolioProject..CovidDeaths$ dea
JOIN PorfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null

SELECT *
FROM PercentPopulationVaccinated







