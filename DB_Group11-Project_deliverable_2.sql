-- 1. What	is	the	average	price	for	a	listing	with 8	bedrooms?
--SELECT AVG (l.price)
--FROM Listing l
--WHERE l.bedrooms = 8;

-- 2. What is the average cleaning	review score for listings with TV?
-- ??????????'
-- 3. Print	all	the	hosts	who	have an	available	property between date 03.2019	and	09.2019.
--SELECT DISTINCT h.user_name
--FROM Host h, Listing l, Listing_calendar c
--WHERE c.cdate >= TO_DATE('2013-03-01','YYYY-MM-DD')
--AND c.cdate <= TO_DATE('2013-09-30','YYYY-MM-DD')
--AND c.listing_id = l.id 
--AND l.user_id = h.user_id;

-- 4. Print how many listing items exist that are posted by two different hosts but the hosts have the same name.
--SELECT COUNT (l1.id)
--FROM Listing l1, Host h1, Listing l2, Host h2
--WHERE l1.user_id = h1.user_id
--AND   l2.user_id = h2.user_id
--AND   h1.user_name = h2.user_name
--AND   h1.user_id != h2.user_id
--AND   l1.id != l2.id;

-- 5. Print all the dates that 'Viajes Eco' has available accommodations for rent.
--SELECT c.cdate
--FROM Listing_calendar c, Listing l, Host h
--WHERE c.listing_id = l.id
--AND l.user_id = h.user_id
--AND h.user_name = 'Viajes Eco';

--6. Find	all the	hosts (host_ids, host_names) that have only one	listing.
--SELECT DISTINCT h.user_id, h.user_name
--FROM Host h
--WHERE (SELECT COUNT (l.id)
--FROM Listing l
--GROUP BY l.user_id
--HAVING l.user_id = h.user_id) = 1;

--7. What	is the difference in the average price of listings with and without Wifi.
--???

-- 8. How much more (or less) costly to rent a room with 8 beds in Berlin compared to Madrid on average?

SELECT avg1 - avg2 FROM
  (SELECT AVG(l1.price) AS avg1
  FROM Listing l1, City c1
  WHERE l1.beds = 8
  AND l1.cid = c1.cid
  AND c1.city = 'Madrid')
, (SELECT AVG(l2.price) AS avg2
  FROM  Listing l2, City c2
  WHERE l2.beds = 8
  AND l2.cid = c2.cid
  AND c2.city = 'Berlin');
