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
  ) FROM DUAL
