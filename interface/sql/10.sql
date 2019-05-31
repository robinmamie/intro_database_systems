SELECT  L.id, L.name
FROM Listing L,
  City C, 
    Neighbourhood N,
    Property_type pt
WHERE L.nid  = N.nid
  AND N.city_id = C.city_id
AND C.city = 'Barcelona'
AND L.ptid = pt.ptid
AND pt.property_type = 'Apartment'
AND L.review_scores_rating IS NOT NULL
ORDER BY L.review_scores_rating DESC
FETCH FIRST 10 ROWS ONLY