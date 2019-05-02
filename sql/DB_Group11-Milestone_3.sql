--6
SELECT cnt, row_number() over ( partition BY L.host_id order by cnt DESC) row_number
FROM Listing L,
  (SELECT listing_id AS lid, COUNT(*) AS cnt FROM Review GROUP BY listing_id
  )
WHERE review_scores_rating IS NOT NULL AND L.id = lid;
  
Select listing_id as lid, Count(*) as cnt 
From Review
Group by listing_id;


--1
SELECT C.city, cnt
FROM City C,
(Select cid1 as cid, Count(*) as cnt 
FROM (SELECT L.city_id AS cid1
  FROM Listing L
  WHERE L.square_feet IS NOT NULL
  GROUP BY L.city_id, L.host_id)
GROUP BY cid1)
WHERE cid = C.city_id
ORDER BY C.CITY;

-- We have to create our own function median
Select L.nid , MEDIAN(L.review_scores_rating)
From Listing L
Where L.review_scores_rating IS NOT NULL
Group by L.nid 
Order by MEDIAN(L.review_scores_rating) DESC
FETCH FIRST 5 ROWS ONLY;


--2 without median function
SELECT neigh,
  percentile_disc
FROM
  (SELECT nid AS neigh,
    PERCENTILE_DISC(0.5) WITHIN GROUP (
  ORDER BY review_scores_rating DESC) AS percentile_disc
  FROM Listing
  GROUP BY nid
  )
WHERE PERCENTILE_DISC IS NOT NULL
ORDER BY percentile_disc DESC
FETCH FIRST 5 ROWS ONLY;


--3

CREATE VIEW host_list_c AS
  SELECT L.host_id AS hid , COUNT(*) AS cnt FROM Listing L GROUP BY L.host_id
  ; 

Select h.host_id, h.host_name
from host_list_c hlc, Host h
WHERE hlc.cnt =
(SELECT MAX(hlc2.cnt)
FROM host_list_c hlc2)
AND h.host_id = hlc.hid
;


--4
Select L.id, lprice
From Listing L,
City C,
Cancellation_policy CP,
HAS_HOST_VERIFICATION HHV,
HOST_VERIFICATION HV,

(Select C.listing_id as lid , avg(C.price) as lprice
From Listing_calendar C
WHERE C.cdate >= '01.03.19'--'2019-03-01'
AND C.cdate   <= '30-04-19'--'2019-09-01'
AND C.available = 't'
Group BY C.listing_id)
Where L.id = lid
-- # Beds >= 2
and L.beds >= 2
-- REVIEW_SCORES_RATING >= 8
And L.REVIEW_SCORES_RATING >= 8.0
-- City : Berlin
And C.city = 'Berlin'
And C.city_id = L.city_id
-- Cancellation_policy : flexible
And CP.CANCELLATION_POLICY = 'flexible'
And CP.cpid = L.cpid
-- host_verification : government_id
And HV.HOST_VERIFICATION = 'government_id'
and HHV.hvid = HV.hvid
and HHV.listing_id = L.id
--search the 5 cheapest
Order By lprice
FETCH FIRST 5 ROWS ONLY
;

--5

SELECT *
FROM
  (SELECT L.id,
    L.accommodates,
    L.review_scores_rating,
    row_number() over ( partition BY L.accommodates order by L.review_scores_rating DESC) row_number
  FROM Listing L
  WHERE review_scores_rating IS NOT NULL
  AND L.id                   IN
    (SELECT HA.LISTING_ID
    FROM HAS_AMENITY HA
    WHERE HA.aid IN
      (SELECT A.aid
      FROM AMENITY A,
        HAS_AMENITY HA
      WHERE A.AMENITY = 'Wifi'
      OR A.AMENITY    = 'Internet'
      OR A.AMENITY    = 'TV'
      OR A.AMENITY    = 'Free street parking'
      )
    GROUP BY HA.listing_id
    HAVING COUNT(*)>= 2
    )
  )
WHERE row_number <= 3;
