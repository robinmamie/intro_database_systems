SELECT
  (SELECT AVG(L.price)
  FROM Listing L,
    City C
  WHERE L.beds= 8
  AND L.city_id      = C.city_id
  AND C.city      = 'Berlin'
  ) -
  (SELECT AVG(L.price)
  FROM Listing L,
    City C
  WHERE L.beds= 8
  AND L.city_id       = C.city_id
  AND C.city      = 'Madrid'
  )
FROM DUAL
