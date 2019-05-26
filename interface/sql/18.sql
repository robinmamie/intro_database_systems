CREATE OR REPLACE VIEW amenity_list_c AS
SELECT listing_id, COUNT(*) AS cnt FROM Has_amenity GROUP BY listing_id ;


SELECT L1.REVIEW_SCORES_COMMUNICATION - L2.REVIEW_SCORES_COMMUNICATION
FROM Listing L1,
  Listing L2
WHERE L1.id IN
  (SELECT alc1.listing_id
  FROM amenity_list_c alc1
  WHERE alc1.cnt =
    (SELECT MAX (alc2.cnt) FROM amenity_list_c alc2
    )
  FETCH FIRST 1 ROWS ONLY
  )
AND L2.id IN
  (SELECT alc1.listing_id
  FROM amenity_list_c alc1
  WHERE alc1.cnt =
    (SELECT MIN (alc2.cnt) FROM amenity_list_c alc2
    )
  FETCH FIRST 1 ROWS ONLY
  )