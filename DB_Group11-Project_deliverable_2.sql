-- 1. What	is	the	average	price	for	a	listing	with 8	bedrooms?
--SELECT AVG (l.price)
--FROM Listing l
--WHERE l.bedrooms = 8;

-- 2. What is the average cleaning	review score for listings with TV?
--SELECT AVG(L.review_scores_cleanliness)
--FROM Listing L,
--  Has_amenity H,
--  Amenity A
--WHERE A.amenity  = 'TV'
--AND H.aid          = A.aid
--AND H.listing_id = L.id;

-- 3. Print	all	the	hosts	who	have an	available	property between date 03.2019	and	09.2019.

--SELECT DISTINCT H.user_name
--FROM Listing L, Host H
--WHERE H.user_id = L.user_id
--AND L.id       IN
--  ( SELECT DISTINCT listing_id
--  FROM Listing_calendar
--  WHERE cdate >= '01.03.19'--'2019-03-01'
--  AND cdate   <= '01-09-19'--'2019-09-01'
--  );

-- 4. Print how many listing items exist that are posted by two different hosts but the hosts have the same name.
--SELECT COUNT (DISTINCT l1.id)
--FROM Listing l1, Host h1, Listing l2, Host h2
--WHERE l1.user_id = h1.user_id
--AND   l2.user_id = h2.user_id
--AND   h1.user_name = h2.user_name
--AND   h1.user_id != h2.user_id
--AND   l1.id != l2.id;

--Eric

--SELECT COUNT(L.id)
--FROM Listing L
--WHERE L.user_id IN
--  ( SELECT DISTINCT H1.user_id
-- FROM Host H1,
--    Host H2
--  WHERE H1.user_id != H2.user_id
--  AND H1.user_name = H2.user_name
--  );

-- 5. Print all the dates that 'Viajes Eco' has available accommodations for rent.
--SELECT c.cdate
--FROM Listing_calendar c, Listing l, Host h
--WHERE c.listing_id = l.id
--AND l.user_id = h.user_id
--AND h.user_name = 'Viajes Eco'
--AND c.available = 't';

--Eric

--SELECT C.cdate
--FROM Listing L,
--  Host H,
--  Listing_calendar C
--WHERE L.user_id  = H.user_id
--AND H.user_name  = 'Viajes Eco'
--AND C.listing_id = L.id
--AND C.available  = 't';


--6. Find	all the	hosts (host_ids, host_names) that have only one	listing.
--SELECT DISTINCT h.user_id, h.user_name
--FROM Host h
--WHERE (SELECT COUNT (l.id)
--FROM Listing l
--GROUP BY l.user_id
--HAVING l.user_id = h.user_id) = 1;

--Eric

--SELECT user_id, user_name
--FROM Host
--WHERE user_id IN
--  ( SELECT user_id FROM Listing GROUP BY user_id HAVING COUNT(*)=1
--  );

--7. What	is the difference in the average price of listings with and without Wifi.

--SELECT
--  (SELECT AVG(L.price)
--  FROM Listing L
--  WHERE L.id IN
--    (SELECT H.listing_id
--    FROM Has_amenity H,
--      Amenity A
--      WHERE A.amenity = 'Wifi'
--    AND H.aid               = A.aid
--    )
--  ) -
--  (SELECT AVG(L.price)
--  FROM Listing L
--  WHERE L.id NOT IN
--    (SELECT H.listing_id
--    FROM Has_amenity H,
--      Amenity A
--      WHERE A.amenity = 'Wifi'
--    AND H.aid               = A.aid
--    )
--  ) FROM DUAL;

-- 8. How much more (or less) costly to rent a room with 8 beds in Berlin compared to Madrid on average?
--SELECT avg1 - avg2 FROM
--  (SELECT AVG(l1.price) AS avg1
--  FROM Listing l1, City c1
--  WHERE l1.beds = 8
--  AND l1.cid = c1.cid
--  AND c1.city = 'Madrid')
--, (SELECT AVG(l2.price) AS avg2
--  FROM  Listing l2, City c2
--  WHERE l2.beds = 8
--  AND l2.cid = c2.cid
--  AND c2.city = 'Berlin');

--Eric

--SELECT
--  (SELECT AVG(L.price)
--  FROM Listing L,
--    City C
--  WHERE L.beds= 8
--  AND L.cid       = C.cid
--  AND C.city      = 'Berlin'
--  ) -
--  (SELECT AVG(L.price)
--  FROM Listing L,
--    City C
--  WHERE L.beds= 8
--  AND L.cid       = C.cid
--  AND C.city      = 'Madrid'
--  )
--FROM DUAL;

--9. Find	the top-10 (in terms of	the number of listings) hosts (host_ids, host_names) in Spain
SELECT H.user_id, H.user_name
FROM Host H
WHERE H.user_id IN (SELECT  L.user_id
FROM Listing L, City C
WHERE L.cid   = C.cid
AND C.country = 'Spain'
GROUP BY L.user_id
ORDER BY COUNT(*) DESC
FETCH FIRST 10 ROWS ONLY);

--10. Find the top-10 rated (review_score_rating) apartments (id,name) in Barcelona.

SELECT  L.id, L.name
FROM Listing L,
  City C
WHERE L.cid   = C.cid
AND C.city = 'Barcelona'
ORDER BY L.review_scores_rating DESC
FETCH FIRST 10 ROWS ONLY;
