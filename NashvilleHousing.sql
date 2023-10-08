--Cleaning Data

SELECT
	*
FROM 
	PortifolioProject..NashvilleHousing



-- Standardize Date Format

SELECT
	SaleDate, CONVERT(Date, SaleDate)
FROM 
	PortifolioProject..NashvilleHousing

--UPDATE NashvilleHousing
--SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE 
	NashvilleHousing
ALTER COLUMN 
	SaleDate DATE 

SELECT
	SaleDate
FROM 
	PortifolioProject..NashvilleHousing



-- Populate NULL Property Address data

SELECT
	*
FROM 
	PortifolioProject..NashvilleHousing
--WHERE  	PropertyAddress IS NULL
ORDER BY
	ParcelID

SELECT
	a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM 
	PortifolioProject..NashvilleHousing a
JOIN PortifolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET 
	PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM 
	PortifolioProject..NashvilleHousing a
JOIN PortifolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL



-- Breaking out Address into Individual Columns (Address, City, State)

SELECT
	PropertyAddress
FROM 
	PortifolioProject..NashvilleHousing

SELECT
	SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress) -1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
	--, CHARINDEX(',', PropertyAddress) 
FROM 
	PortifolioProject..NashvilleHousing

ALTER TABLE 
	NashvilleHousing
ADD 
	PropertySplitAddress NVARCHAR(255);

UPDATE
	NashvilleHousing
SET 
	PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress) -1) 

ALTER TABLE 
	NashvilleHousing
ADD 
	PropertySplitCity NVARCHAR(255);

UPDATE 
	NashvilleHousing
SET 
	PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM 
	PortifolioProject..NashvilleHousing

SELECT 
	OwnerAddress
FROM 
	PortifolioProject..NashvilleHousing

SELECT 
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
FROM 
	PortifolioProject..NashvilleHousing

ALTER TABLE 
	NashvilleHousing
ADD 
	OwnerSplitAddress NVARCHAR(255);

UPDATE
	NashvilleHousing
SET 
	OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE 
	NashvilleHousing
ADD 
	OwnerSplitCity NVARCHAR(255);

UPDATE
	NashvilleHousing
SET 
	OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE 
	NashvilleHousing
ADD 
	OwnerSplitState NVARCHAR(255);

UPDATE
	NashvilleHousing
SET 
	OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)





-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT
	(SoldAsVacant), COUNT(SoldAsVacant)
FROM 
	PortifolioProject..NashvilleHousing
GROUP BY 
		SoldAsVacant
ORDER BY 2

SELECT
	SoldAsVacant,
	CASE
		WHEN SoldAsVacant = 'Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
		END
FROM 
	PortifolioProject..NashvilleHousing

UPDATE 
	NashvilleHousing
SET SoldAsVacant = CASE
		WHEN SoldAsVacant = 'Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
		END



-- Remove Duplicates

WITH RowNumCTE AS (
SELECT
	*, ROW_NUMBER() OVER (
						PARTITION BY 
							ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference
							ORDER BY UniqueID
							) row_number
FROM
	PortifolioProject..NashvilleHousing
--ORDER BY 	ParcelID
)
DELETE
FROM
	RowNumCTE
WHERE
	row_number > 1
--ORDER BY PropertyAddress

WITH RowNumCTE AS (
SELECT
	*, ROW_NUMBER() OVER (
						PARTITION BY 
							ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference
							ORDER BY UniqueID
							) row_number
FROM
	PortifolioProject..NashvilleHousing
--ORDER BY 	ParcelID
)
SELECT *
FROM
	RowNumCTE
WHERE
	row_number > 1
ORDER BY PropertyAddress



-- Delete Unused Columns
SELECT *
FROM
	PortifolioProject..NashvilleHousing

ALTER TABLE 
	PortifolioProject..NashvilleHousing
DROP COLUMN
OwnerAddress, TaxDistrict, PropertyAddress