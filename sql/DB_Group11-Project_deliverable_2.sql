-- 1. What	is	the	average	price	for	a	listing	with 8	bedrooms?
SELECT ROUND(AVG (l.price), 2)
FROM Listing l
WHERE l.bedrooms = 8;

-- 2. What is the average cleaning	review score for listings with TV?
SELECT ROUND(AVG(L.review_scores_cleanliness), 2)
FROM Listing L,
  Has_amenity H,
  Amenity A
WHERE A.amenity  = 'TV'
AND H.aid          = A.aid
AND H.listing_id = L.id;

-- 3. Print	all	the	hosts	who	have an	available	property between date 03.2019	and	09.2019.

SELECT DISTINCT H.host_name
FROM Listing L, Host H
WHERE H.host_id = L.host_id
AND L.id       IN
  ( SELECT DISTINCT listing_id
  FROM Listing_calendar
  WHERE cdate >= '01.03.19'--'2019-03-01'
  AND cdate   <= '01-09-19'--'2019-09-01'
  AND available = 't'
  );

-- 4. Print how many listing items exist that are posted by two different hosts but the hosts have the same name.
SELECT COUNT (DISTINCT l1.id)
FROM Listing l1, Host h1, Listing l2, Host h2
WHERE l1.host_id = h1.host_id
AND   l2.host_id = h2.host_id
AND   h1.host_name = h2.host_name
AND   h1.host_id != h2.host_id
AND   l1.id != l2.id;

--Eric

SELECT COUNT(L.id)
FROM Listing L
WHERE L.host_id IN
  ( SELECT DISTINCT H1.host_id
 FROM Host H1,
    Host H2
  WHERE H1.host_id != H2.host_id
  AND H1.host_name = H2.host_name
  );

-- 5. Print all the dates that 'Viajes Eco' has available accommodations for rent.
SELECT c.cdate
FROM Listing_calendar c, Listing l, Host h
WHERE c.listing_id = l.id
AND l.host_id = h.host_id
AND h.host_name = 'Viajes Eco'
AND c.available = 't';

--Eric

SELECT C.cdate
FROM Listing L,
  Host H,
  Listing_calendar C
WHERE L.host_id  = H.host_id
AND H.host_name  = 'Viajes Eco'
AND C.listing_id = L.id
AND C.available  = 't';


--6. Find	all the	hosts (host_ids, host_names) that have only one	listing.
SELECT DISTINCT h.host_id, h.host_name
FROM Host h
WHERE (SELECT COUNT (l.id)
FROM Listing l
GROUP BY l.host_id
HAVING l.host_id = h.host_id) = 1;

--Eric

SELECT host_id, host_name
FROM Host
WHERE host_id IN
  ( SELECT host_id FROM Listing GROUP BY host_id HAVING COUNT(*)=1
  );

--7. What	is the difference in the average price of listings with and without Wifi.

SELECT ROUND (ABS (
  (SELECT AVG(L.price)
  FROM Listing L
  WHERE L.id IN
    (SELECT H.listing_id
    FROM Has_amenity H,
      Amenity A
    WHERE A.amenity = 'Wifi'
    AND H.aid       = A.aid
    )
  ) -
  (SELECT AVG(L.price)
  FROM Listing L
  WHERE L.id NOT IN
    (SELECT H.listing_id
    FROM Has_amenity H,
      Amenity A
    WHERE A.amenity = 'Wifi'
    AND H.aid       = A.aid
    )
  )) , 2 )
FROM DUAL;

-- 8. How much more (or less) costly to rent a room with 8 beds in Berlin compared to Madrid on average?
SELECT ROUND(ABS(avg1 - avg2), 2) FROM
  (SELECT AVG(l1.price) AS avg1
  FROM Listing l1, Neighbourhood N,  City c1
  WHERE l1.beds = 8
  AND l1.nid = N.nid
  AND N.city_id = c1.city_id
  AND c1.city = 'Madrid')
, (SELECT AVG(l2.price) AS avg2
  FROM  Listing l2, City c2, Neighbourhood N
  WHERE l2.beds = 8
  AND l2.nid = N.nid
  AND N.city_id = c2.city_id
  AND c2.city = 'Berlin');

--Eric

SELECT ROUND ( ABS (
  (SELECT AVG(L.price)
  FROM Listing L,
    City C,
    Neighbourhood N
  WHERE L.beds  = 8
  AND L.nid     = N.nid
  AND N.city_id = C.city_id
  AND C.city    = 'Berlin'
  ) -
  (SELECT AVG(L.price)
  FROM Listing L,
    City C,
    Neighbourhood N
  WHERE L.beds  = 8
  AND L.nid     = N.nid
  AND N.city_id = C.city_id
  AND C.city    = 'Madrid'
  ) ), 2)
FROM DUAL;

--9. Find	the top-10 (in terms of	the number of listings) hosts (host_ids, host_names) in Spain
SELECT H.host_id, H.host_name
FROM Host H
WHERE H.host_id IN (SELECT  L.host_id
FROM Listing L, City C1, Country C2, Neighbourhood N
WHERE L.nid = N.nid
  AND N.city_id = C1.city_id
AND C1.country_id = C2.country_id
AND C2.country = 'Spain'
GROUP BY L.host_id
ORDER BY COUNT(*) DESC
FETCH FIRST 10 ROWS ONLY);

--10. Find the top-10 rated (review_score_rating) apartments (id,name) in Barcelona.

SELECT  L.id, L.name
FROM Listing L,
  City C, 
    Neighbourhood N,
    Property_type pt
WHERE L.nid  = N.nid
  AND N.city_id = C.city_id
AND C.city = 'Barcelona'
AND L.ptid = pt.ptid
AND pt.property_type = 'Apartment'
ORDER BY L.review_scores_rating DESC
FETCH FIRST 10 ROWS ONLY;
