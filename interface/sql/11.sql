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
ORDER BY C.CITY