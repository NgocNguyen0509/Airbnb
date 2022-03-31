--import data to psql--

CREATE SCHEMA airbnb;
---------- CALENDAR ----------
CREATE TABLE airbnb.calendar (         ---create calender table
	date date NOT NULL,
	listing_id int NOT NULL,          
	available BOOLEAN ,               
	price_$ VARCHAR(255),              
	adjusted_price_$ VARCHAR(255),    
	minimum_nights int,          
	maximum_nights int,               
	CONSTRAINT pk_calendar PRIMARY KEY (listing_id, date) --- set primary key on lisitngs ID 
);
--insert cvs to table in sql shell, file path needs to be changed
\copy airbnb.calendar (listing_id,date,available,price_$,adjusted_price_$,minimum_nights,maximum_nights) FROM '/Users/ngocnguyen/Dropbox/Mac/Desktop/SQL/calendar.csv' DELIMITER E',' CSV HEADER;      --- PATH to the csv file need to change 



---------- LISTINGS ----------
CREATE TABLE airbnb.listings (             --- create the lisitng table 
	id  int,
	listing_url  VARCHAR(50),
	scrape_id bigint,
	last_scraped  date,
	name  VARCHAR(255),
	description  VARCHAR(1000),
	neighborhood_overview  VARCHAR(1000),
	picture_url  VARCHAR(255),
	host_id  int,
	host_url  VARCHAR(255),
	host_name  VARCHAR(50),
	host_since  date,
	host_location  VARCHAR(255),
	host_about  VARCHAR,
	host_response_time  VARCHAR(18),
	host_response_rate  VARCHAR(4),
	host_acceptance_rate  VARCHAR(4),
	host_is_superhost  BOOLEAN,
	host_thumbnail_url  VARCHAR(255),
	host_picture_url  VARCHAR(255),
	host_neighbourhood  VARCHAR(50),
	host_listings_count  smallint,
	host_total_listings_count  smallint,
	host_verifications  VARCHAR,
	host_has_profile_pic  BOOLEAN,
	host_identity_verified  BOOLEAN,
	neighbourhood  VARCHAR(255),
	neighbourhood_cleansed  TSVECTOR,
	neighbourhood_group_cleansed  VARCHAR(255),
	latitude  FLOAT,
	longitude  FLOAT,
	property_type  VARCHAR(255),
	room_type  VARCHAR(255),
	accommodates  smallint,
	bathrooms  smallint,
	bathrooms_text  VARCHAR(255),
	bedrooms  smallint,
	beds  smallint,
	amenities  VARCHAR,
	price_$  VARCHAR,
	minimum_nights  smallint,
	maximum_nights  int,
	minimum_minimum_nights  smallint,
	maximum_minimum_nights  smallint,
	minimum_maximum_nights  int,
	maximum_maximum_nights  int,
	minimum_nights_avg_ntm  FLOAT,
	maximum_nights_avg_ntm  FLOAT,
	calendar_updated  VARCHAR(255),
	has_availability  BOOLEAN,
	availability_30  smallint,
	availability_60  smallint,
	availability_90  smallint,
	availability_365  smallint,
	calendar_last_scraped  date,
	number_of_reviews  smallint,
	number_of_reviews_ltm  smallint,
	number_of_reviews_l30d  smallint,
	first_review  date,
	last_review  date,
	review_scores_rating  numeric,
	review_scores_accuracy  numeric,
	review_scores_cleanliness  numeric,
	review_scores_checkin  numeric,
	review_scores_communication  numeric,
	review_scores_location  numeric,
	review_scores_value  numeric,
	license  VARCHAR(255),
	instant_bookable  BOOLEAN,
	calculated_host_listings_count  smallint,
	calculated_host_listings_count_entire_homes  smallint,
	calculated_host_listings_count_private_rooms  smallint,
	calculated_host_listings_count_shared_rooms  smallint,
	reviews_per_month  FLOAT,
	CONSTRAINT pk_listings PRIMARY KEY(id)                  --- set the primary key to id of listings
);

