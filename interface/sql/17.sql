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
ANd S.nid = N.nid