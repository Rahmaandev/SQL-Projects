-- Step 1; I created table "tbl_brew" and imported data from csv file

create table "tbl_brew" (
"SALES_ID" numeric,
"SALES_REP" text,
"EMAILS" text,
"BRANDS" text,
"PLANT_COST" numeric,
"UNIT_PRICE" numeric,
"QUANTITY" numeric,
"COST" numeric,
"PROFIT" numeric,
"COUNTRIES" text,
"REGION" text,
"MONTHS" text,
"YEARS" numeric
);

-- Step 2; I create a new table "tbl_brew_new" from the 1st one with 
-- the inclusion of a new column 'Territory'

create table "tbl_brew_new" as
	select *, 
			case when "COUNTRIES" in ('Ghana', 'Nigeria') 
			then 'Anglophone'
			else 'Francophone' end as "Territory"
	from tbl_brew
	
-- Step 3; I proceeded to answer the Questions

			-- Session A: Profit Analysis
			
-- Q1: Profit of the breweries in the last 3 years including 
-- anglophone and francophone territories

select sum("PROFIT") as "Total_Profit"
	from tbl_brew;
	
	-- Answer = 105,587,420
	
-- Q2: Compare Profits between the 2 territories

select "Territory", sum("PROFIT") as "Total_Profit"
from tbl_brew_new
group by "Territory"	
order by "Total_Profit" desc;

	-- Answer: Francophone = 63,198,160
	-- 	 	   Anglophone  = 42,389,260
	
-- Q3: Country with highest profit in 2019

select "COUNTRIES", sum("PROFIT") as "Total_Profit"
from tbl_brew
where "YEARS" = 2019
group by "COUNTRIES"
order by "Total_Profit" desc
limit 1;

	-- Answer = Ghana
	
-- Q4: Year with highest profit

select "YEARS", sum("PROFIT") as "Total_Profit"
from tbl_brew
group by "YEARS"
order by "Total_Profit" desc
limit 1;

	-- Answer = 2017
	
-- Q5: Month in the 3 years with lowest profit
	
select "YEARS", "MONTHS", sum("PROFIT") as "Total_Profit"
from tbl_brew
group by "YEARS", "MONTHS"
order by "Total_Profit" asc;

	-- Answer = February, 2019
	
-- Q6: Minimum profit in December 2018

select "PROFIT"
from tbl_brew
where "YEARS" = 2018 AND "MONTHS" = 'December'
order by "PROFIT" asc
limit 1
	
	-- Answer = 38,150
	
-- Q7: Compare Percentage Profit for the months in 2019

select "MONTHS", round((sum("PROFIT")/sum("COST")) *100,2) as "Percent_Profit"
from tbl_brew
where "YEARS" = 2019
group by "MONTHS"
order by "Percent_Profit";
	
	-- Answer = Table displayed
	
-- Q8: Brand with the highest profit in Senegal

select "BRANDS", sum("PROFIT") as "Total_Profit"
from tbl_brew
where "COUNTRIES" ='Senegal'
group by "BRANDS"
order by "Total_Profit" desc
limit 1;

	-- Answer = Castle lite
	
				-- Session B: Brand Analysis
				
-- Q1: Top 3 brands consumed in francophone countries 
-- 		in the last 2 years

select "BRANDS", sum("QUANTITY") as "Total_Qty"
from tbl_brew_new
where "YEARS" in (2018, 2019) and "Territory" = 'Francophone'
group by "BRANDS"
order by "Total_Qty" desc
limit 3;
		
	-- Answer = Trophy, Hero and Eagle lager
	
-- Q2: Top 2 choice of consumer's brand in Ghana

select "BRANDS", sum("QUANTITY") as "Total_Qty"
from tbl_brew
where "COUNTRIES" = 'Ghana'
group by "BRANDS"
order by "Total_Qty" desc
limit 2;

	-- Answer = Eagle lager and Castle lite
	
-- Q3: The details of the beer consumed in the oil rich West Africa
--		country in the last 3 years

select "BRANDS", 
		round (avg("PLANT_COST"),2) as "Unit_Plant_Cost",
		round (avg("UNIT_PRICE"),2) as "Unit_Price",
		sum("QUANTITY") as "Total_Qty",
		sum("COST") as "Total_Cost",
		sum("PROFIT") as "Total_Profit"
from tbl_brew
where "COUNTRIES" = 'Nigeria' and ("BRANDS" not like '%malt')
group by "BRANDS"
order by "Total_Profit";

	-- Answer = Table DIsplayed

-- Q4: Favourite malt brand in Anglophone between 2018 and 2019

select "BRANDS", sum("QUANTITY") as "Total_Qty"
from tbl_brew_new
where "Territory" ='Anglophone' 
	and "YEARS" in (2018, 2019) 
	and "BRANDS" like '%malt'
group by "BRANDS"
order by "Total_Qty" desc
limit 1;

	-- Answer = Grand Malt

-- Q5: Brand that sold highest in 2019 in Nigeria

select "BRANDS", sum("QUANTITY") as "Total_Qty"
from tbl_brew
where "COUNTRIES" = 'Nigeria' and "YEARS" = 2019
group by "BRANDS"
order by "Total_Qty" desc
limit 1;

	-- Answer = Hero
	
-- Q6: Favourite brand in South_south region in Nigeria

select "BRANDS", sum("QUANTITY") as "Total_Qty"
from tbl_brew
where "REGION" = 'southsouth' and "COUNTRIES" ='Nigeria'
group by "BRANDS"
order by "Total_Qty" desc
limit 1;

	-- Answer = Eagle lager

-- Q7: Beer consumption in Nigeria

select "BRANDS", sum("QUANTITY") as "Qty_Consumed_in_Nigeria"
from tbl_brew
where "BRANDS" not like '%malt'
group by "BRANDS"
order by "Qty_Consumed_in_Nigeria" desc;

	-- Answer = Table DIsplayed
	
-- Q8: Comsuption of Budweiser in the regions in Nigeria

select "REGION", sum("QUANTITY") as "Budweiser_qty_consumed"
from tbl_brew
where "BRANDS" = 'budweiser' and "COUNTRIES" = 'Nigeria'
group by "REGION"

	-- Answer = Table DIsplayed
	
-- Q9: Comsuption of Budweiser in the regions in Nigeria in 2019

select "REGION", sum("QUANTITY") as "Budweiser_qty_consumed"
from tbl_brew
where "BRANDS" = 'budweiser' and "COUNTRIES" = 'Nigeria' and "YEARS" = 2019
group by "REGION"

	-- Answer = Table DIsplayed

				-- Session C: Countries Analysis
				
-- Q1:  Country with the highest consumption of Beer

select "COUNTRIES", sum("QUANTITY") as "Total_Qty"
from tbl_brew
where "BRANDS" not like '%malt'
group by "COUNTRIES"
order by "Total_Qty" desc
limit 1;

	-- Answer = Senegal
	
-- Q2:  Highest sales personnel of Budweiser in Senegal

select "SALES_REP", sum("QUANTITY") as "Total_Qty"
from tbl_brew
where "BRANDS" ='budweiser' and "COUNTRIES" = 'Senegal'
group by "SALES_REP"
order by "Total_Qty" desc
limit 1;

	-- Answer = Jones
	
-- Q2:  Country with the highest profit in Q4 2019

select "COUNTRIES", sum("PROFIT") as "Total_Profit"
from tbl_brew
where "MONTHS" in ('October', 'November','December')
		and "YEARS" = 2019
group by "COUNTRIES"
order by "Total_Profit" desc
limit 1;

	-- Answer = Ghana
		
