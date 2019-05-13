CREATE TABLE country (
    country_id     INTEGER,
    country        VARCHAR2(7),
    country_code   CHAR(2),
    PRIMARY KEY ( country_id )
);

CREATE TABLE city (
    city_id      INTEGER,
    city         VARCHAR2(40),
    country_id   INTEGER,
    PRIMARY KEY ( city_id ),
    FOREIGN KEY ( country_id )
        REFERENCES country ( country_id )
);

CREATE TABLE neighbourhood (
    nid             INTEGER,
    neighbourhood   VARCHAR2(40),
    city_id         INTEGER,
    PRIMARY KEY ( nid ),
    FOREIGN KEY ( city_id )
        REFERENCES city ( city_id )
);

CREATE TABLE bed_type (
    btid       INTEGER,
    bed_type   VARCHAR2(13),
    PRIMARY KEY ( btid )
);

CREATE TABLE cancellation_policy (
    cpid                  INTEGER,
    cancellation_policy   VARCHAR2(27),
    PRIMARY KEY ( cpid )
);

CREATE TABLE host_response_time (
    hrtid                INTEGER,
    host_response_time   VARCHAR2(18),
    PRIMARY KEY ( hrtid )
);

CREATE TABLE property_type (
    ptid            INTEGER,
    property_type   VARCHAR2(22),
    PRIMARY KEY ( ptid )
);

CREATE TABLE room_type (
    rtid        INTEGER,
    room_type   VARCHAR2(15),
    PRIMARY KEY ( rtid )
);

CREATE TABLE host (
    host_id         INTEGER,
    host_name       VARCHAR2(40),
    url             VARCHAR2(43),
    since           DATE,
    about           VARCHAR2(4000),
    response_time   INTEGER,
    response_rate   INTEGER,
    thumbnail_url   VARCHAR2(120),
    picture_url     VARCHAR2(120),
    nid             INTEGER,
    verifications   VARCHAR2(170),
    PRIMARY KEY ( host_id ),
    FOREIGN KEY ( response_time )
        REFERENCES host_response_time ( hrtid ),
    FOREIGN KEY ( nid )
        REFERENCES neighbourhood
);

CREATE TABLE listing (
    id                                 INTEGER,
    listing_url                        VARCHAR2(40),
    name                               VARCHAR2(150),
    summary                            VARCHAR2(1500),
    space                              VARCHAR2(1500),
    description                        VARCHAR2(1500),
    neighborhood_overview              VARCHAR2(1500),
    notes                              VARCHAR2(1500),
    transit                            VARCHAR2(1500),
    l_access                           VARCHAR2(1500),
    interaction                        VARCHAR2(1500),
    house_rules                        VARCHAR2(1500),
    picture_url                        VARCHAR2(120),
    host_id                            INTEGER,
    --neighbourhood_id
    nid                                INTEGER,
    --city_id
    --city_id                            INTEGER,
    latitude                           FLOAT,
    longitude                          FLOAT,
    --property_type_id
    ptid                               INTEGER,
    --room_type_id
    rtid                               INTEGER,
    accommodates                       INTEGER,
    bathrooms                          FLOAT,
    bedrooms                           INTEGER,
    beds                               INTEGER,
    --bed_type id
    btid                               INTEGER,
    square_feet                        INTEGER,
    price                              FLOAT,
    weekly_price                       FLOAT,
    monthly_price                      FLOAT,
    security_deposit                   FLOAT,
    cleaning_fee                       FLOAT,
    guests_included                    INTEGER,
    extra_people                       FLOAT,
    minimum_nights                     INTEGER,
    maximum_nights                     INTEGER,
    review_scores_rating               INTEGER,
    review_scores_accuracy             INTEGER,
    review_scores_cleanliness          INTEGER,
    review_scores_checkin              INTEGER,
    review_scores_communication        INTEGER,
    review_scores_location             INTEGER,
    review_scores_value                INTEGER,
    is_business_travel_ready           CHAR(1),
    --cancellation_policy_id
    cpid                               INTEGER,
    require_guest_profile_picture      CHAR(1),
    require_guest_phone_verification   CHAR(1),
    PRIMARY KEY ( id ),
    --FOREIGN KEY ( city_id )
    --   REFERENCES city ( city_id ),
    FOREIGN KEY ( host_id )
        REFERENCES host ( host_id ),
    FOREIGN KEY ( ptid )
        REFERENCES property_type ( ptid ),
    FOREIGN KEY ( rtid )
        REFERENCES room_type ( rtid ),
    FOREIGN KEY ( btid )
        REFERENCES bed_type ( btid ),
    FOREIGN KEY ( cpid )
        REFERENCES cancellation_policy ( cpid ),
    FOREIGN KEY ( nid )
        REFERENCES neighbourhood ( nid )
);

CREATE TABLE review (
    rid             INTEGER,
    listing_id      INTEGER NOT NULL,
    reviewer_id     INTEGER,
    reviewer_name   VARCHAR2(60),
    rdate           DATE,
    comments        VARCHAR2(4000),
    PRIMARY KEY ( rid ),
    FOREIGN KEY ( listing_id )
        REFERENCES listing ( id )
            ON DELETE CASCADE
);

CREATE TABLE listing_calendar (
    listing_id   INTEGER,
    cdate        DATE,
    available    CHAR(1),
    price        FLOAT,
    FOREIGN KEY ( listing_id )
        REFERENCES listing ( id )
            ON DELETE CASCADE
);

CREATE TABLE amenity (
    aid       INTEGER,
    amenity   VARCHAR2(50),
    PRIMARY KEY ( aid )
);

CREATE TABLE host_verification (
    hvid                INTEGER,
    host_verification   VARCHAR2(30),
    PRIMARY KEY ( hvid )
);

CREATE TABLE has_host_verification (
    listing_id   INTEGER,
    hvid         INTEGER,
    FOREIGN KEY ( listing_id )
        REFERENCES listing ( id )
            ON DELETE CASCADE,
    FOREIGN KEY ( hvid )
        REFERENCES host_verification ( hvid )
            ON DELETE CASCADE
);

CREATE TABLE has_amenity (
    listing_id   INTEGER,
    aid          INTEGER,
    FOREIGN KEY ( listing_id )
        REFERENCES listing ( id )
            ON DELETE CASCADE,
    FOREIGN KEY ( aid )
        REFERENCES amenity ( aid )
            ON DELETE CASCADE
);