--insert cvs to table in sql shell, file path needs to be changed
\copy airbnb.listings (id,listing_url,scrape_id,last_scraped,name,description,neighborhood_overview,picture_url,host_id,host_url,host_name,host_since,host_location,host_about,host_response_time,host_response_rate,host_acceptance_rate,host_is_superhost,host_thumbnail_url,host_picture_url,host_neighbourhood,host_listings_count,host_total_listings_count,host_verifications,host_has_profile_pic,host_identity_verified,neighbourhood,neighbourhood_cleansed,neighbourhood_group_cleansed,latitude,longitude,property_type,room_type,accommodates,bathrooms,bathrooms_text,bedrooms,beds,amenities,price_$,minimum_nights,maximum_nights,minimum_minimum_nights,maximum_minimum_nights,minimum_maximum_nights,maximum_maximum_nights,minimum_nights_avg_ntm,maximum_nights_avg_ntm,calendar_updated,has_availability,availability_30,availability_60,availability_90,availability_365,calendar_last_scraped,number_of_reviews,number_of_reviews_ltm,number_of_reviews_l30d,first_review,last_review,review_scores_rating,review_scores_accuracy,review_scores_cleanliness,review_scores_checkin,review_scores_communication,review_scores_location,review_scores_value,license,instant_bookable,calculated_host_listings_count,calculated_host_listings_count_entire_homes,calculated_host_listings_count_private_rooms,calculated_host_listings_count_shared_rooms,reviews_per_month) FROM '/Users/ngocnguyen/Dropbox/Mac/Desktop/SQL/listings.csv' DELIMITER E',' CSV HEADER; 
----Drop NA columns---
ALTER TABLE airbnb.listings DROP COLUMN calendar_updated,
                            DROP COLUMN bathrooms,
							DROP COLUMN neighbourhood_group_cleansed, 
							DROP COLUMN license;

---------- REVIEWS ----------
CREATE TABLE airbnb.reviews (                   --create reviews table
	listing_id int,
	id bigint,
	date date,
	reviewer_id int, 
	reviewer_name VARCHAR(50),
	comments VARCHAR,
	CONSTRAINT pk_reviews PRIMARY KEY (id)       --- set the primary key to id of listings
);

--insert cvs to table in sql shell, file path needs to be changed
\copy airbnb.reviews (listing_id,id,date,reviewer_id,reviewer_name,comments) FROM '/Users/ngocnguyen/Dropbox/Mac/Desktop/SQL/reviews.csv' DELIMITER ',' CSV HEADER;



--Alter table--


--- Alter datatype to int for price 
ALTER TABLE airbnb.calendar ALTER COLUMN price_$ TYPE int USING (TRANSLATE(price_$,',$','')::float::numeric);                   --- change price from VARCHAR to NUMERIC
ALTER TABLE airbnb.calendar ALTER COLUMN adjusted_price_$ TYPE int USING (TRANSLATE(adjusted_price_$,',$','')::float::numeric); --- change adjusted_price from VARCHAR to NUMERIC

ALTER TABLE airbnb.listings ALTER COLUMN price_$ TYPE int USING (TRANSLATE(price_$,',$','')::float::numeric);  --- change price from VARCHAR to NUMERIC

--------------normalisation----------
----- CREATE listing_scrape table 
----- CREATE DISTINCT listings_host table

CREATE TABLE airbnb.listings_host_info AS
SELECT DISTINCT
		host_id,
		host_url,
		host_name,
		host_since,
		host_location,
		host_about,
		host_response_time,
		host_response_rate,
		host_acceptance_rate,
		host_is_superhost,
		host_thumbnail_url,
		host_picture_url,
		host_neighbourhood,
		host_listings_count,
		host_total_listings_count,
		host_verifications,
		host_identity_verified,
		host_has_profile_pic,
		calculated_host_listings_count,
		calculated_host_listings_count_entire_homes,
		calculated_host_listings_count_shared_rooms
		FROM airbnb.listings;
				
	
ALTER TABLE airbnb.listings_host_info ADD PRIMARY KEY(host_id);   --- set the primary key to host id




----- CREATE listing_scrape table 
CREATE TABLE airbnb.listings_scrape AS
SELECT id,
       listing_url,
       last_scraped,
	   scrape_id,
	   calendar_last_scraped
	   FROM airbnb.listings;
	   
ALTER TABLE airbnb.listings_scrape ADD PRIMARY KEY(id);    --- set the primary key to id of listings_scrape



