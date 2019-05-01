SELECT C.city, cnt
FROM City C,
  (SELECT L.city_id AS cid,
    COUNT(*)        AS cnt
  FROM Listing L
  WHERE L.square_feet IS NOT NULL
  GROUP BY L.city_id
  )
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


CREATE VIEW tmp AS
  SELECT L.host_id AS hid , COUNT(*) AS cnt FROM Listing L GROUP BY L.host_id
  ; 

Select h.host_id, h.host_name
from tmp t2, Host h
WHERE t2.cnt =
(SELECT MAX(t1.cnt)
FROM tmp t1) AND h.host_id = t2.hid
;

  
  
SELECT MAX(tmp.cnt)
FROM tmp t1, tmp t2, Host H
WHERE t1.hid = H.host_id
;
--Order by cnt DESC;
  

SELECT H.host_id, H.host_name, cnt
FROM Host H,
(Select L.host_id as hid , Count(*) as cnt
From Listing L
Group by L.host_id)
WHERE sub.hid = H.host_id
Order by cnt DESC;

