-- speed up 10th & 11th query
CREATE INDEX Listing_nid_idx
ON Listing (nid);

DROP INDEX Listing_nid_idx;

-- speed up 10th & 11th query
CREATE INDEX Calendar_idx
ON Listing_Calendar (extract(YEAR FROM cdate), available);

DROP INDEX Calendar_idx;


CREATE INDEX listing_room_type_idx
ON Listing (rtid);

DROP INDEX listing_room_type_idx;

-- speed up 9th

CREATE INDEX review_listing_id_idx
ON review (listing_id);

DROP INDEX review_listing_id_idx;

-- speed up 10th

CREATE INDEX listing_calendar_idx
ON Listing_Calendar (listing_id);

DROP INDEX listing_calendar_idx;

-- old stuff

CREATE INDEX Calendar_idx_2
ON Listing_Calendar (extract(YEAR FROM cdate));

DROP INDEX Calendar_idx_2;

