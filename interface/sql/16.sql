SELECT *
FROM
  (SELECT L.host_id,
    lid,
    cnt,
    row_number() over ( partition BY L.host_id order by cnt DESC) row_number
  FROM Listing L,
    (SELECT listing_id AS lid, COUNT(*) AS cnt FROM Review GROUP BY listing_id
    )
  WHERE review_scores_rating IS NOT NULL
  AND L.id                    = lid
  )
WHERE row_number <=3