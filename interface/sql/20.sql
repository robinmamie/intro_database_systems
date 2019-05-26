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
    HAVING MAX(H.since) <= to_date('01-06-2017', 'dd-MM-yyyy')
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
