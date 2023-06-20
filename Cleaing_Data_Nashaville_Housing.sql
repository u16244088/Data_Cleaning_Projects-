-- Cleaning the data 


select * from Nashaville_Housing
where OwnerName is null;


-- Standadizing the date format
select SaleDate , convert(date, SaleDate) as New_SaleDate
from Nashaville_Housing

update Nashaville_Housing
set SaleDate=convert(date,SaleDate) 

-- since the top ,method is not working am gonna use another method of creating a new column named SaleDateConverted
Alter table Nashaville_Housing
add SaleDateConverted date;

Alter table Nashaville_Housing
drop column SaleDate

update Nashaville_Housing
set SaleDateConverted=convert(date,SaleDate)

-- populating the property address data
select PropertyAddress
from Nashaville_Housing
Where PropertyAddress is null;

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from Nashaville_Housing as a
join Nashaville_Housing as b
on  a.ParcelID=b.ParcelID
and a.[UniqueID ]<>B.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

update a
set a.PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from Nashaville_Housing as a
join Nashaville_Housing as b
on  a.ParcelID=b.ParcelID
and a.[UniqueID ]<>B.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

--Breaking out the address into indivivual columns(Address, City , State)
Alter table Nashaville_Housing
add Address_OF_Property varchar(50);

select * from Nashaville_Housing
update Nashaville_Housing
set Address_OF_Property=SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) 
from Nashaville_Housing

Alter table Nashaville_Housing
add Property_City varchar(50);

update Nashaville_Housing
SET Property_City=SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) 
from Nashaville_Housing

-- breaking out the owner address using parsename instead of substring

Alter Table Nashaville_Housing
add Owner_State varchar(50);
update Nashaville_Housing
set Owner_State=PARSENAME(Replace(OwnerAddress,',','.'),1)

Alter table Nashaville_Housing
add Owner_City varchar(50);
update Nashaville_Housing
set Owner_City=PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter table Nashaville_Housing
add Owner_Address varchar(50);
update Nashaville_Housing
set Owner_Address=PARSENAME(Replace(OwnerAddress,',','.'),3)

-- change N or Y on Sold As Vacant to No or Yes
select SoldAsVacant
from Nashaville_Housing

select Distinct(SoldAsVacant), Count(SoldAsVacant)
from Nashaville_Housing
group by SoldAsVacant

update Nashaville_Housing
set SoldAsVacant=case 
					when SoldAsVacant='Y' THEN 'Yes'
					when SoldAsVacant='Yes' Then 'Yes'
					when SoldAsVacant='N' Then 'No'
					when SoldAsVacant='No' then 'No'
end 

-- Removing the Duplicates
with RowNumCTE AS (
select *, Row_Number() over( Partition by ParcelID,PropertyAddress,SalePrice,OwnerName,LegalReference
order by UniqueID) row_num
from Nashaville_Housing)
Delete 
from RowNumCTE
where row_num>1

-- Deleting unused columns

select * from Nashaville_Housing

Alter table Nashaville_Housing
drop column PropertyAddress, OwnerAddress;












