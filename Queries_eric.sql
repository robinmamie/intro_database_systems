--Sql requests

--1.
SELECT AVG(L.price) FROM Listing L WHERE L.bedrooms= 8;

--2.
SELECT AVG(L.review_scores_cleanliness)
FROM Listing L,
  Has_amenity H,
  Amenity A
WHERE A.amenity  = 'TV'
AND H.aid          = A.aid
AND H.listing_id = L.id;

--3.
SELECT DISTINCT H.user_name
FROM Listing L,
  Host H
WHERE H.user_id = L.user_id
AND L.id       IN
  ( SELECT DISTINCT listing_id
  FROM Listing_calendar
  WHERE cdate >= '01.03.19'--'2019-03-01'
  AND cdate   <= '01-09-19'--'2019-09-01'
  );

--4.
SELECT COUNT(L.id)
FROM Listing L
WHERE L.user_id IN
  ( SELECT DISTINCT H1.user_id
  FROM Host H1,
    Host H2
  WHERE H1.user_id != H2.user_id
  AND H1.user_name = H2.user_name
  );

--5.
SELECT C.cdate
FROM Listing L,
  Host H,
  Listing_calendar C
WHERE L.user_id  = H.user_id
AND H.user_name  = 'Viajes Eco'
AND C.listing_id = L.id
AND C.available  = 't';

--6.
SELECT user_name
FROM Host
WHERE user_id IN
  ( SELECT user_id FROM Listing GROUP BY user_id HAVING COUNT(*)=1
  );


--7.
SELECT
  (SELECT AVG(L.price)
  FROM Listing L
  WHERE L.id IN
    (SELECT H.listing_id
    FROM Has_amenity H,
      Amenity A 
      WHERE A.amenity = 'Wifi'
    AND H.aid               = A.aid
    )
  ) -
  (SELECT AVG(L.price)
  FROM Listing L
  WHERE L.id NOT IN
    (SELECT H.listing_id
    FROM Has_amenity H,
      Amenity A
      WHERE A.amenity = 'Wifi'
    AND H.aid               = A.aid
    )
  ) FROM DUAL;



--8.
SELECT
  (SELECT AVG(L.price)
  FROM Listing L,
    City C
  WHERE L.bedrooms= 8
  AND L.cid       = C.cid
  AND C.city      = 'Berlin'
  ) -
  (SELECT AVG(L.price)
  FROM Listing L,
    City C
  WHERE L.bedrooms= 8
  AND L.cid       = C.cid
  AND C.city      = 'Madrid'
  )
FROM DUAL;

--9.
SELECT  L.user_id
FROM Listing L,
  City C
WHERE L.cid   = C.cid
AND C.country = 'Spain'
GROUP BY L.user_id
ORDER BY COUNT(*) DESC
FETCH FIRST 10 ROWS ONLY;

--10.
SELECT  L.id, L.name
FROM Listing L,
  City C
WHERE L.cid   = C.cid
AND C.city = 'Barcelona'
ORDER BY L.review_scores_rating DESC
FETCH FIRST 10 ROWS ONLY;