### Project Summary: Web Scraping Data for Palm Beach (NSW) from Australian Census Site

#### Overview
This project involves scraping data for the suburb of Palm Beach (NSW) from the Australian Bureau of Statistics (ABS) website for the year 2021. The goal is to extract and clean data from an HTML page and store it in an Excel file for analysis.

#### Tools and Libraries Used
- **BeautifulSoup**: For parsing and extracting data from HTML content.
- **Requests**: For sending HTTP requests to fetch the webpage.
- **Pandas**: For organizing data and saving it to an Excel file.

#### Key Steps in the Project

1. **Fetch Data from URL**
   - A request is sent to the ABS website for the specified URL.
   - Example Code:
     ```python
     url = "https://www.abs.gov.au/census/find-census-data/quickstats/2021/SAL13143"
     page = requests.get(url)
     ```

2. **Parse HTML Content**
   - The HTML content is parsed and prettified for easier data extraction.
   - Example Code:
     ```python
     soup = BeautifulSoup(page.text, "html.parser")
     pretty_soup = BeautifulSoup(soup.prettify(), "html.parser")
     ```

3. **Extract and Clean Data**
   - Data is extracted from HTML elements using BeautifulSoup. Text is stripped of extra spaces and newlines.
   - Example Code:
     ```python
     entire_data = pretty_soup.find_all(['th', 'td'])
     paragraph_texts = [p.get_text().strip() for p in entire_data]
     ```

4. **Create DataFrames**
   - Two separate DataFrames are created to store data from two different parts of the HTML table.
   - Example Code:
     ```python
     df1 = pd.DataFrame(columns=['Data', 'Title'])
     df2 = pd.DataFrame(columns=['Col1', 'Col2', 'Col3', 'Col4', 'Col5', 'Col6', 'Col7'])
     ```

5. **Populate DataFrames**
   - The first DataFrame (`df1`) is populated with data from the first part of the table.
   - The second DataFrame (`df2`) is populated with data from the second part of the table.
   - Example Code:
     ```python
     for i in range(0, len(summary1) - 1, 2):
         df1.loc[len(df1)] = [summary1[i], summary1[i + 1]]
     
     for i in range(0, len(summary2) - 6, 7):
         row_data = [summary2[i], summary2[i + 1], summary2[i + 2], summary2[i + 3], summary2[i + 4], summary2[i + 5], summary2[i + 6]] if i + 6 < len(summary2) else [None] * 7
         df2.loc[len(df2)] = row_data
     ```

6. **Save Data to Excel File**
   - The data is saved to an Excel file with two sheets: one for each DataFrame.
   - Example Code:
     ```python
     with pd.ExcelWriter('2021_data.xlsx') as writer:
         df1.to_excel(writer, sheet_name='Sheet1', index=False)
         df2.to_excel(writer, sheet_name='Sheet2', index=False)
     ```

This project demonstrates web scraping, data cleaning, and file handling using Python libraries to extract and save structured data for further analysis.
