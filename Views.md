## Question 1
My partner and i want to come by each of the stores in person to meet the managers. Please send over the managers' name of each store, with the full address of each property
(street address, district,city and country please)

### `code`
```sql
select a.address as Address,a.district as District, b.city as City, c.country as Country,    
	s.first_name + ' ' + s.last_name AS Managers_name 
from Movies_Aqz.dbo.address as a
join Movies_Aqz.dbo.city as b
		on a.city_id = b.city_id
join Movies_Aqz.dbo.country as c
		on c.country_id = b.country_id
CROSS JOIN
    Movies_Aqz.dbo.staff AS s;
```
### Output
*Kindly note that this is not the entire output. The entire output is long and would take up space.*
|Address|District|City|Country|Managers_Name|
| ------| -------| ---| ------| ----------- |
47 MySakila Drive|	Alberta|	Lethbridge	|Canada|	Mike Hillyer
1795 Santiago de Compostela Way|	Texas|	Laredo|	United States|	Mike Hillyer
1308 Arecibo Way|	Georgia|	Augusta-Richmond County|	United States|	Mike Hillyer
1599 Plock Drive	|Tete|	Tete|	Mozambique|	Mike Hillyer
669 Firozabad Loop|	Abu Dhabi	|al-Ayn|	United Arab Emirates|	Mike Hillyer
588 Vila Velha Manor	|Kyongsangbuk|	Kimchon|	South Korea|	Mike Hillyer
1913 Kamakura Place|	Lipetsk	|Jelets	|Russian Federation	|Mike Hillyer
733 Mandaluyong Place|	Asir|	Abha	|Saudi Arabia	|Mike Hillyer
659 Vaduz Drive|	Ha Darom	|Ashdod	|Israel|	Mike Hillyer

## Question 2
I would like to get a better understanding of all of the inventory that would come along with the business. Please pull together a list of each inventory item
you have stocked, including the store_id number, inventory_id,name of the film, film rating, its rental rate and the replacement cost

## `code`
*Kindly note that this is not the entire output. The entire output is over 4581 and would take up space.*
```sql
select  inv.inventory_id,fil.title, inv.store_id, fil.rating, fil.rental_rate,fil.replacement_cost        
 from Movies_Aqz.dbo.film as fil
 inner join Movies_Aqz.dbo.inventory as inv
		on fil.film_id = inv.film_id 
```
### Output
*Kindly note that this is not the entire output. The entire output is long and would take up space.*
|Inventory_id|Title|Store_id|Rating|Rental rate|Replacement cost|
| ------| -------| ---| ------| ----------- |-------|
ACADEMY DINOSAUR|	1|	1|	PG|	0.990000009536743	|20.9899997711182
ACADEMY DINOSAUR|	2|	1	|PG|	0.990000009536743	|20.9899997711182
ACADEMY DINOSAUR|	3|	1|	PG|	0.990000009536743	|20.9899997711182
ACADEMY DINOSAUR|	4|	1	|PG|	0.990000009536743	|20.9899997711182
ACADEMY DINOSAUR|	5	|2|	PG	|0.990000009536743	|20.9899997711182
ACADEMY DINOSAUR|	6	|2|	PG	|0.990000009536743	|20.9899997711182
ACADEMY DINOSAUR|	7	|2|	PG	|0.990000009536743	|20.9899997711182
ACADEMY DINOSAUR|	8|	2|	PG	|0.990000009536743|	20.9899997711182
ACE GOLDFINGER|	10|	2|	G	|4.98999977111816|	12.9899997711182
ACE GOLDFINGER|	11|	2|	G|	4.98999977111816	|12.9899997711182
ACE GOLDFINGER|	9|	2|	G	|4.98999977111816	|12.9899997711182
ADAPTATION HOLES|	12	|2|	NC-17|	2.99000000953674	|18.9899997711182

## Question 3
From the same list of film you just pulled, please roll up that data up and provide a summary level overview of your inventory. we would like to know 
howmany inventory items you have with each rating at each store
```sql
 select a.store_id , b.rating , count(distinct a.inventory_id) as total_merch        
 from Movies_Aqz.dbo.inventory as a
 join Movies_Aqz.dbo.film as b
		on a.film_id = b.film_id
group by a.store_id,b.rating  
```
### Output
*Kindly note that this is not the entire output. The entire output is long and would take up space.*
|Inventory_id|Title|Store_id|Rating|Rental rate|Replacement cost|
| ------| -------| ---| ------| ----------- |-------|

## Question 4
Similarly, we want to understand how diversified the inventory is in terms of replacement cost. we want to see how big of a hit it would be if 
a certain category of film became unpopular at a certain store. we would like to see the number of films, as well as the average replacement cost and the total replacement cost, sliced by store and film category
```sql
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
```
### Output
*Kindly note that this is not the entire output. The entire output is long and would take up space.*
|Inventory_id|Title|Store_id|Rating|Rental rate|Replacement cost|

