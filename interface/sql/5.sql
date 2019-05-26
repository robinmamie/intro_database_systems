SELECT c.cdate
FROM Listing_calendar c, Listing l, Host h
WHERE c.listing_id = l.id
AND l.host_id = h.host_id
AND h.host_name = 'Viajes Eco'
AND c.available = 't'