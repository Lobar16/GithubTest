/*
SQL Tasks 

Summary of Data Given at the bottom of the this file:
-	The data in table [dbo].[sql_test_delivery] contains transactional data for different types of fuel deliveries
-	Each delivery for an Account (account id & name) and Tank (tank_number) belongs to a 
CSC (csc) that rolls under a Region (csc_region) which is under a Business Unit (csc_bu)
-	The number of Units delivered in gallons is in column Units_Delivered 
-	The total capacity of a tank is in column Tank_useable_size
-	Fill % = (Units_Delivered / Tank_useable_size) *100
-	If Fill% >95, it is an “Out of Gas”,
            >=25 % and <= 95%, it is a “Regular Fill”,
           <25%, it is an “Inefficient Fill”,
           = 0, it is a “Zero Fill” 
-	Collectively, these 4 classifications above are known as Fill Types
-	The combination of Account, Db, and Trx_Unique_key is unique for each delivery/record in this table.

Please make sure that SQL code are error free and executable. The expectation is that every query should return data.
1)	Design a SQL code that gives a new column which will identify every delivery by its fill type. (Out of gas, Zero Fill, Inefficient, Regular Fill)
For example, if Fill % = 50, then the new column should have a value as “Regular Fill”
The code should include the calculation of Fill %.
*/
;with cte as (
select *,(iif(Units_Delivered=0,Null,Units_Delivered)/iif(Tank_useable_size=0,Null,Tank_useable_size))*100 as fill  from [dbo].[sql_test_delivery]
)
select *,case when Fill>95 then 'Out of Gas'
        when  Fill>=25  and Fill<=95 then 'Regular Fill'
        when Fill<25 then 'Inefficient Fill'
        when Fill is null then 'Zero Fill'
        when Fill=50 then 'Regular Fill' end as Fill_type
   from cte
 
/*2)	Design a SQL code that returns Max, Min & Average Fill % by CSC. Please round the overall result to 2 decimal places and sort the results by decreasing order of average values.
*/
;with cte as (
select csc_region,avg(iif(Units_Delivered=0,Null,Units_Delivered)/iif(Tank_useable_size=0,Null,Tank_useable_size))*100 as avg_fill from [dbo].[sql_test_delivery]
group by csc_region)
select *,case when avg_fill>95 then 'Out of Gas'
        when  avg_fill>=25  and avg_fill<=95 then 'Regular Fill'
        when avg_fill<25 then 'Inefficient Fill'
        when avg_fill is null then 'Zero Fill'
        when avg_fill=50 then 'Regular Fill' end as avg_fill_type
   from cte

   ;with cte as (
select csc_region,max(iif(Units_Delivered=0,Null,Units_Delivered)/iif(Tank_useable_size=0,Null,Tank_useable_size))*100 as max_fill from [dbo].[sql_test_delivery]
group by csc_region)
select *,case when max_fill>95 then 'Out of Gas'
        when  max_fill>=25  and max_fill<=95 then 'Regular Fill'
        when max_fill<25 then 'Inefficient Fill'
        when max_fill is null then 'Zero Fill'
        when max_fill=50 then 'Regular Fill' end as avg_fill_type
   from cte

   ;with cte as (
select csc_region,min(iif(Units_Delivered=0,Null,Units_Delivered)/iif(Tank_useable_size=0,Null,Tank_useable_size))*100 as min_fill from [dbo].[sql_test_delivery]
group by csc_region)
select *,case when min_fill>95 then 'Out of Gas'
        when  min_fill>=25  and min_fill<=95 then 'Regular Fill'
        when min_fill<25 then 'Inefficient Fill'
        when min_fill is null then 'Zero Fill'
        when min_fill=50 then 'Regular Fill' end as avg_fill_type
   from cte

/*3)	Design a SQL code that returns the Delivery Date, Units Delivered, Tank Useable Size & Fill % for all “Out of Gas” deliveries belonging to CSC= “1550 Marlboro, NY”  
*/
select *,(iif(Units_Delivered=0,Null,Units_Delivered)/iif(Tank_useable_size=0,Null,Tank_useable_size))*100 as Fill ,
case when (iif(Units_Delivered=0,Null,Units_Delivered)/iif(Tank_useable_size=0,Null,Tank_useable_size))*100>95 then 'Out of Gas'
     when (iif(Units_Delivered=0,Null,Units_Delivered)/iif(Tank_useable_size=0,Null,Tank_useable_size))*100>=25  and (iif(Units_Delivered=0,Null,Units_Delivered)/iif(Tank_useable_size=0,Null,Tank_useable_size))*100<=95 then 'Regular Fill'
     when (iif(Units_Delivered=0,Null,Units_Delivered)/iif(Tank_useable_size=0,Null,Tank_useable_size))*100<25 then 'Inefficient Fill'
	 when (iif(Units_Delivered=0,Null,Units_Delivered)/iif(Tank_useable_size=0,Null,Tank_useable_size))*100 is null then 'Zero Fill'
     when (iif(Units_Delivered=0,Null,Units_Delivered)/iif(Tank_useable_size=0,Null,Tank_useable_size))*100=50 then 'Regular Fill' end as Fill_type
	 from [dbo].[sql_test_delivery]
/*
4)	This table has duplicate entries. Design a SQL code that returns all duplicate rows all with their counts. 
*/
select count(*) from  [dbo].[sql_test_delivery]

/*
5)	Design a SQL code that will delete all duplicate entries with a single query and no intermediate table. Please mention counts before the delete query, count of duplicate rows, and counts after execution of delete query.
*/
select distinct(Delivery_Class) from [dbo].[sql_test_delivery]
--after deleting duplicat rows leave 3 rows
--before deleting 10043

/*
6)	Design a SQL code that will return all Regions and their Products with total sales > $52,000
*/
select csc_region, Product_Class from [dbo].[sql_test_delivery]
where Product_Sale_Amount>52

/*
7)	Design a SQL code that will return the product with 3rd highest margin for every CSC. Margin can be calculated at a delivery level (product sale amount – product cost)
*/
select top 3 Product_Sale_Amount-Product_Cost as margin  , csc from [dbo].[sql_test_delivery]
order by margin desc
/*
8)	Design a SQL code that will return the CSC with the 5th highest margin
*/
select top 5 Product_Sale_Amount-Product_Cost as margin , csc from [dbo].[sql_test_delivery]
order by margin desc
/*
9)	In the column “CSC”, the last 2 characters are the initials for the State the CSC belongs. Write a SQL query that will extract the STATE initials from the field CSC.

For example: 1280 Rome, NY will have NY as the output of above query.

10)	With data in the below table, swap all NBC and CBS values (i.e., change all NBC values to CBS and vice versa) with a single update query and no intermediate temp table.
Table Name: SHOWS_NETWORKS
ID	Show	Network
1	AAA	NBC
2	BBB	NBC
3	CCC	CBS
4	DDD	CBS

*/
