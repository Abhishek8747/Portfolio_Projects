select * from Portfolio_Nashville_housing..Nashville_Housing

--Converting the data in to table

select * into Nashvillehousing from Portfolio_Nashville_housing..Nashville_Housing

--Standardizing the Date Formate

select SaleDate,convert(date,SaleDate)
from Nashvillehousing

update NashvilleHousing
set SaleDate = convert(date,SaleDate)

alter table Nashvillehousing
add Sale_date date;

update Nashvillehousing
set sale_date = convert(date,SaleDate)


--Populate Property Address data

select *
from Nashvillehousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from Nashvillehousing a
join Nashvillehousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Nashvillehousing a
join Nashvillehousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address,City,State)
select *
from Nashvillehousing
--where PropertyAddress is null
--order by ParcelID

select substring(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address
, substring(PropertyAddress, charindex(',',PropertyAddress)+1, len(PropertyAddress)) as Address
from Nashvillehousing

alter table Nashvillehousing
add Property_Address Nvarchar(255);

update Nashvillehousing
set Property_Address = substring(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) 


alter table Nashvillehousing
add Property_City Nvarchar(255);

update Nashvillehousing
set Property_City = substring(PropertyAddress, charindex(',',PropertyAddress)+1, len(PropertyAddress))


select OwnerAddress from Nashvillehousing


select PARSENAME(replace(OwnerAddress, ',','.'),3)
,PARSENAME(replace(OwnerAddress, ',','.'),2)
,PARSENAME(replace(OwnerAddress, ',','.'),1)
from Nashvillehousing


alter table Nashvillehousing
add Owner_Address Nvarchar(255);

update Nashvillehousing
set Owner_Address = PARSENAME(replace(OwnerAddress, ',','.'),3)

alter table Nashvillehousing
add Owner_City Nvarchar(255);

update Nashvillehousing
set Owner_City = PARSENAME(replace(OwnerAddress, ',','.'),2)


alter table Nashvillehousing
add Owner_State Nvarchar(255);

update Nashvillehousing
set Owner_State = PARSENAME(replace(OwnerAddress, ',','.'),1)


--Changing Y and N to Yes and No in SoldAsVacant

select distinct(SoldAsVacant)
from Nashvillehousing


select distinct(SoldAsVacant), count(SoldAsVacant)
from Nashvillehousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant end
from Nashvillehousing

update Nashvillehousing
set SoldAsVacant = 
case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant end


--Remove Duplicates (using temp table to check duplicate)

with Rownum_CTE as(
select *,row_number()over(partition by ParcelID,Property_Address,SalePrice,Sale_Date,LegalReference order by [UniqueID ])row_num
from Nashvillehousing)
select * from Rownum_CTE
where row_num > 1

delete from Rownum_CTE
where row_num > 1
--order by Property_Address


--Delete unused columns

select * from Nashvillehousing

alter table Nashvillehousing
 drop column OwnerAddress,SaleDate,PropertyAddress,TaxDistrict