----- CREATE TABLE listings_accommadation
CREATE TABLE airbnb.listings_accommodation AS
SELECT id,
       name,
	   description,
	   neighborhood_overview,
	   picture_url,
	   neighbourhood,
	   neighbourhood_cleansed,
	   latitude,
	   longitude,
	   property_type,
	   room_type,
	   accommodates,
	   bathrooms_text,
	   bedrooms,
	   beds,
	   price_$,
	   minimum_nights,
	   maximum_nights,
	   minimum_minimum_nights,
	   maximum_minimum_nights,
	   maximum_maximum_nights,
	   minimum_maximum_nights,
	   minimum_nights_avg_ntm,
	   maximum_nights_avg_ntm,
	   has_availability,
	   availability_30,
	   availability_60,
	   availability_90,
	   availability_365,
	   instant_bookable
	   FROM airbnb.listings;
	   
ALTER TABLE airbnb.listings_accommodation ADD PRIMARY KEY(id);    --- set the primary key to id of listings_scrape

----- CREATE TABLE listings_review
CREATE TABLE airbnb.listings_review AS
SELECT id,
       number_of_reviews,
	   number_of_reviews_ltm,
	   number_of_reviews_l30d,
	   first_review,
	   last_review,
	   review_scores_rating,
	   review_scores_accuracy,
	   review_scores_cleanliness,
	   review_scores_checkin,
	   review_scores_communication,
	   review_scores_location,
	   review_scores_value,
	   reviews_per_month
	   FROM airbnb.listings;
	   
ALTER TABLE airbnb.listings_review ADD PRIMARY KEY(id);    --- set the primary key to id of listings_scrape

---- CREATE TABLE amentities---
----- CREATE TABLE listings_ameninities

CREATE TABLE airbnb.listings_amenities AS 
WITH to_remove AS (
SELECT id,
	   UNNEST(string_to_array(amenities,'", "')) AS amenities   --- convert strings to arrays and spearate in each column paried with the listing id
	FROM airbnb.listings
	WHERE amenities IS NOT NULL
	), to_remove2 AS (
SELECT id,
	   TRIM(amenities,']"["') amenities
	FROM to_remove
	), to_remove3 AS (
SELECT DISTINCT * FROM to_remove2)
SELECT *
	FROM to_remove3;

ALTER TABLE airbnb.listings_amenities ADD PRIMARY KEY(id,amenities);  --- set the primary key to id of airbnb.listings_amenities


------ Create table host_vertify_by---


CREATE TABLE airbnb.listings_host_verify AS 
WITH v1 AS (
SELECT host_id,
	   UNNEST(string_to_array(host_verifications,',')) AS host_verifications   --- convert strings to arrays and spearate in each column paried with the listing id
	FROM airbnb.listings_host_info                                                           
	WHERE host_identity_verified = true AND host_verifications IS NOT NULL                                                  
	), v2 AS (                                                                            
SELECT host_id,                                                                           
	   TRIM(TRANSLATE(host_verifications,'['']','')) host_verifications
	FROM v1
	), v3 AS (
SELECT DISTINCT * FROM v2)
SELECT *
	FROM v3;
	
--- CREATE room type id
CREATE TABLE airbnb.room_type (id SERIAL primary key, 
				  room_type VARCHAR(255) NOT NULL
				  ); 

INSERT INTO airbnb.room_type ( room_type) 
SELECT DISTINCT room_type AS type1 
FROM airbnb.listings GROUP BY type1;

--- UPDATE room type id
UPDATE airbnb.listings
SET room_type = airbnb.room_type.id
FROM airbnb.room_type
WHERE airbnb.listings.room_type = airbnb.room_type.room_type;


--- CREATE property type id
CREATE TABLE airbnb.property_type (
	id SERIAL PRIMARY KEY,
	listing_type VARCHAR (255) NOT NULL
); 


INSERT INTO airbnb.property_type(listing_type) 
SELECT DISTINCT property_type AS type2 
FROM airbnb.listings GROUP BY type2;

--- UPDATE property type id 
UPDATE airbnb.listings
SET property_type = airbnb.property_type.id
FROM airbnb.property_type
WHERE airbnb.listings.property_type = airbnb.property_type.listing_type;


--- CREATE amenities type id
CREATE TABLE airbnb.amenities_type (
	id SERIAL PRIMARY KEY,
	amenities_type VARCHAR(255) NOT NULL
);

INSERT INTO airbnb.amenities_type (amenities_type)
SELECT DISTINCT amenities AS amenities_type
FROM airbnb.listings_amenities GROUP BY amenities_type;

