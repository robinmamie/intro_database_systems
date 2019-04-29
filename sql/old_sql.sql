CREATE TABLE Neighbourhood(
  nid INTEGER,
  -- not in the data provided: to add ourselves somehow.
  neighbourhood VARCHAR2(40),
  city VARCHAR2(40),
  country_code CHAR(2),
  country VARCHAR2(7),
  PRIMARY KEY(nid)
);


CREATE TABLE Listing (
    id INTEGER,
    nid INTEGER,
    -- nid: not originally provided
    listing_url VARCHAR2(40),
    name VARCHAR2(150),
    summary VARCHAR2(1000),
    space VARCHAR2(1000),
    PRIMARY KEY (id),
    FOREIGN KEY (nid) REFERENCES Neighbourhood (nid)
);

CREATE TABLE Listing_descr(
    id INTEGER,
    description VARCHAR2(1000),
    neighborhood_overview VARCHAR2(1000),
    notes VARCHAR2(1000),
    transit VARCHAR2(1000),
    l_access VARCHAR2(1000),
    interaction VARCHAR2(1000),
    house_rules VARCHAR2(1000),
    picture_url VARCHAR2(120),
    latitude FLOAT,
    longitude FLOAT,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES Listing (id) ON DELETE CASCADE
);

CREATE TABLE Listing_details(
    id INTEGER,
    property_type VARCHAR2(22),
    room_type VARCHAR2(15),
    accommodates INTEGER,
    bathrooms INTEGER,
    bedrooms INTEGER,
    beds INTEGER,
    bed_type VARCHAR2(13),
    amenities VARCHAR2(1400),
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
  cancellation_policy VARCHAR2(27),
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
  uname VARCHAR2(40),
  PRIMARY KEY (user_id)
);

CREATE TABLE Host(
  user_id INTEGER,
  url VARCHAR2(43),
  since DATE,
  about VARCHAR2(4000),
  response_time VARCHAR2(18),
  response_rate INTEGER, -- other value for int. percentages? (no decimal point)
  thumbnail_url VARCHAR2(120),
  picture_url VARCHAR2(120),
  nid INTEGER, -- references id not name
  verifications VARCHAR2(170),
  PRIMARY KEY (user_id),
  FOREIGN KEY (user_id) REFERENCES airbnb_User (user_id) ON DELETE CASCADE,
  FOREIGN KEY (nid) REFERENCES Neighbourhood
);

CREATE TABLE Review(
  id INTEGER NOT NULL,
  user_id INTEGER,
  rdate DATE,
  rid INTEGER,
  comments VARCHAR2(4000),
  PRIMARY KEY(rid),
  FOREIGN KEY (user_id) REFERENCES Airbnb_user(user_id),
  FOREIGN KEY (id) REFERENCES Listing (id) ON DELETE CASCADE
);
