SELECT H.host_id, H.host_name
FROM Host H
WHERE H.host_id IN (SELECT  L.host_id
FROM Listing L, City C1, Country C2
WHERE L.city_id   = C1.city_id
AND C1.country_id = C2.country_id
AND C2.country = 'Spain'
GROUP BY L.host_id
ORDER BY COUNT(*) DESC
FETCH FIRST 10 ROWS ONLY)
