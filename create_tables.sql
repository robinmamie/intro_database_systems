CREATE TABLE Listing (
    id INTEGER,
    nid INTEGER,
    -- nid: not originally provided
    listing_url CHAR(40),
    name CHAR(150),
    summary CHAR(1000),
    space CHAR(1000),
    PRIMARY KEY (id),
    FOREIGN KEY (nid) REFERENCES Neighbourhood (nid))

CREATE TABLE Listing_descr(
    id INTEGER,
    description CHAR(xxx),
    neighborhood_overview CHAR(xxx),
    notes CHAR(1000),
    transit CHAR(1000),
    access CHAR(1000),
    interaction CHAR(1000),
    house_rules CHAR(1000),
    picture_url CHAR(116),
    latitude FLOAT,
    longitude FLOAT,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES Listing (id)
    ON DELETE CASCADE)

CREATE TABLE Listing_details(
    id INTEGER,
    property_tyoe CHAR(22),
    room_type CHAR(15),
    accommodates INTEGER,
    bathrooms INTEGER,
    bedrooms INTEGER,
    beds INTEGER,
    bed_type CHAR(13),
    amenities CHAR(1388),
    square_feet INTEGER,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES Listing (id)
    ON DELETE CASCADE)

CREATE TABLE Listing_price(
    id INTEGER,
    price INTEGER,
    weekly_price INTEGER,
    monthly_price INTEGER,
    weekly_price INTEGER,
    security_deposit INTEGER,
    cleaning_fee INTEGER,
    guest_included INTEGER,
    extra_people INTEGER,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES Listing (id)
    ON DELETE CASCADE)

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
  FOREIGN KEY (id) REFERENCES Listing (id)
  ON DELETE CASCADE)

CREATE TABLE Listing_calender(
  id INTEGER,
  date DATE,
  available BIT,
  price FLOAT,
  PRIMARY KEY (id),
  FOREIGN KEY (id) REFERENCES Listing (id)
  ON DELETE CASCADE)

  CREATE TABLE Review(
    id INTEGER NOT NULL,
    uid INTEGER,
    date DATE,
    rid INTEGER,
    comments CHAR(6505),
    PRIMARY KEY(rid),
    FOREIGN KEY (uid) REFERENCES User(uid),
    FOREIGN KEY (id) REFERENCES Listing (id)
    ON DELETE CASCADE)


    CREATE TABLE Neighbourhood(
      nid INTEGER,
      -- not in the data provided: to add ourselves somehow.
      neighbourhood CHAR(31),
      city CHAR(34),
      country_code CHAR(2),
      country CHAR(7),
      PRIMARY KEY(nid))