## Question 5
We want to make sure you folks have a good handle on who your customers are. Please provide a list of all customer names,
which store they go to, whether or not they are currently active and their full addresses -- street address, city and country
```sql
select cut.first_name,cut.last_name,adre.address,cut.active,adre.address,city.city , cont.country 
from Movies_aqz.dbo.customer as cut
inner join Movies_aqz.dbo.address as adre        
		on cut.address_id = adre.address_id				-- Added a join 
inner join Movies_aqz.dbo.city as city
		on adre.city_id = city.city_id
inner join Movies_aqz.dbo.country as cont
		on cont.country_id = city.country_id 
```
### Output
*Kindly note that this is not the entire output. The entire output is long and would take up space.*
|first_name|last_name|address|active|Rental rate|Replacement cost|
| ------| -------| ---| ------| ----------- |-------|
first_name	last_name			address	city	country
JENNIFER	DAVIS	1795 Santiago de Compostela Way	1	1795 Santiago de Compostela Way	Laredo	United States
DIANA	ALEXANDER	1308 Arecibo Way	1	1308 Arecibo Way	Augusta-Richmond County	United States
ANNIE	RUSSELL	1599 Plock Drive	1	1599 Plock Drive	Tete	Mozambique
LILLIAN	GRIFFIN	669 Firozabad Loop	1	669 Firozabad Loop	al-Ayn	United Arab Emirates
EMILY	DIAZ	588 Vila Velha Manor	1	588 Vila Velha Manor	Kimchon	South Korea
ROBIN	HAYES	1913 Kamakura Place	1	1913 Kamakura Place	Jelets	Russian Federation
PEGGY	MYERS	733 Mandaluyong Place	1	733 Mandaluyong Place	Abha	Saudi Arabia
CRYSTAL	FORD	659 Vaduz Drive	1	659 Vaduz Drive	Ashdod	Israel
GLADYS	HAMILTON	1177 Jelets Way	1	1177 Jelets Way	Ilorin	Nigeria


## Question 6
We would like to understand how much your customers are spending with you and also know who your most valuable customers are. Please pull together a list of customers name, their total lifetime rentals, and the sum of payments you have collected from them. It would
be great to see this ordered on total lifetime value, with the most valuable customers at the top of the list
```sql
select coh.first_name, coh.last_name,        
		(select SUM(CONVERT(NUMERIC(10,2), amount)) as total_pmyt
		from Movies_aqz.dbo.payment 
		where coh.customer_id = Movies_aqz.dbo.payment.customer_id) as total_sum,   --a subquery to select the sum of all payment made by customers
		(select count(inventory_id)
		FROM movies_aqz.dbo.rental
		where coh.customer_id = Movies_aqz.dbo.rental.customer_id) as total_rental    --a subquery to select the sum of all payment made by customers
from Movies_Aqz.dbo.customer as coh
order by total_sum desc 
```
### Output
*Kindly note that this is not the entire output. The entire output is long and would take up space.*
|first_name|Last_name|total sum|total_rental|
| ------| -------| ---| ------|
KARL|	SEAL|	221.55|	45|
ELEANOR|	HUNT|	216.54|	46|
CLARA|	SHAW|	195.58|	42|
RHONDA|	KENNEDY|	194.61|	39|
MARION|	SNYDER|	194.61|	39|
TOMMY|	COLLAZO|	186.62|	38|
WESLEY|	BULL|	177.60|	40|
TIM|	CARY|	175.61|	39|
MARCIA|	DEAN|	175.58|	42|

## Question 7
My partner and i would like to get to know your board of advisors and any current investors. Could you plase provide a list of advisor and investors in one table?
Could you please note whether they are an investor or an advisor, and for the investors, it would be good to include which company they work with.
```sql
Alter table Movies_Aqz.dbo.advisor
add person_type varchar(100);
UPDATE Movies_Aqz.dbo.advisor
SET person_type = 'Advisor'

Alter table Movies_Aqz.dbo.investor
add person_type varchar(100);
UPDATE Movies_Aqz.dbo.investor
SET person_type = 'Investor'


select first_name+' '+last_name as name,
case when investor_id = 1 then 
(select company_name
from Movies_Aqz.dbo.investor
where investor_id = 1)

when investor_id = 2 then 
(select company_name
from Movies_Aqz.dbo.investor
where investor_id = 2)

when investor_id = 3 then
(select company_name
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
		else '' end as Company_name
		,person_type
from Movies_Aqz.dbo.advisor
```
### Output
|Name|Company_name|person_type|
 | ------| -------| ---| ------|
Anthony Stark|	Iron Investors|	Investor
Barry Beenthere|	No_company|	Advisor
Cindy Smartypants|	No_company|	Advisor
Mary Moneybags|	No_company|	Advisor
Montgomery Burns|	Springfield Syndicators|	Investor
Walter White|	No_company|	Advisor
William Wonka|	Chocolate Ventures|	Investor



# Question 8
We're interested in how well you have covered the most awarded actors. Of all the actors with three types of awards, for what % of them do we carry a film? And how about actors with two types of awards? Same Questions. Finally, How about actors with just one award? 
```sql
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
 ```
### Output 
|Awards_count|Total_actors|actors_with_film|percentage_with_films|
 | ------| -------| ---| ------| 
One Award|	71|70|	98.591549295774
Three Awards|	5|	4|	80.000000000000
Two Awards |62	|61|	98.387096774193


















