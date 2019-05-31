--1 Print how many hosts in each city have declared the area of their property in square meters. 
-- Sort the output based on the city name in ascending order.

SELECT C.city,
  cnt
FROM City C,
  (SELECT cid1 AS cid,
    COUNT(*)   AS cnt
  FROM
    (SELECT N.city_id AS cid1
    FROM Listing L, Neighbourhood N
    WHERE L.square_feet IS NOT NULL
    AND L.nid = N.nid
    GROUP BY N.city_id,
      L.host_id
    )
  GROUP BY cid1
  )
WHERE cid = C.city_id
ORDER BY C.CITY;

-- 2 The quality of a neighborhood is defined based on the number of listings and the review score of these listings,
-- one way for computing that is using the median of the review scores, as medians are more robust to outliers.
-- Find the top-5 neighborhoods using median review scores (review_scores_rating) of listings in Madrid.
-- Note: Implement the median operator on your own, and do not use the available built-in operator.
-- We have to create our own function median

CREATE OR REPLACE VIEW neigh_listing AS
SELECT L.id,
  L.nid AS nid,
  L.review_scores_rating,
  row_number() over ( partition BY L.nid order by L.review_scores_rating DESC) row_number
FROM Listing L
WHERE review_scores_rating IS NOT NULL;
--Drop VIEW neigh_listing;
SELECT N.neighbourhood,
  S.median
FROM
  Neighbourhood N,
  (SELECT co.nid,
    (nl1.review_scores_rating + nl2.review_scores_rating)/2 AS median
  FROM neigh_listing nl1,
    neigh_listing nl2,
    (SELECT L.nid           AS nid,
      FLOOR((COUNT(*)+1)/2) AS low,
      CEIL((COUNT( *)+1)/2) AS high
    FROM Listing L
    WHERE L.review_scores_rating IS NOT NULL
    GROUP BY L.nid
    ) co
  WHERE co.nid       = nl1.nid
  AND co.nid         = nl2.nid
  AND nl1.row_number = co.high
  AND nl2.row_number = co.low
  ) S
WHERE N.nid = S.nid
ORDER BY median DESC
FETCH FIRST 5 ROWS ONLY;

SELECT L.nid ,
  MEDIAN(L.review_scores_rating)
FROM Listing L
WHERE L.review_scores_rating IS NOT NULL
GROUP BY L.nid
ORDER BY MEDIAN(L.review_scores_rating) DESC
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
CREATE OR REPLACE VIEW host_list_c AS
SELECT L.host_id AS hid , COUNT(*) AS cnt FROM Listing L GROUP BY L.host_id ;
SELECT h.host_id,
  h.host_name
FROM host_list_c hlc,
  Host h
WHERE hlc.cnt =
  (SELECT MAX(hlc2.cnt) FROM host_list_c hlc2
  )
AND h.host_id = hlc.hid ;
--4
SELECT L.id,
  Round(lprice,2)
FROM Listing L,
  City C,
  Neighbourhood N,
  Property_type pt,
  Cancellation_policy CP,
  HAS_HOST_VERIFICATION HHV,
  HOST_VERIFICATION HV,
  (SELECT C.listing_id AS lid ,
    AVG(C.price)       AS lprice
  FROM Listing_calendar C
  WHERE C.cdate  >= '01.03.19'--'2019-03-01'
  AND C.cdate    <= '30-04-19'--'2019-09-01'
  AND C.available = 't'
  GROUP BY C.listing_id
  )
WHERE L.id = lid
  -- # Beds >= 2
AND L.beds >= 2
  -- REVIEW_SCORES_RATING >= 8
AND L.REVIEW_SCORES_RATING >= 8.0
  -- City : Berlin
AND C.city    = 'Berlin'
AND N.nid = L.nid
AND N.city_id = C.city_id
AND L.ptid = pt.ptid
AND pt.property_type = 'Apartment'
  -- Cancellation_policy : flexible
AND CP.CANCELLATION_POLICY = 'flexible'
AND CP.cpid                = L.cpid
  -- host_verification : government_id
AND HV.HOST_VERIFICATION = 'government_id'
AND HHV.hvid             = HV.hvid
AND HHV.listing_id       = L.id
  --search the 5 cheapest
ORDER BY lprice
FETCH FIRST 5 ROWS ONLY ;
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
WHERE row_number <= 5;
--6
SELECT H.host_name, S.Lid, H.host_id
FROM
  Host H,
  (SELECT L.host_id,
    lid,
    cnt,
    row_number() over ( partition BY L.host_id order by cnt DESC) row_number
  FROM Listing L,
    (SELECT listing_id AS lid, COUNT(*) AS cnt FROM Review GROUP BY listing_id
    )
  WHERE review_scores_rating IS NOT NULL
  AND L.id                    = lid
  ) S
WHERE row_number <=3
AND H.Host_id = S.Host_id;
--7
SELECT N.neighbourhood, A.amenity
FROM
  Neighbourhood N,
  Amenity A,
  (SELECT Selector.nid,
    Selector.aid,
    cnt ,
    row_number() over ( partition BY Selector.nid order by cnt DESC) row_number
  FROM
    (SELECT L.nid,
      HA.aid,
      COUNT(*) AS cnt
    FROM Has_amenity HA,
      Listing L,
      Room_type RT,
      City C,
      Neighbourhood N
    WHERE L.id       = HA.listing_id
    AND L.rtid       = RT.rtid
    AND RT.room_type = 'Private room'
    AND N.nid    = L.nid
    AND N.city_id = C.city_id
    AND C.city       = 'Berlin'
    GROUP BY L.nid,
      HA.aid
    ) Selector
  ) S
