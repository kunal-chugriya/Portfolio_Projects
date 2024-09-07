---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1) ENTIRE DATA
SELECT *
  FROM PortfolioProjects..HousingData$;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2) PROPER DATE FROMAT FOR SALEDATE

select saledate,convert(date,saledate) from PortfolioProjects..HousingData$;

Alter table PortfolioProjects..HousingData$
add saledateconverted date;

Update PortfolioProjects..HousingData$
set saledateconverted = convert(date,saledate);


select saledate,convert(date,saledate) as formatted_sale_date from PortfolioProjects..HousingData$;

-- Here if tried with saledate directly it didn't work. Maybe because trying to assign value of one variable to same variable.
-- Mostly not the correct explanation but don't know.

SELECT *
  FROM PortfolioProjects..HousingData$;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3) HANDLING PROPERTY ADDRESS I.E. NULL VALUES. OBSERVED PATTERN IN THE DATA IS SAMEPARCELID HAS SAME PROPERTY ADDRESS. 
-- IF ONE ID HAS PROPERTY ADDRESS AND OTHER DOES NOT THEN WE WILL POPULATE IT WITH WHEREVER THE DATA IS PRESENT.


SELECT a.ParcelID,a.PropertyAddress,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
  FROM PortfolioProjects..HousingData$ a, PortfolioProjects..HousingData$ b

  where a.ParcelID=b.ParcelID  
  and a.[UniqueID ]!= b.[UniqueID ] and 
  b.PropertyAddress is not null;


  update b
  set PropertyAddress = isnull(b.PropertyAddress,a.PropertyAddress) 

  FROM PortfolioProjects..HousingData$ a, PortfolioProjects..HousingData$ b

  where a.ParcelID=b.ParcelID  
  and a.[UniqueID ]!= b.[UniqueID ] and 
  b.PropertyAddress is null;

  

  -- RUN ABOVE QUERY AGAIN AND CHECK NO RECORDS SHOULD BE OBTAINED.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 4) Breaking address into individual columns i.e. address,city, state

select count(*)
from PortfolioProjects..HousingData$;
--56477 records

select count(*)
from PortfolioProjects..HousingData$ where PropertyAddress like '%,%';
-- 56477

--SUBSTRING(expression, start, length)
-- charindex(delimiter,column)

select PropertyAddress,SUBSTRING(propertyaddress,1,CHARINDEX(',',PropertyAddress)-1) address1
,SUBSTRING(propertyaddress,CHARINDEX(',',PropertyAddress)+1,len(propertyaddress) ) address2 
from PortfolioProjects..HousingData$;


ALTER TABLE PortfolioProjects..HousingData$
ADD Address varchar(255);

alter table PortfolioProjects..HousingData$
ALTER COLUMN Address nvarchar(255);

ALTER TABLE PortfolioProjects..HousingData$
ADD City nvarchar(255);

update PortfolioProjects..HousingData$
set Address = SUBSTRING(propertyaddress,1,CHARINDEX(',',PropertyAddress)-1)
from PortfolioProjects..HousingData$;

update PortfolioProjects..HousingData$
set City = SUBSTRING(propertyaddress,CHARINDEX(',',PropertyAddress)+1,len(propertyaddress) ) 
from PortfolioProjects..HousingData$;

select PropertyAddress,SUBSTRING(propertyaddress,1,CHARINDEX(',',PropertyAddress)-1) Address,
Address
,SUBSTRING(propertyaddress,CHARINDEX(',',PropertyAddress)+1,len(propertyaddress) ) City,
city
from PortfolioProjects..HousingData$;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--5) Breaking owner's address into individual columns i.e. address,city, state

select parsename(replace(OwnerAddress,',','.'),3),
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),1)
from PortfolioProjects..HousingData$;


alter table PortfolioProjects..HousingData$
ADD  OwnderSplitAddress nvarchar(255);

alter table PortfolioProjects..HousingData$
ADD  OwnderSplitCity nvarchar(255);

alter table PortfolioProjects..HousingData$
ADD  OwnderSplitProvince nvarchar(255);


UPDATE PortfolioProjects..HousingData$
SET OwnderSplitAddress = parsename(replace(OwnerAddress,',','.'),3)
from PortfolioProjects..HousingData$;

UPDATE PortfolioProjects..HousingData$
SET OwnderSplitCity = parsename(replace(OwnerAddress,',','.'),2)
from PortfolioProjects..HousingData$;

UPDATE PortfolioProjects..HousingData$
SET OwnderSplitProvince = parsename(replace(OwnerAddress,',','.'),1)
from PortfolioProjects..HousingData$;


select OwnerAddress,OwnderSplitAddress,OwnderSplitCity,OwnderSplitProvince from PortfolioProjects..HousingData$;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--6) Update Y to Yes and N to No

select distinct soldasvacant from PortfolioProjects..HousingData$;


update PortfolioProjects..HousingData$
set SoldAsVacant = (case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
)
from PortfolioProjects..HousingData$;

select * from PortfolioProjects..HousingData$;


-- it's import to check ur logic in select statement first and then update. Because in above update I didn't give else part because of which Yes and No became null.
-- I had to delete all records and execute everything again.

select distinct soldasvacant,count(SoldAsVacant) from PortfolioProjects..HousingData$
group by SoldAsVacant
;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--7) Delete duplicate rows using rownumber on unique columns and deleteing those columns where rnum>1

with RwnumCTE AS (
select *,
ROW_NUMBER() over (partition by parcelid,propertyaddress,saledate,saleprice,legalreference,ownername,owneraddress,taxdistrict,landvalue,buildingvalue,
totalvalue,yearbuilt,bedrooms,fullbath,halfbath
order by uniqueid
) rnum
from PortfolioProjects..HousingData$

)



SELECT * FROM RwnumCTE where rnum>1
order by uniqueid


delete from RwnumCTE where rnum>1

SELECT * FROM RwnumCTE where rnum>1
order by uniqueid
;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--8) Delete unused columns.


select * from PortfolioProjects..HousingData$;


--Alter table PortfolioProjects..HousingData$
--drop column owneradress,propertyaddress,taxdistrict,saledate;

-- Above columns not execute but above can be used to drop columns