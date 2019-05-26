SELECT L.id,
  Round(lprice,2)
FROM Listing L,
  City C,
  Neighbourhood N,
  Property_type pt,
  Cancellation_policy CP,
  HAS_HOST_VERIFICATION HHV,
  HOST_VERIFICATION HV,
  (SELECT C.listing_id AS lid ,
    AVG(C.price)       AS lprice
  FROM Listing_calendar C
  WHERE C.cdate  >= '01.03.19'--'2019-03-01'
  AND C.cdate    <= '30-04-19'--'2019-09-01'
  AND C.available = 't'
  GROUP BY C.listing_id
  )
WHERE L.id = lid
  -- # Beds >= 2
AND L.beds >= 2
  -- REVIEW_SCORES_RATING >= 8
AND L.REVIEW_SCORES_RATING >= 8.0
  -- City : Berlin
AND C.city    = 'Berlin'
AND N.nid = L.nid
AND N.city_id = C.city_id
AND L.ptid = pt.ptid
AND pt.property_type = 'Apartment'
  -- Cancellation_policy : flexible
AND CP.CANCELLATION_POLICY = 'flexible'
AND CP.cpid                = L.cpid
  -- host_verification : government_id
AND HV.HOST_VERIFICATION = 'government_id'
AND HHV.hvid             = HV.hvid
AND HHV.listing_id       = L.id
  --search the 5 cheapest
ORDER BY lprice
FETCH FIRST 5 ROWS ONLY 