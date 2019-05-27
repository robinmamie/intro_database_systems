-- speed up 10th query
CREATE INDEX Listing_nid
ON Listing (nid);

DROP INDEX Listing_nid;


-- Eric's old stuff
CREATE INDEX Calendar_idx
ON Listing_Calendar (extract(YEAR FROM cdate), available);

DROP INDEX Calendar_idx_2;

CREATE INDEX Calendar_idx_2
ON Listing_Calendar (extract(YEAR FROM cdate));
