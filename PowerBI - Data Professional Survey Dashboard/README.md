# Data Professional Survey Dashboard

## Project Overview
This project focuses on creating a dashboard using Power BI based on survey data from data professionals. The survey includes responses about various aspects of their work, life, and the data profession. The objective is to clean the data and generate insights through visualizations.

## Data Cleaning
- **Empty Fields:** Removed 4-5 empty fields.
- **Non-standard Values:** Many fields contained values that didn't match the provided options. Direct conversion into new fields would result in low record counts, which wouldn't provide meaningful insights. Therefore, these values were grouped under "Other" using:
  - `Split Column` operation.
  - A logic-based new column: `if text.contains(text.UPPER(column), “SQL”) then “SQL” else column`.
  - Conditional columns were used for efficient logic handling.
- **Salary Data:** Created a new column to display the average salary. This was done by duplicating the salary column, splitting ranges, calculating the average, and placing this next to the original column. This approach helps in better visualizing salary data compared to salary ranges.

## Visualizations and Dashboard Features
- **Dashboard Title:** Text box added with the project name.
- **Summary Stats:** Text boxes created to display total survey participants and the average age of respondents.
- **Gauge Charts:** Four gauges displaying key satisfaction metrics:
  - Happiness with salary: 4.26/10
  - Happiness with work-life balance: 5.72/10
  - Happiness with learning opportunities: 5.64/10
  - Happiness with management: 5.33/10
- **Salary Insights by Job Title:** A horizontal bar chart showing that Data Scientists earn an average of $95k, followed by Data Engineers ($67k), and Data Analysts ($55k).
- **Favorite Programming Language by Job Title:** A vertical stacked bar chart shows Python as the most favored language among Data Analysts (203 mentions).
- **Country-Wise Insights:** A vertical stacked bar chart displays the distribution of survey respondents by country. The U.S. has the largest number of respondents and the highest average salary, highlighting the U.S. as a dominant market for data professionals.
- **Salary by Gender:** A donut pie chart shows a small difference between male and female salaries. Females earn an average of $55.87k, and males $54.47k, indicating a lack of significant pay disparity.
- **Salary by Ethnicity:** A bar chart shows potential disparity, with White respondents earning an average of $68k, Asians (excluding Indian) $49k, and Black/African respondents $39k. While these figures suggest inequality, further variables would need to be considered for a comprehensive analysis.
- **Salary by Education:** A clear trend is shown in salary versus education. PhDs earn an average of $113k, followed by Master’s degree holders at $61k, and Bachelor’s degree holders, followed by those with a High School diploma.
- **Difficulty in Career Transition:** A combination of a line and bar chart illustrates the relationship between switching to the data field and salary. It shows that individuals who found the transition easier tend to earn more, and most participants had switched to the data field, regardless of the difficulty they faced.

## Key Insights:
- The U.S. dominates the data professional market with higher salaries.
- Data Scientists earn the highest on average, followed by Data Engineers and Analysts.
- Education level significantly impacts salary, with PhDs earning the most.
- There are potential disparities in earnings across different ethnicities, though more variables are needed for a thorough analysis.
- Those who found it easier to enter the data field generally earn higher salaries.
- In case of gender, a lack of significant pay disparity is observed.
