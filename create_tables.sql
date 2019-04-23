CREATE TABLE Neighbourhood(
  nid INTEGER,
  neighbourhood VARCHAR2(40),
  PRIMARY KEY(nid)
);

CREATE TABLE City(
  cid INTEGER,
  city VARCHAR2(40),
  country VARCHAR2(7),
  country_code CHAR(2),
  PRIMARY KEY(cid)
);

--CREATE TABLE Airbnb_user(
--  user_id INTEGER,
--  user_name VARCHAR2(40),
--  PRIMARY KEY (user_id)
--);

CREATE TABLE Bed_type(
  btid INTEGER,
  bed_type VARCHAR2(13),
  PRIMARY KEY (btid)
);

CREATE TABLE Cancellation_policy(
  cpid INTEGER,
  cancellation_policy VARCHAR2(27),
  PRIMARY KEY (cpid)
);

CREATE TABLE Host_response_time(
  hrtid INTEGER,
  host_response_time VARCHAR2(18),
  PRIMARY KEY (hrtid)
);

CREATE TABLE Property_type(
  ptid INTEGER,
  property_type VARCHAR2(22),
  PRIMARY KEY (ptid)
);

CREATE TABLE Room_type(
  rtid INTEGER,
  room_type VARCHAR2(15),
  PRIMARY KEY (rtid)
);

CREATE TABLE Host(
  user_id INTEGER,
  user_name VARCHAR2(40),
  url VARCHAR2(43),
  since DATE,
  about VARCHAR2(4000),
  response_time INTEGER,
  response_rate INTEGER, -- other value for int. percentages? (no decimal point)
  thumbnail_url VARCHAR2(120),
  picture_url VARCHAR2(120),
  nid INTEGER, -- references id not name
  verifications VARCHAR2(170),
  PRIMARY KEY (user_id),
  FOREIGN KEY (response_time) REFERENCES Host_response_time(hrtid),
 -- FOREIGN KEY (user_id) REFERENCES airbnb_User (user_id) ON DELETE CASCADE,
  FOREIGN KEY (nid) REFERENCES Neighbourhood
);


CREATE TABLE Listing (
    id INTEGER,
    listing_url VARCHAR2(40),
    name VARCHAR2(150),
    summary VARCHAR2(1500),
    space VARCHAR2(1500),
    description VARCHAR2(1500),
    neighborhood_overview VARCHAR2(1500),
    notes VARCHAR2(1500),
    transit VARCHAR2(1500),
    l_access VARCHAR2(1500),
    interaction VARCHAR2(1500),
    house_rules VARCHAR2(1500),
    picture_url VARCHAR2(120),
    user_id INTEGER,
    nid INTEGER,
    cid INTEGER,
    latitude FLOAT,
    longitude FLOAT,
    ptid INTEGER,
    rtid INTEGER,
    accommodates INTEGER,
    bathrooms FLOAT,
    bedrooms INTEGER,
    beds INTEGER,
    btid INTEGER,
    amenities VARCHAR2(1400),
    square_feet INTEGER,
    price FLOAT,
    weekly_price FLOAT,
    monthly_price FLOAT,
    security_deposit FLOAT,
    cleaning_fee FLOAT,
    guests_included INTEGER,
    extra_people FLOAT,
    minimum_nights INTEGER,
    maximum_nights INTEGER,
    review_scores_rating INTEGER,
    review_scores_accuracy INTEGER,
    review_scores_cleanliness INTEGER,
    review_scores_checkin INTEGER,
    review_scores_communication INTEGER,
    review_scores_location INTEGER,
    review_scores_value INTEGER,
    is_business_travel_ready CHAR(1),
    cpid INTEGER,
    require_guest_profile_picture CHAR(1),
    require_guest_phone_verification CHAR(1),
    
    
    PRIMARY KEY (id),
    FOREIGN KEY (cid) REFERENCES City (cid),
    FOREIGN KEY (user_id) REFERENCES Host(user_id),
    FOREIGN KEY (ptid) REFERENCES Property_type (ptid),
    FOREIGN KEY (rtid) REFERENCES Room_type (rtid),
    FOREIGN KEY (btid) REFERENCES Bed_type (btid),
    FOREIGN KEY (cpid) REFERENCES Cancellation_policy (cpid),
    FOREIGN KEY (nid) REFERENCES Neighbourhood (nid)
);



CREATE TABLE Review(
  rid INTEGER,
  listing_id INTEGER NOT NULL,
  user_id INTEGER,
  user_name VARCHAR2(60),
  rdate DATE,
  comments VARCHAR2(4000),
  PRIMARY KEY(rid),
  --FOREIGN KEY (user_id) REFERENCES Host(user_id),
  FOREIGN KEY (listing_id) REFERENCES Listing (id) ON DELETE CASCADE
);



CREATE TABLE Listing_calendar(
  listing_id INTEGER,
  cdate DATE,
  available CHAR(1),
  price FLOAT,
  --PRIMARY KEY (listing_id),
  FOREIGN KEY (listing_id) REFERENCES Listing (id) ON DELETE CASCADE
);

CREATE TABLE Amenity(
  aid INTEGER,
  amenity VARCHAR2(50),
  PRIMARY KEY (aid)
);

CREATE TABLE Host_verification(
  hvid INTEGER,
  host_verification VARCHAR2(30),
  PRIMARY KEY (hvid)
);


CREATE TABLE Has_host_verification(
  listing_id INTEGER,
  hvid INTEGER,
  FOREIGN KEY (listing_id) REFERENCES Listing (id) ON DELETE CASCADE,
  FOREIGN KEY (hvid) REFERENCES Host_verification (hvid) ON DELETE CASCADE
);

CREATE TABLE Has_amenity(
  listing_id INTEGER,
  aid INTEGER,
  FOREIGN KEY (listing_id) REFERENCES Listing (id) ON DELETE CASCADE,
  FOREIGN KEY (aid) REFERENCES Amenity (aid) ON DELETE CASCADE
);



