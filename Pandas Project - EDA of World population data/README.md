World Population Exploratory Data Analysis (EDA)
================================================

Dataset Overview
----------------

The dataset provides population data for each country from 1970 to 2022, organized by decade. It includes additional information such as area, growth rate, continent, capital, and world population percentage.

Steps Performed
---------------

1. **Set Decimal Points: To format numbers to two decimal points:**  

    Code - pd.set\_option('display.float\_format', lambda x: '%.2f' % x)
    <br>
2.  **Basic Data Overview:**
    
    *   **Check for Duplicates:** df\[df.duplicated()\]
        
    *   **Statistical Summary:** df.describe()
        
    *   **Number of Null Values for Each Column:** df.isnull().sum()
        
    *   **Number of Unique Values for Each Column:** df.nunique()
        
    *   **Number of Duplicate Rows:** df\[df.duplicated()\]
        <br>
3.  **Population Analysis:**
    
    *   **Top 10 Smallest Countries by 2022 Population:** df.sort\_values(by='2022 Population').head(10)
        
    *   **Top 10 Largest Countries by 2022 Population:** df.sort\_values(by='2022 Population', ascending=False).head(10)
        <br>
4.  **Correlation Analysis:**
    
    *   **Correlation Matrix:** df.select\_dtypes(include=\['int', 'float'\]).corr()
        
    *   **Heatmap Visualization:** sns.heatmap(df.select\_dtypes(include=\['int', 'float'\]).corr(), annot=True)
        <br>
5.  **Continental Analysis:**
    
    *   **Mean Population and Growth of Continents:** df.groupby(\['Continent'\]).mean(numeric\_only=True)
        
    *   **Total Population Contribution by Continent:** df.groupby(\['Continent'\])\['World Population Percentage'\].sum().sort\_values(ascending=False)
        
    *   **Comparison of Area and World Population Percentage:** The analysis reveals that while generally larger areas contribute to a higher population percentage, Europe and North America deviate from this trend. North America, despite having a larger area than Europe, contributes less to the global population percentage: <br>
    df.groupby(\['Continent'\])\[\['World Population Percentage', 'Area (km²)'\]\].sum().sort\_values(by=\['Area (km²)'\], ascending=False)
        <br>
6.  **Population Growth Over Time:**
    
    *   **Line Chart of Population Growth by Continent:** The chart shows that Asia's population has consistently been high compared to other continents, with significant growth observed between 1990 and 2000. Post-2000, Asia's population growth has continued on an upward trajectory:<br> 
    df2 = df.groupby('Continent')\[\['1970 Population', '1980 Population', '1990 Population', '2000 Population', '2010 Population', '2015 Population', '2020 Population', '2022 Population'\]\].sum().sort\_values(by='2022 Population', ascending=False)
        <br>
7.  **Top 20 Countries Analysis:**
    
    *   **Rapid Growth Observation:** Among the top 20 countries, India has shown rapid population growth over the last 2-3 decades, significantly influencing Asia's population growth from 1990 onwards.
        <br>
8.  **Outlier Analysis:**
    
    *   **Box Plot Creation:** A box plot was created to identify outliers. In population data, outliers are common due to various influencing factors. While outliers are important to note, they may not always indicate data issues, as seen in revenue data where a single company earning significantly more than others might suggest data anomalies or insights which should be studied and understood.
        

Insights
--------

*   **Population Growth Trends:** Asia's population growth has been consistently high, with a notable surge between 1990 and 2000. India plays a crucial role in this trend.
    
*   **Area vs. World Population Percentage Comparison:** Generally, larger areas have a higher contribution to the world population. However, Europe and North America deviate from this trend. Despite North America having more land area than Europe, it contributes less to the global population percentage.
    
*   **Outliers in Population Data:** While outliers are expected in population data, they should be interpreted with caution, as they can be influenced by numerous factors rather than indicating data errors.
