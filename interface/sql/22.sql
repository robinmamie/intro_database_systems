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
AND part.cnt / total.cnt > 0.05 