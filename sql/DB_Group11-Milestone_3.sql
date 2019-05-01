--1
SELECT C.city, cnt
FROM City C,
(Select cid1 as cid, Count(*) as cnt 
FROM (SELECT L.city_id AS cid1
  FROM Listing L
  WHERE L.square_feet IS NOT NULL
  GROUP BY L.city_id, L.host_id)
GROUP BY cid1)
WHERE cid = C.city_id
ORDER BY C.CITY;

-- We have to create our own function median
Select L.nid , MEDIAN(L.review_scores_rating)
From Listing L
Where L.review_scores_rating IS NOT NULL
Group by L.nid 
Order by MEDIAN(L.review_scores_rating) DESC
FETCH FIRST 5 ROWS ONLY;

--3


CREATE VIEW host_list_c AS
  SELECT L.host_id AS hid , COUNT(*) AS cnt FROM Listing L GROUP BY L.host_id
  ; 

Select h.host_id, h.host_name
from host_list_c hlc, Host h
WHERE hlc.cnt =
(SELECT MAX(hlc2.cnt)
FROM host_list_c hlc2)
AND h.host_id = hlc.hid
;
