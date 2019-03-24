CREATE TABLE Neighbourhood(
  nid INTEGER,
  -- not in the data provided: to add ourselves somehow.
  neighbourhood VARCHAR(40),
  city VARCHAR(40),
  country_code CHAR(2),
  country VARCHAR(7),
  PRIMARY KEY(nid)
);


CREATE TABLE Listing (
    id INTEGER,
    nid INTEGER,
    -- nid: not originally provided
    listing_url VARCHAR(40),
    name VARCHAR(150),
    summary VARCHAR(1000),
    space VARCHAR(1000),
    PRIMARY KEY (id),
    FOREIGN KEY (nid) REFERENCES Neighbourhood (nid)
);

CREATE TABLE Listing_descr(
    id INTEGER,
    description VARCHAR(1000),
    neighborhood_overview VARCHAR(1000),
    notes VARCHAR(1000),
    transit VARCHAR(1000),
    l_access VARCHAR(1000),
    interaction VARCHAR(1000),
    house_rules VARCHAR(1000),
    picture_url VARCHAR(120),
    latitude FLOAT,
    longitude FLOAT,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES Listing (id) ON DELETE CASCADE
);

CREATE TABLE Listing_details(
    id INTEGER,
    property_type VARCHAR(22),
    room_type VARCHAR(15),
    accommodates INTEGER,
    bathrooms INTEGER,
    bedrooms INTEGER,
    beds INTEGER,
    bed_type VARCHAR(13),
    amenities VARCHAR(1400),
    square_feet INTEGER,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES Listing (id) ON DELETE CASCADE
);

CREATE TABLE Listing_price(
    id INTEGER,
    price INTEGER,
    weekly_price INTEGER,
    monthly_price INTEGER,
    security_deposit INTEGER,
    cleaning_fee INTEGER,
    guest_included INTEGER,
    extra_people INTEGER,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES Listing (id) ON DELETE CASCADE
);

CREATE TABLE Listing_score(
  id INTEGER,
  review_scores_rating INTEGER,
  review_scores_accuracy INTEGER,
  review_scores_cleanliness INTEGER,
  review_scores_checkin INTEGER,
  review_scores_communication INTEGER,
  review_scores_location INTEGER,
  review_scores_value INTEGER,
  PRIMARY KEY (id),
  FOREIGN KEY (id) REFERENCES Listing (id) ON DELETE CASCADE
);
  
CREATE TABLE Listing_cond(
  id INTEGER,
  minimum_nights INTEGER,
  maximum_nights INTEGER,
  is_business_travel_ready CHAR(1),
  cancellation_policy VARCHAR(27),
  require_guest_profile_picture CHAR(1),
  require_guest_phone_verification CHAR(1),
  PRIMARY KEY (id),
  FOREIGN KEY (id) REFERENCES Listing (id) ON DELETE CASCADE
);

CREATE TABLE Listing_calendar(
  id INTEGER,
  cdate DATE,
  available CHAR(1),
  price FLOAT,
  PRIMARY KEY (id),
  FOREIGN KEY (id) REFERENCES Listing (id) ON DELETE CASCADE
);
  
CREATE TABLE airbnb_User(
  user_id INTEGER,
  uname VARCHAR(40),
  PRIMARY KEY (user_id)
);

CREATE TABLE Host(
  user_id INTEGER,
  url VARCHAR(43),
  since DATE,
  --about TEXT,
  response_time VARCHAR(18),
  response_rate INTEGER, -- other value for int. percentages? (no decimal point)
  thumbnail_url VARCHAR(120),
  picture_url VARCHAR(120),
  nid INTEGER, -- references id not name
  verifications VARCHAR(170),
  PRIMARY KEY (user_id),
  FOREIGN KEY (user_id) REFERENCES airbnb_User (user_id) ON DELETE CASCADE,
  FOREIGN KEY (nid) REFERENCES Neighbourhood
);

CREATE TABLE Review(
  id INTEGER NOT NULL,
  user_id INTEGER,
  rdate DATE,
  rid INTEGER,
  --comments VARCHAR(7000),
  PRIMARY KEY(rid),
  FOREIGN KEY (user_id) REFERENCES Airbnb_user(user_id),
  FOREIGN KEY (id) REFERENCES Listing (id) ON DELETE CASCADE
);


