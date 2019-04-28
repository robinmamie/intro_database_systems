SELECT  L.id, L.name
FROM Listing L,
  City C
WHERE L.city_id   = C.city_id
AND C.city = 'Barcelona'
ORDER BY L.review_scores_rating DESC
FETCH FIRST 10 ROWS ONLY
