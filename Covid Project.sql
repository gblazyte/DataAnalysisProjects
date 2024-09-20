SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM portfolio_project_covid.coviddeathsnew
ORDER BY location, STR_TO_DATE(date, '%Y-%m-%d');

-- SELECT * FROM portfolio_project_covid.covidvaccinations
-- order by 3,4

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM portfolio_project_covid.coviddeathsnew
Where location = 'Lithuania'
ORDER BY location, STR_TO_DATE(date, '%Y-%m-%d');

-- total cases vs population

SELECT location, date, total_cases, population, (total_cases/population)*100 AS InfectionPercentage
FROM portfolio_project_covid.coviddeathsnew
Where location = 'Lithuania'
ORDER BY location, STR_TO_DATE(date, '%Y-%m-%d');

-- countries with highest infection rate compared to population

SELECT location, population, max(total_cases) AS HighestInfectionCount, Max((total_cases/population))*100 AS InfectionPercentage
FROM portfolio_project_covid.coviddeathsnew
where continent != ''
group by location, population
order by 4 Desc;

-- countries with highest death count per population

SELECT location, max(cast(total_deaths as unsigned)) AS TotalDeathCount
FROM portfolio_project_covid.coviddeathsnew
where continent != ''
group by location
order by TotalDeathCount desc;


--  by continent
SELECT continent, max(cast(total_deaths as unsigned)) AS TotalDeathCount
FROM portfolio_project_covid.coviddeathsnew
where continent != ''
group by continent
order by TotalDeathCount desc;

-- global numbers

SELECT sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 AS DeathPercentage
FROM portfolio_project_covid.coviddeathsnew
-- Where location = 'Lithuania'
where continent != ''
-- group by date
ORDER BY 1,2; -- STR_TO_DATE(date, '%Y-%m-%d'), 2;


-- total population vs vaccinations
-- use CTE

with PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac. new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- max((RollingPeopleVaccinated/dea.population))*100 AS VaccinationPercentage
from coviddeathsnew dea
join covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent != ''
ORDER BY 2, STR_TO_DATE(dea.date, '%Y-%m-%d'))

select *, (RollingPeopleVaccinated/PopvsVac.population)*100 AS VaccinationPercentage
from PopvsVac;

-- creating view to store data for later visualizations

create view GlobalNumbers as
SELECT sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 AS DeathPercentage
FROM portfolio_project_covid.coviddeathsnew
-- Where location = 'Lithuania'
where continent != ''
-- group by date
ORDER BY 1,2;

Create view DeathPercentageLithuania as
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM portfolio_project_covid.coviddeathsnew
Where location = 'Lithuania'
ORDER BY location, STR_TO_DATE(date, '%Y-%m-%d');


create view InfectionPercentageLithuania as
SELECT location, date, total_cases, population, (total_cases/population)*100 AS InfectionPercentage
FROM portfolio_project_covid.coviddeathsnew
Where location = 'Lithuania'
ORDER BY location, STR_TO_DATE(date, '%Y-%m-%d');


create view HighestInfectionRate as
SELECT location, population, max(total_cases) AS HighestInfectionCount, Max((total_cases/population))*100 AS InfectionPercentage
FROM portfolio_project_covid.coviddeathsnew
where continent != ''
group by location, population
order by 4 Desc;


create view HighestDeathCount as
SELECT location, max(cast(total_deaths as unsigned)) AS TotalDeathCount
FROM portfolio_project_covid.coviddeathsnew
where continent != ''
group by location
order by TotalDeathCount desc;



