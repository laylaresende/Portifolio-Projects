SELECT *
FROM [Portifolio Project]..CovidDeaths
WHERE 
	continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM [Portifolio Project]..CovidVaccinations
--ORDER BY 3,4

--Select Data
SELECT location,date,total_cases,new_cases,total_deaths,population
FROM [Portifolio Project]..CovidDeaths
WHERE  
	continent IS NOT NULL
ORDER BY 1,2

-- Total Cases vs Total Deaths
SELECT 
	location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) /NULLIF(CONVERT(float, total_cases), 0)) * 100 AS DeathPercentage
FROM 
	[Portifolio Project]..CovidDeaths
WHERE
	location = 'Brazil'
AND  
	continent IS NOT NULL
ORDER BY 
	1,2

CREATE VIEW DeathPercentageCountry as
SELECT 
	location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) /NULLIF(CONVERT(float, total_cases), 0)) * 100 AS DeathPercentage
FROM 
	[Portifolio Project]..CovidDeaths
WHERE
	location = 'Brazil'
AND  
	continent IS NOT NULL


-- Total Cases vs Population
SELECT
	location, date, population, total_cases,  (CONVERT(float, total_cases) /NULLIF(CONVERT(float, population), 0)) * 100 AS PercentTotalCases
FROM
	[Portifolio Project]..CovidDeaths
--WHERE	location = 'Brazil'
WHERE  
	continent IS NOT NULL
ORDER BY 
	1,2

CREATE VIEW DeathPercentagePopulation as
SELECT
	location, date, population, total_cases,  (CONVERT(float, total_cases) /NULLIF(CONVERT(float, population), 0)) * 100 AS PercentTotalCases
FROM
	[Portifolio Project]..CovidDeaths
--WHERE	location = 'Brazil'
WHERE  
	continent IS NOT NULL


-- Highest Infection Rate per Country
SELECT
	location,  population, MAX(total_cases) AS HighestInfectionCount,  (CONVERT(float, MAX(total_cases)) /NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulationInfected
FROM
	[Portifolio Project]..CovidDeaths
--WHERE	location = 'Brazil'
WHERE  
	continent IS NOT NULL
GROUP BY
	location,  population
ORDER BY 
	PercentPopulationInfected DESC

CREATE VIEW PercentPopulationInfected AS
SELECT
	location,  population, MAX(total_cases) AS HighestInfectionCount,  (CONVERT(float, MAX(total_cases)) /NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulationInfected
FROM
	[Portifolio Project]..CovidDeaths
--WHERE	location = 'Brazil'
WHERE  
	continent IS NOT NULL
GROUP BY
	location,  population


-- Countries with Highest Count per Population
SELECT
	location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM
	[Portifolio Project]..CovidDeaths
--WHERE	location = 'Brazil'
WHERE  
	continent IS NOT NULL
GROUP BY
	location
ORDER BY 
	TotalDeathCount DESC

CREATE VIEW TotalDeathCountCountry AS
SELECT
	location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM
	[Portifolio Project]..CovidDeaths
--WHERE	location = 'Brazil'
WHERE  
	continent IS NOT NULL
GROUP BY
	location


-- DEATHS PER CONTINENT
SELECT
	location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM
	[Portifolio Project]..CovidDeaths
WHERE  
	continent IS NULL
GROUP BY
	location
ORDER BY 
	TotalDeathCount DESC



	-- Continents with Highest death count
SELECT
	continent, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM
	[Portifolio Project]..CovidDeaths
--WHERE	location = 'Brazil'
WHERE  
	continent IS NOT NULL
GROUP BY
	continent
ORDER BY 
	TotalDeathCount DESC

CREATE VIEW TotalDeathContinent AS
SELECT
	continent, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM
	[Portifolio Project]..CovidDeaths
--WHERE	location = 'Brazil'
WHERE  
	continent IS NOT NULL
GROUP BY
	continent


SELECT 
	LOCATION, date, total_cases, total_deaths, (CONVERT(float, total_deaths) /NULLIF(CONVERT(float, total_cases), 0)) * 100 AS DeathPercentage
FROM 
	[Portifolio Project]..CovidDeaths
WHERE  
	continent IS NULL
ORDER BY 
	1,2

SELECT
	location, date, population, total_cases,  (CONVERT(float, total_cases) /NULLIF(CONVERT(float, population), 0)) * 100 AS PercentTotalCases
FROM
	[Portifolio Project]..CovidDeaths
--WHERE	location = 'Brazil'
WHERE  
	continent IS NULL
ORDER BY 
	1,2

SELECT
	location,  population, MAX(total_cases) AS HighestInfectionCount,  (CONVERT(float, MAX(total_cases)) /NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulationInfected
FROM
	[Portifolio Project]..CovidDeaths
--WHERE	location = 'Brazil'
WHERE  
	continent IS NULL
GROUP BY
	location,  population
ORDER BY 
	PercentPopulationInfected DESC

-- GLOBAL NUMBERS
SELECT
	SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, (SUM(CAST(new_deaths as int)))/SUM(new_cases)* 100 AS DeathPercentage 
FROM
	[Portifolio Project]..CovidDeaths
WHERE  
	continent IS NOT NULL
--GROUP BY date
ORDER BY 
	1,2

CREATE VIEW DeathPercentageGlobal as
SELECT
	SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, (SUM(CAST(new_deaths as int)))/SUM(new_cases)* 100 AS DeathPercentage
FROM
	[Portifolio Project]..CovidDeaths
WHERE  
	continent IS NOT NULL
--GROUP BY date



-- JOIN TABLES / TOTAL POPULATION vs VACCINATIONS
SELECT
	dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations, 
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated,
	(RollingPeopleVaccinated/population)*100
FROM
	[Portifolio Project]..CovidDeaths dea
JOIN
	[Portifolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE  
	dea.continent IS NOT NULL
ORDER BY 
	2,3

-- USE CTE

With PopvsVac (Continent, Location, date, population, new_vaccinations, RollingPeopleVaccinated) AS 
(
SELECT
	dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
	--(RollingPeopleVaccinated/population)*100
FROM
	[Portifolio Project]..CovidDeaths dea
JOIN
	[Portifolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE  
	dea.continent IS NOT NULL 
--ORDER BY  2,3
)
SELECT 
	*, (RollingPeopleVaccinated/population)*100
FROM 
	PopvsVac

	--ALTERNATIVE VERSION
With PopvsVac (Continent, Location, date, population, new_vaccinations, RollingPeopleVaccinated) AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, NULLIF(CONVERT(float, vac.new_vaccinations), 0) AS new_vaccinations,
		SUM(NULLIF(CONVERT(float, vac.new_vaccinations), 0)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM
	[Portifolio Project]..CovidDeaths dea
JOIN
	[Portifolio Project]..CovidVaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

)

--TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO
	#PercentPopulationVaccinated	
SELECT
	dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
	--(RollingPeopleVaccinated/population)*100
FROM
	[Portifolio Project]..CovidDeaths dea
JOIN
	[Portifolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE  	dea.continent IS NOT NULL 
--ORDER BY  2,3

SELECT 
	*, (RollingPeopleVaccinated/population)*100
FROM 
	#PercentPopulationVaccinated	

--CREATING VIEW

CREATE VIEW PercentPopulationVaccinated as	
SELECT
	dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
	--(RollingPeopleVaccinated/population)*100
FROM
	[Portifolio Project]..CovidDeaths dea
JOIN
	[Portifolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE  	dea.continent IS NOT NULL 
--ORDER BY  2,3

SELECT *
FROM PercentPopulationVaccinated

