SELECT COUNT(L.id)
FROM Listing L
WHERE L.host_id IN
  ( SELECT DISTINCT H1.host_id
 FROM Host H1,
    Host H2
  WHERE H1.host_id != H2.host_id
  AND H1.host_name = H2.host_name
  )