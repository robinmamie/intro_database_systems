CREATE TABLE Listing (
    id INTEGER,
    listing_url CHAR(40),
    name CHAR(150),
    summary CHAR(xxx),
    space CHAR(xxx),
    PRIMARY KEY (id))

CREATE TABLE Listing_descr(
    id INTEGER,
    description CHAR(xxx),
    neighborhood_overview CHAR(xxx),
    notes CHAR(xxx),
    transit CHAR(xxx),
    access CHAR(xxx),
    interaction CHAR(xxx),
    house_rules CHAR(xxx),
    picture_url CHAR(xxx),
    latitude FLOAT,
    longitude FLOAT,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES Listing (id))

CREATE TABLE Listing_details(
    id INTEGER,
    property_tyoe CHAR(xxx),
    room_type CHAR(xxx),
    accommodates INTEGER,
    bathrooms INTEGER,
    bedrooms INTEGER,
    beds INTEGER,
    bed_type CHAR(xxx),
    amenities CHAR(xxx),
    square_feet INTEGER,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES Listing (id))

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
    FOREIGN KEY (id) REFERENCES Listing (id))

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
  FOREIGN KEY (id) REFERENCES Listing (id))

CREATE TABLE Listing_calender(
  id INTEGER,
  date DATE,
  available BIT,
  price FLOAT,
  PRIMARY KEY (id),
  FOREIGN KEY (id) REFERENCES Listing (id))
