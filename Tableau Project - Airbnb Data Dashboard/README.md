# Airbnb Listing Data Analysis - Tableau Project

This project analyzes Airbnb listing data by combining multiple datasets into one Excel file, including **Listings**, **Reviews**, and **Calendars**.

## Data Sources
- **Listings**: Contains detailed information about all Airbnb listings.
- **Reviews**: Includes customer reviews, with one listing having multiple reviews.
- **Calendars**: Tracks apartment availability (occupied or vacant) and daily rental prices.

The three tables can be joined using the common `listing_id` column. However, the **Reviews** table is excluded for two reasons:
- It won’t be used much in the visualization.
- The dataset exceeds the 15 million record limit in Tableau Public, with the combined data totaling 23 million records.

## Key Considerations
- **Use Case Focus**: Define the use case before starting the visualization. For example, a prospective Airbnb business owner might analyze which locations are most profitable.
- **Generated Fields**: Calculated fields are stored separately. For example, the **Calendar** table may appear twice—once with all fields and again with the calculated fields.

## Visualizations

### 1. Average Price by Zip Code (Chart 1)
   - **Columns**: Average Price  
   - **Rows**: Zip Codes  
   - **Insights**: This sorted bar chart shows which zip codes command higher average rental prices.

### 2. Listings Map (Chart 2)
   - **Visualization**: Map displaying listing counts by zip code.  
   - **Insights**: Combined with Chart 1, it reveals areas with high rental prices and less competition.  
   - **Note**: Ensure the map uses U.S. zip codes for accuracy. Consistent color coding is applied throughout the project to identify zip codes.

### 3. Demand Trend Over Time (Chart 3)
   - **Visualization**: Line chart showing weekly demand trends, using date and price data.  
   - **Insights**: January shows the lowest demand, with revenues doubling by March and remaining stable. December experiences a peak in demand.  
   - **Note**: Data from January 1, 2017, was filtered out due to insufficient data causing an abnormal drop.

### 4. Revenue and Bedroom Count Analysis (Chart 4)
   - **Analysis**: Number of bedrooms vs. sum of prices.  
   - **Insights**: As the number of bedrooms increases, both total revenue and listing count i.e. w.r.t to number of bedrooms decreases, following a logical pattern.  
   - **Note**: Excludes null and zero values.

### 5. Average Price per Bedroom (Chart 5)
   - **Analysis**: Average price across properties with 1 to 6 bedrooms.  
   - **Insights**: The average price increases as the number of bedrooms rises.

### 6. Price by Square Footage (Chart 6)
   - **Analysis**: Number of properties and average price by square footage.  
   - **Insights**: For example, properties with 710 sq. ft. have an average price of $262, which is significantly higher than properties with 675 sq. ft. and 700 sq. ft., likely due to location.

![Final_Dashboard_Screenshot](https://github.com/user-attachments/assets/4fbc9bca-c6f3-4156-a025-bef5a5382555)

---

### Notes:
- To make the sheet names bold, select the entire sheet name, click on the **bold** option, and apply it in Tableau.
- Some fields might automatically convert to measures for aggregate functions in Tableau. To prevent this, right-click the field and convert it into a dimension as needed.
