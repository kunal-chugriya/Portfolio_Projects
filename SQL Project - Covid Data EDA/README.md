COVID Data EDA Project
----------------------

### Overview

This project involves Exploratory Data Analysis (EDA) on COVID-19 data, focusing on the impact and trends of the pandemic from January 1, 2020, to July 20, 2024. The data, sourced from [Our World in Data](https://ourworldindata.org/covid-deaths), includes over 400,000 records and covers various metrics such as total cases, deaths, vaccinations, and population.

### Data Preparation

1.  **Data Download and Import**
    
    *   Downloaded the COVID-19 data files from [Our World in Data](https://ourworldindata.org/covid-deaths).
        
    *   Created two tables from the main file: CovidDeaths and CovidVaccinations, and saved them as XLS files.
        
2.  **Schema and Database Setup**
    
    *   Created a database schema named Portfolio\_Projects in SQL Server.
        
3.  **Data Import into SQL Server**
    
    *   Imported data using SQL Server Management Studio (SSMS) by connecting to the Microsoft Excel data source and copying the data into SQL Server tables.
        
4.  **Table Structure and Formatting**
    
    *   Used INFORMATION\_SCHEMA.COLUMNS and sp\_help to inspect table structures.
        
    *   Managed data types and conversions using CAST and CONVERT functions to handle calculations and formatting.
        

### SQL Queries and Analysis

#### 1\. Total Cases and Deaths Analysis

`SELECT iso_code, continent, location, date, population, total_cases, new_cases, total_deaths, new_deaths,         (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS Death_percentage  FROM PortfolioProjects..CovidDeaths$  ORDER BY continent, location, date;   `

#### 2\. Case Percentage w.r.t Population

`SELECT iso_code, continent, location, date, population, total_cases, new_cases, total_deaths, new_deaths,         ROUND(((CAST(total_cases AS FLOAT) / CAST(population AS FLOAT))) * 100, 2) AS Total_case_percentage  FROM PortfolioProjects..CovidDeaths$  ORDER BY continent, location, date;   `

#### 3\. Most Impacted Locations

`SELECT location, population, MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount,         MAX((CAST(total_cases AS FLOAT) / CAST(population AS FLOAT))) * 100 AS PercentagePopulationInfected  FROM PortfolioProjects..CovidDeaths$  GROUP BY location, population  ORDER BY PercentagePopulationInfected DESC;   `

#### 4\. Countries with Highest Deaths w.r.t Population

`SELECT location, MAX(CAST(population AS FLOAT)) AS population, MAX(CAST(total_deaths AS FLOAT)) AS HighestDeathCount,         MAX((CAST(total_deaths AS FLOAT) / CAST(population AS FLOAT))) * 100 AS PercentagePopulationDeath  FROM PortfolioProjects..CovidDeaths$  GROUP BY location  ORDER BY PercentagePopulationDeath DESC;   `

#### 5\. Continents with Highest Deaths w.r.t Population

`SELECT continent, MAX(CAST(population AS FLOAT)) AS population, MAX(CAST(total_deaths AS FLOAT)) AS HighestDeathCount,         MAX((CAST(total_deaths AS FLOAT) / CAST(population AS FLOAT))) * 100 AS PercentagePopulationDeath  FROM PortfolioProjects..CovidDeaths$  GROUP BY continent  ORDER BY PercentagePopulationDeath DESC;   `

#### 6\. Global Numbers (Daily)

`SELECT date, SUM(daily_total_cases) OVER (ORDER BY date) AS Global_daily_cases,         SUM(daily_total_deaths) OVER (ORDER BY date) AS Global_daily_deaths,         (SUM(daily_total_deaths) OVER (ORDER BY date) / SUM(daily_total_cases) OVER (ORDER BY date)) * 100 AS Global_death_percentage  FROM (SELECT date, SUM(new_cases) AS daily_total_cases, SUM(new_deaths) AS daily_total_deaths        FROM PortfolioProjects..CovidDeaths$        GROUP BY date) a  ORDER BY date; `

#### 7\. Global Summary

`SELECT SUM(daily_total_cases) AS total_cases, SUM(daily_total_deaths) AS total_deaths,         (SUM(daily_total_deaths) / SUM(daily_total_cases)) * 100 AS total_death_percentage  FROM (SELECT date, SUM(new_cases) AS daily_total_cases, SUM(new_deaths) AS daily_total_deaths        FROM PortfolioProjects..CovidDeaths$        GROUP BY date) a;   `

#### 8\. Overview of COVID Data

`SELECT dea.location, MAX(CAST(dea.population AS FLOAT)) AS population,         SUM(CAST(dea.new_cases AS FLOAT)) AS TotalCaseCount,          SUM(CAST(dea.new_deaths AS FLOAT)) AS TotalDeathCount,          SUM(CAST(vac.new_tests AS FLOAT)) AS TotalTestCount,          SUM(CAST(vac.new_vaccinations AS FLOAT)) AS TotalVaccinationCount,          AVG(CAST(vac.tests_per_case AS FLOAT)) AS AvgTestPerCase,          MAX((CAST(dea.total_cases AS FLOAT) / CAST(dea.population AS FLOAT))) * 100 AS HighestPercentageCase,         MAX((CAST(dea.total_deaths AS FLOAT) / CAST(dea.total_cases AS FLOAT))) * 100 AS HighestPercentageCaseDeath,         MAX(CAST(dea.total_deaths AS FLOAT) / CAST(dea.population AS FLOAT)) * 100 AS HighestPercentagePopulationDeath,         MAX(CAST(vac.total_vaccinations AS FLOAT) / CAST(dea.population AS FLOAT)) * 100 AS HighestPercentagePopulationVaccinated  FROM PortfolioProjects..CovidDeaths$ dea  JOIN PortfolioProjects..CovidVaccinations$ vac ON dea.continent = vac.continent     AND dea.date = vac.date AND dea.iso_code = vac.iso_code AND dea.location = vac.location  GROUP BY dea.location  ORDER BY HighestPercentageCase DESC;   `

#### 9\. Per Day Total Vaccinations for All Nations

`SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,         SUM(CONVERT(FLOAT, vac.new_vaccinations)) OVER (PARTITION BY dea.continent, dea.location ORDER BY dea.date) AS Rolling_count_patients_vaccinated  FROM PortfolioProjects..CovidDeaths$ dea  JOIN PortfolioProjects..CovidVaccinations$ vac ON dea.continent = vac.continent     AND dea.date = vac.date AND dea.iso_code = vac.iso_code AND dea.location = vac.location  ORDER BY dea.location, dea.date;   `

#### 10\. Percentage of Population Vaccinated

`WITH PopVac AS (      SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,             SUM(CONVERT(FLOAT, vac.new_vaccinations)) OVER (PARTITION BY dea.continent, dea.location ORDER BY dea.date) AS Rolling_count_patients_vaccinated      FROM PortfolioProjects..CovidDeaths$ dea      JOIN PortfolioProjects..CovidVaccinations$ vac ON dea.continent = vac.continent         AND dea.date = vac.date AND dea.iso_code = vac.iso_code AND dea.location = vac.location  )  SELECT *, (Rolling_count_patients_vaccinated / population) * 100 AS total_percentage_vaccinated_population  FROM PopVac  ORDER BY location, date;   `

#### 11\. Create and Populate Temp Table

`DROP TABLE IF EXISTS #PopVac;  CREATE TABLE #PopVac (      continent NVARCHAR(255),      location NVARCHAR(255),      date DATETIME,      population NUMERIC,      new_vaccinations NUMERIC,      rolling_count_patients_vaccinated NUMERIC  );  INSERT INTO #PopVac   SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,         SUM(CONVERT(FLOAT, vac.new_vaccinations)) OVER (PARTITION BY dea.continent, dea.location ORDER BY dea.date) AS Rolling_count_patients_vaccinated  FROM PortfolioProjects..CovidDeaths$ dea  JOIN PortfolioProjects..CovidVaccinations$ vac ON dea.continent = vac.continent     AND dea.date = vac.date AND dea.iso_code = vac.iso_code AND dea.location = vac.location;  SELECT * FROM #PopVac;   `

#### 12\. Create View for Visualization

`CREATE VIEW PopVacView AS   SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,         SUM(CONVERT(FLOAT, vac.new_vaccinations)) OVER (PARTITION BY dea.continent, dea.location ORDER BY dea.date) AS Rolling_count_patients_vaccinated  FROM PortfolioProjects..CovidDeaths$ dea  JOIN PortfolioProjects..CovidVaccinations$ vac ON dea.continent = vac.continent     AND dea.date = vac.date AND dea.iso_code = vac.iso_code AND dea.location = vac.location;  SELECT * FROM PopVacView;   `

### Insights

1.  **Initial Death Rate Trends**: For most countries, the death rate relative to total cases increased sharply initially, plateaued for a period, and then declined significantly.
    
2.  **Most Impacted Nations**: Cyprus had 77% of its population impacted by COVID-19, while South Korea experienced 66%. In contrast, larger countries like China and India had significantly lower percentages (6% and 3%, respectively).
    
3.  **Death Percentage Relative to Population**: The highest death percentage relative to population was 0.64%, with 50% of nations having percentages between 0.64% and 0.1%, and the remaining 50% having less than 0.1%.
    
4.  **Continent Analysis**: Continents like Europe and South America showed higher percentages of population vaccinated compared to North America and Africa.
