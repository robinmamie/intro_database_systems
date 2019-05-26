SELECT DISTINCT H.host_name
FROM Listing L, Host H
WHERE H.host_id = L.host_id
AND L.id       IN
  ( SELECT DISTINCT listing_id
  FROM Listing_calendar
  WHERE cdate >= to_date('01-03-2019', 'dd-MM-yyyy')
  AND cdate   <= to_date('01-09-2019', 'dd-MM-yyyy')
  )