--- UPDATE amenities type id 
UPDATE airbnb.listings_amenities 
SET amenities = airbnb.amenities_type.id
FROM airbnb.amenities_type
WHERE airbnb.listings_amenities.amenities = airbnb.amenities_type.amenities_type;

--- CREATE host_verify_by id

CREATE TABLE airbnb.listings_host_verify_by (
	id SERIAL PRIMARY KEY,
	vertifications_type VARCHAR(255) NOT NULL
);


INSERT INTO airbnb.listings_host_verify_by (vertifications_type)
SELECT distinct airbnb.listings_host_verify.host_verifications as vertifications_type
FROM airbnb.listings_host_verify GROUP BY vertifications_type;

--- UPDATE verify type id 
UPDATE airbnb.listings_host_verify
SET host_verifications = airbnb.listings_host_verify_by.id
FROM airbnb.listings_host_verify_by
WHERE airbnb.listings_host_verify.host_verifications = airbnb.listings_host_verify_by.vertifications_type;

--- ALTER column to smallint for foreign key airbnb.amenities_type
ALTER TABLE airbnb.listings ALTER COLUMN room_type TYPE smallint USING (TRIM(room_type)::integer);

ALTER TABLE airbnb.listings ALTER COLUMN property_type TYPE smallint USING (TRIM(property_type)::integer);

ALTER TABLE airbnb.listings_amenities ALTER COLUMN amenities TYPE smallint USING (TRIM(amenities)::integer);

ALTER TABLE airbnb.listings_host_verify ALTER COLUMN host_verifications TYPE smallint USING (TRIM(host_verifications)::integer);


--------------------------------- DROP INFORMATION THAT EXISTS IN OTHER TABLES ---------------------------------

--- DROP FOR airbnb_listing_host_info
ALTER TABLE airbnb.listings
DROP COLUMN host_url,
DROP COLUMN host_name,
DROP COLUMN host_since,
DROP COLUMN host_location,
DROP COLUMN host_about,
DROP COLUMN host_response_time,
DROP COLUMN host_response_rate,
DROP COLUMN host_acceptance_rate,
DROP COLUMN host_is_superhost,
DROP COLUMN host_thumbnail_url,
DROP COLUMN host_picture_url,
DROP COLUMN host_neighbourhood,
DROP COLUMN host_listings_count,
DROP COLUMN host_total_listings_count,
DROP COLUMN host_verifications,
DROP COLUMN host_identity_verified,
DROP COLUMN host_has_profile_pic,
DROP COLUMN calculated_host_listings_count,
DROP COLUMN calculated_host_listings_count_entire_homes,
DROP COLUMN calculated_host_listings_count_shared_rooms;
	
--- DROP FOR airbnb.listings_scrape
ALTER TABLE airbnb.listings 
DROP COLUMN listing_url,
DROP COLUMN last_scraped,
DROP COLUMN scrape_id,
DROP COLUMN calendar_last_scraped;

--- DROP host_verification from lisitngs_host_info table 
ALTER TABLE airbnb.listings_host_info
DROP COLUMN host_verifications;

--- DROP minimum and maximum night from airbnb calendar table 
ALTER TABLE airbnb.calendar
DROP COLUMN minimum_nights,
DROP COLUMN maximum_nights;

--- DROP for lisitngs_review table 
ALTER TABLE airbnb.listings
DROP COLUMN number_of_reviews,
DROP COLUMN number_of_reviews_ltm,
DROP COLUMN number_of_reviews_l30d,
DROP COLUMN first_review,
DROP COLUMN last_review,
DROP COLUMN review_scores_rating,
DROP COLUMN review_scores_accuracy,
DROP COLUMN review_scores_cleanliness,
DROP COLUMN review_scores_checkin,
DROP COLUMN review_scores_communication,
DROP COLUMN review_scores_location,
DROP COLUMN review_scores_value,
DROP COLUMN reviews_per_month;

--- DROP for lisitngs_accommodation table 
ALTER TABLE airbnb.listings
DROP COLUMN name,
DROP COLUMN description,
DROP COLUMN neighborhood_overview,
DROP COLUMN picture_url,
DROP COLUMN neighbourhood,
DROP COLUMN latitude,
DROP COLUMN longitude,
DROP COLUMN accommodates,
DROP COLUMN bathrooms_text,
DROP COLUMN bedrooms,
DROP COLUMN beds,
DROP COLUMN price_$,
DROP COLUMN minimum_nights,
DROP COLUMN maximum_nights,
DROP COLUMN minimum_minimum_nights,
DROP COLUMN maximum_minimum_nights,
DROP COLUMN maximum_maximum_nights,
DROP COLUMN minimum_maximum_nights,
DROP COLUMN minimum_nights_avg_ntm,
DROP COLUMN maximum_nights_avg_ntm,
DROP COLUMN has_availability,
DROP COLUMN availability_30,
DROP COLUMN availability_60,
DROP COLUMN availability_90,
DROP COLUMN availability_365,
DROP COLUMN instant_bookable;

