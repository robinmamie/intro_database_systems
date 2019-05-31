CREATE OR REPLACE VIEW neigh_listing AS
SELECT L.id,
  L.nid AS nid,
  L.review_scores_rating,
  row_number() over ( partition BY L.nid order by L.review_scores_rating DESC) row_number
FROM Listing L
WHERE review_scores_rating IS NOT NULL;
SELECT N.neighbourhood,
  S.median
FROM
  Neighbourhood N,
  (SELECT co.nid,
    (nl1.review_scores_rating + nl2.review_scores_rating)/2 AS median
  FROM neigh_listing nl1,
    neigh_listing nl2,
    (SELECT L.nid           AS nid,
      FLOOR((COUNT(*)+1)/2) AS low,
      CEIL((COUNT( *)+1)/2) AS high
    FROM Listing L
    WHERE L.review_scores_rating IS NOT NULL
    GROUP BY L.nid
    ) co
  WHERE co.nid       = nl1.nid
  AND co.nid         = nl2.nid
  AND nl1.row_number = co.high
  AND nl2.row_number = co.low
  ) S
WHERE N.nid = S.nid
ORDER BY median DESC
FETCH FIRST 5 ROWS ONLY
