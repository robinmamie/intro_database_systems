SELECT host_id, host_name
FROM Host
WHERE host_id IN
  ( SELECT host_id FROM Listing GROUP BY host_id HAVING COUNT(*)=1
  )