---------------------------------SET FOREIGN KEY --------------------------------
ALTER TABLE airbnb.calendar ADD CONSTRAINT listings
FOREIGN KEY(listing_id) REFERENCES airbnb.listings(id);

ALTER TABLE airbnb.listings_amenities ADD CONSTRAINT listings
FOREIGN KEY(id) REFERENCES airbnb.listings(id);

ALTER TABLE airbnb.listings ADD CONSTRAINT host_id
FOREIGN KEY(host_id) REFERENCES airbnb.listings_host_info(host_id);

ALTER TABLE airbnb.reviews ADD CONSTRAINT listings
FOREIGN KEY(listing_id) REFERENCES airbnb.listings(id);

ALTER TABLE airbnb.listings_scrape ADD CONSTRAINT listings
FOREIGN KEY(id) REFERENCES airbnb.listings(id);

ALTER TABLE airbnb.listings_amenities ADD CONSTRAINT amenities_id
FOREIGN KEY(amenities) REFERENCES airbnb.amenities_type(id);


ALTER TABLE airbnb.listings ADD CONSTRAINT room_type
FOREIGN KEY(room_type) REFERENCES airbnb.room_type(id);

ALTER TABLE airbnb.listings ADD CONSTRAINT property_type 
FOREIGN KEY(property_type ) REFERENCES airbnb.property_type(id);

ALTER TABLE airbnb.listings_host_verify ADD CONSTRAINT verify_id
FOREIGN KEY(host_verifications) REFERENCES airbnb.listings_host_verify_by(id);

ALTER TABLE airbnb.listings_accommodation ADD CONSTRAINT listings
FOREIGN KEY(id) REFERENCES airbnb.listings(id);

ALTER TABLE airbnb.listings_review ADD CONSTRAINT listings
FOREIGN KEY(id) REFERENCES airbnb.listings(id);


-------------------------CREATE INDEX---------------------------------
--only create index for common used table-----------------------------
CREATE INDEX room_type_idx ON airbnb.listings USING btree (room_type);
CREATE INDEX property_type_idx ON airbnb.listings USING btree (property_type);
CREATE INDEX id_idx ON airbnb.listings USING btree (id);
CREATE INDEX neighbourhood_cleansed_idx ON airbnb.listings USING GIN (neighbourhood_cleansed);

CREATE INDEX property_type_id ON airbnb.property_type USING btree (id);
CREATE INDEX room_type_id ON airbnb.room_type USING btree (id);

CREATE INDEX listing_id_indx ON airbnb.calendar USING btree (listing_id);
-------------------------CREATE VIEW--------------------------------------
CREATE VIEW view_sum AS 
SELECT COUNT(DISTINCT id) AS total
FROM airbnb.listings_accommodation;

CREATE VIEW view_sum_borough AS
SELECT 
neighbourhood_cleansed,
COUNT(neighbourhood_cleansed) AS total_borough
FROM airbnb.listings
GROUP BY neighbourhood_cleansed;


WITH to_remove2 AS(
SELECT COUNT(DISTINCT(id)) AS unique_id
	FROM airbnb.listings
)SELECT	
	l.neighbourhood_clenased, 
	ROUND (AVG(l.price_$),3) AS average_price, 
	ROUND (AVG(l.review_scores_rating),3) AS average_rating, 
	MAX(l.review_scores_rating) AS max_score_rating,
	MIN(l.review_scores_rating) AS min_score_rating,
	AVG(l.reviews_per_month) AS average_reviewpermonth, 
	ROUND((COUNT(*)::numeric)*100 / (SELECT unique_id FROM to_remove2),2) AS percentage_total_listing
	FROM view_sum vs ,airbnb.listings l 
	INNER JOIN 
	airbnb.listings_scrape ls ON ls.id = l.id 
	GROUP BY l.neighbourhood_cleansed
	ORDER BY percentage_total_listing DESC;
	
