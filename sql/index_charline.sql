-- index to speed up 9th query
CREATE INDEX REVIEW_LID_IDX
ON REVIEW (LISTING_ID);

DROP INDEX REVIEW_LID_IDX;

-- index to speed up 10th query
CREATE INDEX Calendar_idx_lst
ON Listing_Calendar (listing_id);

DROP INDEX Calendar_idx_1st;

-- Eric's old stuff
CREATE INDEX Calendar_idx
ON Listing_Calendar (extract(YEAR FROM cdate), available);

DROP INDEX Calendar_idx;

CREATE INDEX Calendar_idx_2
ON Listing_Calendar (extract(YEAR FROM cdate));
