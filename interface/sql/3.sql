SELECT DISTINCT H.host_name
FROM Listing L, Host H
WHERE H.host_id = L.host_id
AND L.id       IN
  ( SELECT DISTINCT listing_id
  FROM Listing_calendar
  WHERE cdate >= '01.03.19'--'2019-03-01'
  AND cdate   <= '01-09-19'--'2019-09-01'
  AND available = 't'
  )