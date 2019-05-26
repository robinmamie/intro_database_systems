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
  WHERE C.cdate  >= to_date('01-03-2019', 'dd-MM-yyyy')
  AND C.cdate    <= to_date('30-04-2019', 'dd-MM-yyyy')
  AND C.available = 't'
  GROUP BY C.listing_id
  )
WHERE L.id = lid
AND L.beds >= 2
AND L.REVIEW_SCORES_RATING >= 8.0
AND C.city    = 'Berlin'
AND N.nid = L.nid
AND N.city_id = C.city_id
AND L.ptid = pt.ptid
AND pt.property_type = 'Apartment'
AND CP.CANCELLATION_POLICY = 'flexible'
AND CP.cpid                = L.cpid
AND HV.HOST_VERIFICATION = 'government_id'
AND HHV.hvid             = HV.hvid
AND HHV.listing_id       = L.id
ORDER BY lprice
FETCH FIRST 5 ROWS ONLY
