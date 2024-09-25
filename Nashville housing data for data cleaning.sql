SELECT * FROM portfolio_project_covid.`nashville housing data for data cleaning`;


-- populate property address data

SELECT * 
FROM portfolio_project_covid.`nashville housing data for data cleaning`
-- where PropertyAddress = ''
order by ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM portfolio_project_covid.`nashville housing data for data cleaning` a
join portfolio_project_covid.`nashville housing data for data cleaning` b
	on a.ParcelID = b.ParcelID
    and a.`ï»¿UniqueID` <> b.`ï»¿UniqueID`
where a.PropertyAddress = '';

UPDATE portfolio_project_covid.`nashville housing data for data cleaning` a
JOIN portfolio_project_covid.`nashville housing data for data cleaning` b
	on a.ParcelID = b.ParcelID
    and a.`ï»¿UniqueID` <> b.`ï»¿UniqueID`
SET a.PropertyAddress = b.PropertyAddress
WHERE a.PropertyAddress = '';


-- divide address into individual columns (address, city, state)

SELECT PropertyAddress
FROM portfolio_project_covid.`nashville housing data for data cleaning`
-- where PropertyAddress = ''
-- order by ParcelID;


SELECT SUBSTRING(PropertyAddress, 1, INSTR(PropertyAddress, ',') - 1) AS Address,
SUBSTRING(PropertyAddress, INSTR(PropertyAddress, ',') + 1, length(PropertyAddress)) AS Address
FROM portfolio_project_covid.`nashville housing data for data cleaning`;


alter table portfolio_project_covid.`nashville housing data for data cleaning`
add PropertySplitAddress nvarchar(255)

update portfolio_project_covid.`nashville housing data for data cleaning`
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, INSTR(PropertyAddress, ',') - 1)

alter table portfolio_project_covid.`nashville housing data for data cleaning`
add PropertySplitCity nvarchar(255)

update portfolio_project_covid.`nashville housing data for data cleaning`
set PropertySplitCity = SUBSTRING(PropertyAddress, INSTR(PropertyAddress, ',') + 1, length(PropertyAddress))

select PropertyAddress, PropertySplitAddress, PropertySplitCity
FROM portfolio_project_covid.`nashville housing data for data cleaning`;


select OwnerAddress
from portfolio_project_covid.`nashville housing data for data cleaning`;

select substring_index(OwnerAddress, ',', 1) as Address,
substring_index(substring_index(OwnerAddress, ',', 2), ',', -1) AS City,
substring_index(OwnerAddress, ',', -1) as State
from portfolio_project_covid.`nashville housing data for data cleaning`;


alter table portfolio_project_covid.`nashville housing data for data cleaning`
add OwnerSplitAddress nvarchar(255)

update portfolio_project_covid.`nashville housing data for data cleaning`
set OwnerSplitAddress = substring_index(OwnerAddress, ',', 1)

alter table portfolio_project_covid.`nashville housing data for data cleaning`
add OwnerSplitCity nvarchar(255)

update portfolio_project_covid.`nashville housing data for data cleaning`
set OwnerSplitCity = substring_index(substring_index(OwnerAddress, ',', 2), ',', -1)

alter table portfolio_project_covid.`nashville housing data for data cleaning`
add OwnerSplitState nvarchar(255)

update portfolio_project_covid.`nashville housing data for data cleaning`
set OwnerSplitState = substring_index(OwnerAddress, ',', -1)

-- change y and n to yes and no in "Sold as Vacant" field

select distinct(SoldAsVacant), count(SoldAsVacant)
FROM portfolio_project_covid.`nashville housing data for data cleaning`
group by SoldAsVacant
order by 2


select SoldAsVacant,
case 
	when SoldAsVacant = 'Y' then 'Yes'
    when SoldAsVacant = 'N' then 'No'
    else SoldAsVacant
end
FROM portfolio_project_covid.`nashville housing data for data cleaning`


update portfolio_project_covid.`nashville housing data for data cleaning`
set SoldAsVacant = case 
	when SoldAsVacant = 'Y' then 'Yes'
    when SoldAsVacant = 'N' then 'No'
    else SoldAsVacant
end

-- Remove duplicates

with RowNumCTE as (
select *, row_number() over (partition by ParcelID, PropertyAddress, SalePrice,SaleDate,LegalReference
order by ï»¿UniqueID) row_num
FROM portfolio_project_covid.`nashville housing data for data cleaning`
)
select * from RowNumCTE
where row_num > 1
order by ParcelID


-- delete unused columns

alter table portfolio_project_covid.`nashville housing data for data cleaning`
drop column OwnerAddress, 
drop column TaxDistrict, 
drop column PropertyAddress



