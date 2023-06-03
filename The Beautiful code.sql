-- When Importing the data into ssms, i encountered some data errors, so i decided to clean them
update movies_aqz.dbo.actor
set last_update = replace(last_update,'"','')  -- to remove unwanted inverted comma in author table

UPDATE Movies_Aqz.dbo.address
SET address_id = CAST(address_id AS NUMERIC); -- the address_id was imported as text, so i decided to change it to numeric so,
														--i can use the joins perfectly without errors

EXEC sp_rename 'Movies_Aqz.dbo.advisor.["last_name"]', 'last_name', 'COLUMN';      -- to change column name that has unwanted characters
--In the advisor table, i saw some errors in the column names with quotation marks, so i decided to remove them for data integrity 

--Question 1 : Managers name at each store with full address at each property

select a.address as Address,a.district as District, b.city as City, c.country as Country,    
	s.first_name + ' ' + s.last_name AS Managers_name 
from Movies_Aqz.dbo.address as a
join Movies_Aqz.dbo.city as b
		on a.city_id = b.city_id
join Movies_Aqz.dbo.country as c
		on c.country_id = b.country_id
CROSS JOIN
    Movies_Aqz.dbo.staff AS s;

 -- Question 2 complete
 select  inv.inventory_id,fil.title, inv.store_id, fil.rating, fil.rental_rate,fil.replacement_cost        
 from Movies_Aqz.dbo.film as fil
 inner join Movies_Aqz.dbo.inventory as inv
		on fil.film_id = inv.film_id    

-- Question 3: The Question says how many inventory items is available with each rating at the store
 select a.store_id , b.rating , count(distinct a.inventory_id) as total_merch        
 from Movies_Aqz.dbo.inventory as a
 join Movies_Aqz.dbo.film as b
		on a.film_id = b.film_id
group by a.store_id,b.rating    


-- Question 4: No of films, average replacement cost, total replacement cost sliced by store and category
select inv.store_id , cate.category_id,         
		count (film.title) as No_of_films ,  
		avg(film.replacement_cost) as Avg_replacement_cost,
		sum(film.replacement_cost) as Total_replacement_cost
		
FROM Movies_Aqz.dbo.film as film
inner join Movies_Aqz.dbo.film_category as cate
		on film.film_id = cate.category_id
inner join Movies_Aqz.dbo.inventory as inv
		on inv.film_id = cate.film_id
group by cate.category_id , inv.store_id
order by inv.store_id ,cate.category_id  desc

-- Question 5: Provide a list of all the customer,store they go to, whether active or not and their full address
select cut.first_name,cut.last_name,adre.address,cut.active,adre.address,city.city , cont.country 
from Movies_aqz.dbo.customer as cut
inner join Movies_aqz.dbo.address as adre        
		on cut.address_id = adre.address_id				-- Added a join 
inner join Movies_aqz.dbo.city as city
		on adre.city_id = city.city_id
inner join Movies_aqz.dbo.country as cont
		on cont.country_id = city.country_id 

-- Question 6: List of customers name, their total lifetime rentals, and the sum of payment collected from them
select coh.first_name, coh.last_name,        
		(select SUM(CONVERT(NUMERIC(10,2), amount)) as total_pmyt
		from Movies_aqz.dbo.payment 
		where coh.customer_id = Movies_aqz.dbo.payment.customer_id) as total_sum,   --a subquery to select the sum of all payment made by customers
		(select count(inventory_id)
		FROM movies_aqz.dbo.rental
		where coh.customer_id = Movies_aqz.dbo.rental.customer_id) as total_rental    --a subquery to select the sum of all payment made by customers
from Movies_Aqz.dbo.customer as coh
order by total_sum desc 

-- Question 7: In this Question, i decided to be creative. I didnt find any column that could join the Advisor table and the Investor Table,
--so i decided to create a new column named "person_type" in both table and joined each of them with union
Alter table Movies_Aqz.dbo.advisor
add person_type varchar(100);
UPDATE Movies_Aqz.dbo.advisor
SET person_type = 'Advisor'

Alter table Movies_Aqz.dbo.investor
add person_type varchar(100);
UPDATE Movies_Aqz.dbo.investor
SET person_type = 'Investor'


select first_name+' '+last_name as name,
		case when investor_id = 1 then (select company_name
											from Movies_Aqz.dbo.investor
											where investor_id = 1)
		when investor_id = 2 then (select company_name
											from Movies_Aqz.dbo.investor
											where investor_id = 2)	
		when investor_id = 3 then (select company_name
											from Movies_Aqz.dbo.investor
											where investor_id = 3)
		else '' end as Company_n , person_type -- Person type is from the table i created with the alter statement
from Movies_Aqz.dbo.investor
union
select first_name+' '+last_name , 
		case when advisor_id = 1 then 'No_company'
		when advisor_id = 2 then 'No_company'	
		when advisor_id = 3 then 'No_company'
		when advisor_id = 4 then 'No_company'
		else '' end as Company_n
		,person_type
from Movies_Aqz.dbo.advisor  

--Question 8: we're interested in how well you have covered the most awarded actors, of all the actors with three types of award,
--for what % of them do we carry a film? how about actors with two types awards? same questions. finally, how about actors with one award?
SELECT                                 
    awards_count,
    COUNT(DISTINCT actor_id) AS total_actors,
    COUNT(DISTINCT CASE WHEN No_of_film > 0 THEN actor_id END) AS actors_with_films,
    COUNT(DISTINCT CASE WHEN No_of_film > 0 THEN actor_id END) * 100.0 / COUNT(DISTINCT actor_id) AS percentage_with_films
FROM (
    SELECT
        a.actor_id,
        (SELECT COUNT(DISTINCT film_id)
         FROM Movies_Aqz.dbo.film_actor AS b
         WHERE b.actor_id = a.actor_id) AS No_of_film,
        CASE
            WHEN awards LIKE '%,%,%' THEN 'Three Awards'
            WHEN awards LIKE '%,%' THEN 'Two Awards'
            ELSE 'One Award'
        END AS awards_count
    FROM
        Movies_Aqz.dbo.actor_award AS a
) AS subquery
GROUP BY
    awards_count;

