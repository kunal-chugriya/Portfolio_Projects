# SQL Project Overview: Housing Data Cleaning

This project focuses on cleaning and transforming a housing dataset with over 56,000 records. The dataset contains transaction details, property information, sale prices, owner information, tax districts, and property attributes like land value, building value, and number of bedrooms/bathrooms. The objective was to make the dataset more suitable for analysis.

## Key Project Steps with Queries:

### 1. Understanding the Dataset
The dataset includes unique property IDs and transaction details. Key columns include `parcelid`, `propertyaddress`, `saledate`, `saleprice`, `ownername`, `taxdistrict`, `landvalue`, `buildingvalue`, `yearbuilt`, `bedrooms`, `fullbath`, and `halfbath`.

```sql
-- View the entire dataset
SELECT * FROM PortfolioProjects..HousingData$;
```

### 2. Date Format Cleaning

The `saledate` column in the dataset contained unnecessary time information (`00:00:00`) that wasn't relevant for analysis. This was cleaned by converting the datetime format into a simpler date format, and a new column `saledateconverted` was added to store the updated values.

#### Steps Taken:
1. A new column, `saledateconverted`, was added to store the converted sale dates.
2. The `CONVERT()` function was used to transform the original `saledate` column from datetime to date format.
3. The dataset was updated, and results were verified by comparing the original and converted columns.

#### SQL Queries:
```sql
-- Add new column to store formatted sale date
ALTER TABLE PortfolioProjects..HousingData$
ADD saledateconverted DATE;

-- Convert datetime to date and update the new column
UPDATE PortfolioProjects..HousingData$
SET saledateconverted = CONVERT(DATE, saledate);

-- Verify conversion by viewing the original and formatted sale dates
SELECT saledate, saledateconverted
FROM PortfolioProjects..HousingData$;
```
### 3. Handling Missing Property Address Values

In cases where the property address was missing (`NULL`), the data showed a pattern where the same `ParcelID` had other transactions with valid addresses. The missing addresses were populated by using the addresses from other records with the same `ParcelID`.

#### Steps Taken:
1. Identified records where `PropertyAddress` was missing.
2. Used a **self-join** to match records with the same `ParcelID` where one had an address and the other did not.
3. Updated the missing `PropertyAddress` values by copying data from records where it was available.

#### SQL Queries:
```sql
-- Select records with missing property address to observe the pattern
SELECT a.ParcelID, a.PropertyAddress, b.PropertyAddress, 
       ISNULL(a.PropertyAddress, b.PropertyAddress) AS UpdatedPropertyAddress
FROM PortfolioProjects..HousingData$ a
JOIN PortfolioProjects..HousingData$ b
  ON a.ParcelID = b.ParcelID  
  AND a.[UniqueID ] != b.[UniqueID ] 
  AND b.PropertyAddress IS NOT NULL;

-- Update missing property addresses using self-join
UPDATE b
SET PropertyAddress = ISNULL(b.PropertyAddress, a.PropertyAddress)
FROM PortfolioProjects..HousingData$ a
JOIN PortfolioProjects..HousingData$ b
  ON a.ParcelID = b.ParcelID  
  AND a.[UniqueID ] != b.[UniqueID ] 
  AND b.PropertyAddress IS NULL;

-- Re-run the query to ensure no records have missing property addresses
SELECT * FROM PortfolioProjects..HousingData$ 
WHERE PropertyAddress IS NULL;
```

### 4. Breaking Down Property Address into Individual Columns

The property address was originally stored as a single column, making it difficult for analysis. To improve clarity, the address was split into separate columns: `Address`, `City`, and `State`. This was achieved by using the `SUBSTRING` function along with `CHARINDEX` to extract parts of the address.

#### Steps Taken:
1. **Analyzed the Address Pattern:** The property address was delimited by commas (`,`).
2. **Extracted Components:** Used the `SUBSTRING` function to split the address into its constituent parts.
3. **Altered Table:** Added new columns (`Address` and `City`) to the table.
4. **Populated New Columns:** Used the `UPDATE` statement to fill the new columns with the extracted data.

#### SQL Queries:
```sql
-- Checking how many records contain commas, indicating address parts
SELECT COUNT(*)
FROM PortfolioProjects..HousingData$
WHERE PropertyAddress LIKE '%,%';

-- Extracting the first part of the address (up to the first comma)
SELECT PropertyAddress, 
       SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address1, 
       SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address2 
FROM PortfolioProjects..HousingData$;

-- Adding new columns for Address and City
ALTER TABLE PortfolioProjects..HousingData$
ADD Address NVARCHAR(255), City NVARCHAR(255);

-- Updating the Address column with the first part of the address
UPDATE PortfolioProjects..HousingData$
SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);

-- Updating the City column with the second part of the address
UPDATE PortfolioProjects..HousingData$
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

-- Verifying the results
SELECT PropertyAddress, Address, City 
FROM PortfolioProjects..HousingData$;

```

### 5. Breaking Down Owner's Address into Individual Columns

The owner's address, originally stored in a single column, was divided into three separate columns: `OwnderSplitAddress`, `OwnderSplitCity`, and `OwnderSplitProvince`. This was done to improve the organization of the data, making it more structured and easier to analyze.

#### Steps Taken:
1. **Analyzed the Address Pattern:** The owner's address was separated by commas, which was converted to periods (`.`) for easier parsing.
2. **Used `PARSENAME` Function:** The `PARSENAME` function was employed to split the address into its constituent parts.
3. **Altered Table:** Added new columns (`OwnderSplitAddress`, `OwnderSplitCity`, and `OwnderSplitProvince`) to the table.
4. **Populated New Columns:** Used `UPDATE` statements to fill the new columns with parsed data from the owner's address.

