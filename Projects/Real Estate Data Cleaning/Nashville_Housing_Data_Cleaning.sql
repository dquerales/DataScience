/*
	Nashville Housing Data for Cleaning Example
*/
USE nashville;

-- check data
SELECT *
FROM nashvillehousingdata;

/*
  1) standardize sale date
*/
-- add a new column
ALTER TABLE nashvillehousingdata
ADD saledate_converted DATE;

-- Update SaleDate column
SET SQL_SAFE_UPDATES = 0;
UPDATE nashvillehousingdata
SET saledate_converted  = CONVERT(SaleDate, DATE);
SET SQL_SAFE_UPDATES = 1;

/*
  2) Property Address
*/

-- check for nulls
SELECT PropertyAddress
FROM nashvillehousingdata
WHERE PropertyAddress IS NULL;

-- count how many nulls
SELECT COUNT(uniqueid) AS MissingAddress
FROM nashvillehousingdata
WHERE PropertyAddress IS NULL;

-- look for missing address with same parcelid
SELECT *
FROM nashvillehousingdata
GROUP BY parcelid;

-- join
SELECT a.uniqueid, a.ParcelID, a.PropertyAddress, b.uniqueid, b.ParcelID, b.PropertyAddress, IFNULL(a.PropertyAddress, b.PropertyAddress)
FROM nashvillehousingdata AS a
JOIN nashvillehousingdata AS b ON a.parcelid = b.parcelid AND a.uniqueid <> b.uniqueid
WHERE a.PropertyAddress IS NULL;

-- update new address
SET SQL_SAFE_UPDATES = 0;
UPDATE nashvillehousingdata AS a
JOIN nashvillehousingdata AS b ON a.parcelid = b.parcelid AND a.uniqueid <> b.uniqueid
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;
SET SQL_SAFE_UPDATES = 1;

/*
  3) Separate Address
*/

-- extract zipcode
SELECT PropertyAddress, SUBSTRING_INDEX(PropertyAddress, ' ', 1) AS Zipcode
FROM nashvillehousingdata;

-- check for errors
SELECT PropertyAddress, SUBSTRING_INDEX(PropertyAddress, ' ', 1) AS Zipcode
FROM nashvillehousingdata
where convert(SUBSTRING_INDEX(PropertyAddress, ' ', 1), UNSIGNED) =  0;

-- set as null if there is no zipcode
SELECT PropertyAddress, IF(convert(SUBSTRING_INDEX(PropertyAddress, ' ', 1), UNSIGNED) =  0, NULL, convert(SUBSTRING_INDEX(PropertyAddress, ' ', 1), UNSIGNED))  AS Zipcode
FROM nashvillehousingdata;

-- add zipcode column
ALTER TABLE nashvillehousingdata
-- DROP COLUMN zipcode;
ADD zipcode CHAR(255);

-- Update zipcode column (error)
SET SQL_SAFE_UPDATES = 0;
UPDATE nashvillehousingdata
SET zipcode  = view_zipcode.Zipcode;
SET SQL_SAFE_UPDATES = 1;

-- extract the city
SELECT PropertyAddress, SUBSTRING_INDEX(PropertyAddress, ' ', -1) AS City
FROM nashvillehousingdata;

-- add a new column for city
ALTER TABLE nashvillehousingdata
ADD city NVARCHAR(255);

-- Update zipcode column
SET SQL_SAFE_UPDATES = 0;
UPDATE nashvillehousingdata
SET city  = SUBSTRING_INDEX(PropertyAddress, ' ', -1);
SET SQL_SAFE_UPDATES = 1;

-- split owner address
SELECT SUBSTRING(OwnerAddress, 1, Locate(',', OwnerAddress) -1 ), SUBSTRING(OwnerAddress, Locate(',', OwnerAddress) + 1 , CHAR_LENGTH(OwnerAddress))
From nashvillehousingdata;