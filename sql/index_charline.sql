-- speed up 10th & 11th query
CREATE INDEX Listing_nid
ON Listing (nid);

DROP INDEX Listing_nid;

-- speed up 10th & 11th query
CREATE INDEX Calendar_idx
ON Listing_Calendar (extract(YEAR FROM cdate), available);

DROP INDEX Calendar_idx;

--

CREATE INDEX ham
ON Listing (rtid);

DROP INDEX ham;

CREATE INDEX ham2
ON review (listing_id);

DROP INDEX ham2;

CREATE INDEX Calendar_idx_2
ON Listing_Calendar (extract(YEAR FROM cdate));