#### SQL Queries:
```sql
-- Checking how the parsename function works with the address after replacing commas with periods
SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS AddressPart1,
       PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS AddressPart2,
       PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS AddressPart3
FROM PortfolioProjects..HousingData$;

-- Adding new columns for Owner's Address, City, and Province
ALTER TABLE PortfolioProjects..HousingData$
ADD OwnderSplitAddress NVARCHAR(255),
    OwnderSplitCity NVARCHAR(255),
    OwnderSplitProvince NVARCHAR(255);

-- Updating the OwnderSplitAddress column with the first part of the owner's address
UPDATE PortfolioProjects..HousingData$
SET OwnderSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

-- Updating the OwnderSplitCity column with the second part of the owner's address
UPDATE PortfolioProjects..HousingData$
SET OwnderSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

-- Updating the OwnderSplitProvince column with the third part of the owner's address
UPDATE PortfolioProjects..HousingData$
SET OwnderSplitProvince = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

-- Verifying the results
SELECT OwnerAddress, OwnderSplitAddress, OwnderSplitCity, OwnderSplitProvince 
FROM PortfolioProjects..HousingData$;
```

### 6. Converting SoldAsVacant Values

The `SoldAsVacant` column had inconsistent data where some values were represented by 'Y' and 'N' instead of 'Yes' and 'No'. To standardize the data, the 'Y' and 'N' values were converted to 'Yes' and 'No' using a `CASE` statement.

#### Steps Taken:
1. **Checked Existing Values:** A `SELECT DISTINCT` query was used to identify the unique values present in the `SoldAsVacant` column.
2. **Used `CASE` Statement for Conversion:** A `CASE` statement was employed to convert 'Y' to 'Yes' and 'N' to 'No'.
3. **Implemented and Validated Conversion:** After updating the values, a `SELECT` query was used to ensure that the conversion was correctly applied.

#### SQL Queries:
```sql
-- Checking distinct values in SoldAsVacant column
SELECT DISTINCT SoldAsVacant 
FROM PortfolioProjects..HousingData$;

-- Updating SoldAsVacant column to convert 'Y' and 'N' to 'Yes' and 'No'
UPDATE PortfolioProjects..HousingData$
SET SoldAsVacant = CASE 
                     WHEN SoldAsVacant = 'Y' THEN 'Yes'
                     WHEN SoldAsVacant = 'N' THEN 'No'
                     ELSE SoldAsVacant
                   END;

-- Validating the update by checking distinct values and their counts
SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant) 
FROM PortfolioProjects..HousingData$
GROUP BY SoldAsVacant;
```

### 7. Removing Duplicate Rows

The dataset contained duplicate rows based on specific columns. To clean up these duplicates, the `ROW_NUMBER()` function was used within a Common Table Expression (CTE) to assign a unique row number to each record based on the selected columns. Rows with a row number greater than 1 were identified as duplicates and deleted.

#### Steps Taken:
1. **Used `ROW_NUMBER()` with Partitioning:** The `ROW_NUMBER()` function was used to assign unique numbers to rows partitioned by key columns such as `ParcelID`, `PropertyAddress`, `SaleDate`, etc.
2. **Created CTE:** A CTE was created to hold the row numbers, and rows where the row number was greater than 1 were identified as duplicates.
3. **Deleted Duplicates:** These duplicate rows were then deleted using the CTE.

#### SQL Queries:
```sql
-- Using ROW_NUMBER() to identify duplicate rows
WITH RwnumCTE AS (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference, OwnerName, OwnerAddress, TaxDistrict, LandValue, BuildingValue, TotalValue, YearBuilt, Bedrooms, FullBath, HalfBath
                       ORDER BY UniqueID) AS rnum
  FROM PortfolioProjects..HousingData$
)

-- Selecting records where row number is greater than 1 (duplicates)
SELECT * 
FROM RwnumCTE 
WHERE rnum > 1 
ORDER BY UniqueID;

-- Deleting duplicate rows
DELETE FROM RwnumCTE 
WHERE rnum > 1;

-- Checking again to ensure no duplicates remain
SELECT * 
FROM RwnumCTE 
WHERE rnum > 1 
ORDER BY UniqueID;

```

## Summary

### Project Overview
The Housing Data Cleaning Project involved cleaning and transforming a dataset with over 56,000 records related to property transactions. The dataset included details such as sale price, property and owner addresses, and various property features. The main goal was to ensure data consistency and accuracy by addressing issues like incorrect date formats, missing values, and duplicate records.

### Approach and Actions Taken

1. **Date Format Correction**
   - Converted `SaleDate` from datetime format with a time component to a date-only format to simplify analysis.

2. **Handling Null Property Addresses**
   - Populated missing property addresses by using self-joins to merge available address data based on matching `ParcelID`.

3. **Splitting Property Address**
   - Separated `PropertyAddress` into `Address` and `City` columns using string functions for better analysis and reporting.

4. **Splitting Owner’s Address**
   - Parsed `OwnerAddress` into `OwnerSplitAddress`, `OwnerSplitCity`, and `OwnerSplitProvince` using string manipulation functions to standardize the address format.

5. **Standardizing SoldAsVacant Column**
   - Transformed 'Y' and 'N' values in the `SoldAsVacant` column to 'Yes' and 'No' for consistency and clarity.

6. **Removing Duplicates**
   - Identified and removed duplicate rows based on key columns using the `ROW_NUMBER()` function within a CTE to ensure each transaction was unique.

7. **Deleting Unused Columns**
   - Planned to remove obsolete columns such as `OwnerAddress`, `PropertyAddress`, and `SaleDate` after their data had been integrated into other columns.

### Outcome
The data was cleaned and standardized, with improvements made to address formatting issues, null values, and duplicates. This cleanup facilitates more accurate analysis and reporting of housing data.


