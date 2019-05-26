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
WHERE row_number <= 5