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
  AND c2.city = 'Berlin')