WHERE row_number <=3
AND S.aid = A.aid
ANd S.nid = N.nid;
--8
CREATE OR REPLACE VIEW amenity_list_c AS
SELECT listing_id, COUNT(*) AS cnt FROM Has_amenity GROUP BY listing_id ;


SELECT L1.REVIEW_SCORES_COMMUNICATION - L2.REVIEW_SCORES_COMMUNICATION
FROM Listing L1,
  Listing L2
WHERE L1.id IN
  (SELECT alc1.listing_id
  FROM amenity_list_c alc1
  WHERE alc1.cnt =
    (SELECT MAX (alc2.cnt) FROM amenity_list_c alc2
    )
  FETCH FIRST 1 ROWS ONLY
  )
AND L2.id IN
  (SELECT alc1.listing_id
  FROM amenity_list_c alc1
  WHERE alc1.cnt =
    (SELECT MIN (alc2.cnt) FROM amenity_list_c alc2
    )
  FETCH FIRST 1 ROWS ONLY
  ) ;
--9
SELECT C.city
FROM city C,
  (SELECT city_id,
    COUNT(*) AS cnt
  FROM Listing L ,
  Neighbourhood N,
    review R
  WHERE L.rtid IN
    (SELECT rtid
    FROM Listing L,
    
      (SELECT HA.listing_id,
        COUNT(*) AS cnt
      FROM Has_amenity HA
      GROUP BY ha.listing_id
      )
    WHERE L.id = listing_id
    GROUP BY rtid
    HAVING AVG(cnt) >= 3
    )
  AND R.listing_id = L.id
  AND N.nid = L.nid
  GROUP BY N.city_id
  ) T
WHERE C.city_id = T.city_id
ORDER BY cnt DESC
FETCH FIRST 1 ROWS ONLY;
--10 La querry est quasi faite, il faut juste que je mette à jour calendar. A vérifier si je fais bien les choses
--DROP VIEW madrid_listing;
CREATE OR REPLACE VIEW madrid_listing AS
SELECT L.id                AS listing_id,
  L.nid                    AS nid,
  L.host_id
FROM Listing L,
Neighbourhood N,
  City C
WHERE L.nid = N.nid
AND N.city_id = C.city_id
AND C.city      = 'Madrid' ;


SELECT N.neighbourhood
FROM
  Neighbourhood N,
  (SELECT L.nid                  AS nid ,
    COUNT(DISTINCT L.listing_id) AS cnt
  FROM Listing_calendar C,
    madrid_listing L
  WHERE extract(YEAR FROM C.cdate) = 2019
  AND L.listing_id                 = C.listing_id
  AND C.available                  = 'f'
  AND L.nid                       IN
    (SELECT L.nid
    FROM Host H,
      madrid_listing L
    WHERE L.host_id = H.host_id
    GROUP BY L.nid
    HAVING MAX(H.since) <= '01.06.17'
    )
  GROUP BY L.nid
  HAVING COUNT(*) > 0
  ) part,
  (SELECT L.nid                  AS nid ,
    COUNT(DISTINCT L.listing_id) AS cnt
  FROM Listing_calendar C ,
    madrid_listing L
  WHERE L.listing_id= C.listing_id
  GROUP BY L.nid
  HAVING COUNT(*) > 0
  ) total
WHERE part.nid           = total.nid
AND part.cnt / total.cnt > 0.5 
AND part.nid = N.nid;
--11
SELECT C.COUNTRY,
  100 * Round(part.cnt / total.cnt,3)
FROM
  Country C,
  (SELECT city.country_id AS country_id ,
    COUNT(DISTINCT L.id)  AS cnt
  FROM Listing_calendar C,
    Listing L,
    Neighbourhood N,
    City city
  WHERE extract(YEAR FROM C.cdate) = 2018
  AND L.id                         = C.listing_id
  AND L.nid = N.nid
  AND N.city_id                    = city.city_id
  AND C.available                  = 't'
  GROUP BY city.country_id
  HAVING COUNT(*) > 0
  ) part,
  (SELECT city.country_id AS country_id ,
    COUNT(DISTINCT L.id)  AS cnt
  FROM Listing_calendar C ,
    Listing L,
    Neighbourhood N,
    City city
  WHERE L.id    = C.listing_id
  AND L.nid = N.nid
  AND N.city_id = city.city_id
  GROUP BY city.country_id
  HAVING COUNT(*) > 0
  ) total
WHERE part.country_id    = total.country_id
AND total.country_id = C.country_id
AND part.cnt / total.cnt > 0.2 ;
--12
--DROP VIEW barcelona_listing;
CREATE OR REPLACE
VIEW barcelona_listing AS
SELECT L.id AS listing_id,
  L.nid     AS nid,
  L.cpid    AS cpid
FROM Listing L,
  City C,
  Neighbourhood N
WHERE N.city_id = C.city_id
AND N.nid = L.nid
AND C.city      = 'Barcelona' ;


SELECT part.nid,
  100 * ROUND(part.cnt / total.cnt, 3)
FROM
  (SELECT L.nid                  AS nid ,
    COUNT(DISTINCT L.listing_id) AS cnt
  FROM Barcelona_listing L,
    CANCELLATION_POLICY CP
  WHERE L.cpid               = CP.CPID
  AND CP.CANCELLATION_POLICY = 'strict_14_with_grace_period'
  GROUP BY L.nid
  HAVING COUNT(*) > 0
  ) part,
  (SELECT L.nid                  AS nid ,
    COUNT(DISTINCT L.listing_id) AS cnt
  FROM barcelona_listing L
  GROUP BY L.nid
  HAVING COUNT(*) > 0
  ) total
WHERE part.nid           = total.nid
AND part.cnt / total.cnt > 0.05 ;
