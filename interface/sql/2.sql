SELECT AVG(L.review_scores_cleanliness)
FROM Listing L,
  Has_amenity H,
  Amenity A
WHERE A.amenity  = 'TV'
AND H.aid          = A.aid
AND H.listing_id = L.id