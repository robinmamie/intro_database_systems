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
FETCH FIRST 1 ROWS ONLY