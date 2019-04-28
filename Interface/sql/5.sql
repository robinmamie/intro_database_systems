SELECT C.cdate
FROM Listing L,
  Host H,
  Listing_calendar C
WHERE L.host_id  = H.host_id
AND H.host_name  = 'Viajes Eco'
AND C.listing_id = L.id
AND C.available  = 't'
