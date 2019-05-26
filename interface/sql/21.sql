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
AND part.cnt / total.cnt > 0.2 