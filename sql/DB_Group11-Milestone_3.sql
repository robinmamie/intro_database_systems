--1
CREATE INDEX firstTry
  ON Listing (city_id, host_id);

CREATE INDEX host_index
  ON Listing (host_id);
  
CREATE BITMAP INDEX cityNameIndexTest
ON City (city);

DROP INDEX firstTry;

DROP INDEX cityNameIndexTest;

SELECT C.city,
  cnt
FROM City C,
  (SELECT cid1 AS cid,
    COUNT(*)   AS cnt
  FROM
    (SELECT L.city_id AS cid1
    FROM Listing L
    WHERE L.square_feet IS NOT NULL
    GROUP BY L.city_id,
      L.host_id
    )
  GROUP BY cid1
  )
WHERE cid = C.city_id
ORDER BY C.CITY;
-- We have to create our own function median
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
CREATE VIEW host_list_c AS
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
  lprice
FROM Listing L,
  City C,
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
AND C.city_id = L.city_id
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
WHERE row_number <= 3;
--6
SELECT *
FROM
  (SELECT L.host_id,
    lid,
    cnt,
    row_number() over ( partition BY L.host_id order by cnt DESC) row_number
  FROM Listing L,
    (SELECT listing_id AS lid, COUNT(*) AS cnt FROM Review GROUP BY listing_id
    )
  WHERE review_scores_rating IS NOT NULL
  AND L.id                    = lid
  )
WHERE row_number <=3;
--7
SELECT *
FROM
  (SELECT Cerise.nid,
    Cerise.aid,
    cnt ,
    row_number() over ( partition BY Cerise.nid order by cnt DESC) row_number
  FROM
    (SELECT L.nid,
      HA.aid,
      COUNT(*) AS cnt
    FROM Has_amenity HA,
      Listing L,
      Room_type RT,
      City C
    WHERE L.id       = HA.listing_id
    AND L.rtid       = RT.rtid
    AND RT.room_type = 'Private room'
    AND C.city_id    = L.city_id
    AND C.city       = 'Berlin'
    GROUP BY L.nid,
      HA.aid
    ) Cerise
  )
WHERE row_number <=3;
--8
CREATE VIEW amenity_list_c AS
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
  GROUP BY L.city_id
  ) T
WHERE C.city_id = T.city_id
ORDER BY cnt DESC
FETCH FIRST 1 ROWS ONLY;
--10 La querry est quasi faite, il faut juste que je mette à jour calendar. A vérifier si je fais bien les choses
CREATE VIEW madrid_listing AS
SELECT L.id                AS listing_id,
  L.nid                    AS nid,
  L.host_id
FROM Listing L,
  City C
WHERE L.city_id = C.city_id
AND C.city      = 'Madrid' ;
SELECT part.nid
FROM
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
AND part.cnt / total.cnt > 0.5 ;
--11
SELECT part.country_id,
  part.cnt / total.cnt
FROM
  (SELECT city.country_id AS country_id ,
    COUNT(DISTINCT L.id)  AS cnt
  FROM Listing_calendar C,
    Listing L,
    City city
  WHERE extract(YEAR FROM C.cdate) = 2018
  AND L.id                         = C.listing_id
  AND L.city_id                    = city.city_id
  AND C.available                  = 't'
  GROUP BY city.country_id
  HAVING COUNT(*) > 0
  ) part,
  (SELECT city.country_id AS country_id ,
    COUNT(DISTINCT L.id)  AS cnt
  FROM Listing_calendar C ,
    Listing L,
    City city
  WHERE L.id    = C.listing_id
  AND L.city_id = city.city_id
  GROUP BY city.country_id
  HAVING COUNT(*) > 0
  ) total
WHERE part.country_id    = total.country_id
AND part.cnt / total.cnt > 0.2 ;
--12
CREATE VIEW barcelona_listing AS
SELECT L.id AS listing_id,
  L.nid     AS nid,
  L.cpid    AS cpid
FROM Listing L,
  City C
WHERE L.city_id = C.city_id
AND C.city      = 'Barcelona' ;
SELECT part.nid,
  part.cnt / total.cnt
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
