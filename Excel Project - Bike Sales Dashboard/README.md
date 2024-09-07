
# Bike Sales Excel Project

This project involves analyzing bike sales data with a focus on data cleaning, visualization, and deriving insights.

## Data Cleaning
- **Duplicates**: Removed all duplicate entries.
- **Marital Status**: Converted abbreviations (`M` and `S`) to full names (`Married` and `Single`).
- **Gender**: Converted abbreviations (`F` and `M`) to full names (`Female` and `Male`).
- **Age Bracket**: Added a new column for age brackets:
  - `Old`: Age > 59
  - `Middle Age`: Age > 44
  - `Adult`: Age ≤ 44

## Sheets Overview
1. **Original Data**: The raw data before any cleaning.
2. **Data Cleaning**: Contains the cleaned data.
3. **Dashboard**: Contains visualizations and interactive elements.
4. **Pivot Table**: Contains pivot tables for detailed analysis.

## Slicers
Three slicers have been added to the dashboard for interactive filtering:
- **Marital Status**
- **Gender**
- **Region**

## Charts

### 1. Average Income
- **Insight**: Bike purchasers have a higher average income compared to non-purchasers, regardless of gender.

### 2. Age
- **Insight**: Bike purchases decrease with age.

### 3. Education
- **Insight**: Higher education levels are associated with a higher likelihood of purchasing a bike. For instance:
  - More people with a bachelor's or graduate degree bought a bike compared to those with the same degrees who did not.
  - Only 20 people with partial high school education purchased a bike compared to 56 who did not.

### 4. Commute Distance
- **Insight**: As commute distance increases, the number of bike purchasers decreases. This could be due to longer commutes being managed with a car or public transport.

### 5. Number of Children
- **Insight**: 
  - People with at most 1 child bought more bikes compared to those with 0 or 1 child.
  - Bike purchases decreased with 2 children, likely due to the preference for a car.
  - A reversal occurs with 3 children, where more bikes are purchased, possibly because a second vehicle is preferred.
  - The trend declines again with 4 and 5 children.

### 6. Number of Cars
- **Insight**: 
  - People with at most 1 car bought more bikes compared to those with 0 or 1 car.
  - A reversal is observed for 2, 3, and 4 cars. Notably:
    - People with 2 cars show a significant drop in bike purchases: 218 did not buy a bike compared to 124 who did.
    - The percentage increase in non-bike purchases was 89.5% from people with 1 car, while the decrease for buyers was only 18.4%.
   
      
![Bike sales Excel Dashboard](https://github.com/user-attachments/assets/2c1e5a67-9af4-492f-bdd7-6aba6148029d)   
    

