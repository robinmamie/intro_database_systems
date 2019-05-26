CREATE OR REPLACE VIEW host_list_c AS
SELECT L.host_id AS hid , COUNT(*) AS cnt FROM Listing L GROUP BY L.host_id ;
SELECT h.host_id,
  h.host_name
FROM host_list_c hlc,
  Host h
WHERE hlc.cnt =
  (SELECT MAX(hlc2.cnt) FROM host_list_c hlc2
  )
AND h.host_id = hlc.hid 