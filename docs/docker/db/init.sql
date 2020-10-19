-- creating tables

CREATE TABLE visitors(
    visitorId SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(50) NOT NULL,
    company VARCHAR(50) NOT NULL,
    imageLink VARCHAR(255),
    createdDateTime timestamp DEFAULT CURRENT_TIMESTAMP,
    lastUpdatedDateTime timestamp DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE countries(
    countryId SERIAL PRIMARY KEY NOT NULL,
    countryName VARCHAR(20)
    );

CREATE TABLE vehicles(
    vehicleId SERIAL PRIMARY KEY NOT NULL,
    vehicleReg VARCHAR(20),
    createdDateTime timestamp DEFAULT CURRENT_TIMESTAMP,
    lastUpdatedDateTime timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE checksPage(
          checksPageId SERIAL PRIMARY KEY NOT NULL
          );

CREATE TABLE segments(
          segmentId SERIAL PRIMARY KEY NOT NULL,
          segmentTitle VARCHAR(255)
          );

CREATE TABLE checks(
          checksId SERIAL PRIMARY KEY NOT NULL,
          checksText VARCHAR(255),
          checksSubText VARCHAR(255),
          checksType VARCHAR(255),
          checksRequired BOOLEAN NOT NULL,
          imageLink VARCHAR(255)
          );

ALTER TABLE checks
ALTER COLUMN checksRequired
SET DEFAULT FALSE;

CREATE TABLE sites(
    id SERIAL PRIMARY KEY NOT NULL,
    siteId VARCHAR(10) NOT NULL,
    sapId VARCHAR(10) UNIQUE,
    countryId INT,
    FOREIGN KEY (countryId)
        REFERENCES countries(countryId)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    siteName VARCHAR(255) NOT NULL,
    town VARCHAR(255),
    channelOfTrade VARCHAR(10),
    installationCount INT DEFAULT 1,
    createdDateTime timestamp DEFAULT CURRENT_TIMESTAMP,
    lastUpdatedDateTime timestamp DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE countryChecks(
    countryChecksId SERIAL PRIMARY KEY NOT NULL,
    countryId INT,
        FOREIGN KEY (countryId)
            REFERENCES countries(countryId)
            ON UPDATE CASCADE
            ON DELETE NO ACTION,
    checksPageId INT,
        FOREIGN KEY (checksPageId)
            REFERENCES checksPage(checksPageId)
    );

CREATE TABLE checksPageSegment(
    checksPageSegmentId SERIAL PRIMARY KEY NOT NULL,
    segmentId INT,
            FOREIGN KEY (segmentId)
                REFERENCES segments(segmentId)
                ON UPDATE CASCADE
                ON DELETE NO ACTION
    );

CREATE TABLE segmentChecks(
    segmentChecksId SERIAL PRIMARY KEY NOT NULL,
    checksId INT,
                FOREIGN KEY (checksId)
                    REFERENCES checks(checksId)
                    ON UPDATE CASCADE
                    ON DELETE NO ACTION,
    segmentId INT,
            FOREIGN KEY (segmentId)
                REFERENCES segments(segmentId)
                ON UPDATE CASCADE
                ON DELETE NO ACTION
    );

CREATE TABLE visits(
    visitId SERIAL PRIMARY KEY NOT NULL,
    visitorId INT,
    FOREIGN KEY (visitorId)
        REFERENCES visitors(visitorId)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    siteId int NOT NULL,
    FOREIGN KEY (siteId)
        REFERENCES sites(id)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

-- insert sample data
-- countries
INSERT INTO countries (countryName) VALUES ('UK');
--sites
INSERT INTO sites (siteId, siteName,town, sapId, countryId)
VALUES(14501, 'Abington Avenue SF Connect', 'NORTHAMPTON', 'C0GR', 1),
(14460, 'Acle SF Connect', 'NORWICH', 'C0MV', 1),
(10102, 'Addington SF Connect', 'SOUTH CROYDON', 'C0FA', 1),
(15276, 'Adel SF Connect', 'LEEDS', 'C0PP', 1),
(15284, 'Airport City SF Connect', 'MANCHESTER', 'C0QC', 1),
(10466,'Bagshot SF Connect', 'BAGSHOT', 'C0FC', 1),
(14382, 'Bankhead SF Connect', 'GLENROTHES', 'C0EX', 1),
(14977, 'Barnwood SF Connect', 'GLOUCESTER', 'C0MA', 1),
(10569, 'Bradwell Abbey SF Connect', 'MILTON KEYNES', 'C0E0', 1),
(13517, 'Buckingham SF Connect', 'BUCKINGHAM', 'C0AP', 1),
(10057, 'Cambridge Road SF Connect', 'CARSHALTON', 'C0DF', 1),
(12923, 'Cranford SF Connect', 'HOUNSLOW', 'C0FH',  1),
(10472, 'Crownwood SF Connect', 'LONDON', 'C0JS', 1),
(13262, 'Emerson Valley SF Connect', 'MILTON KEYNES', 'C06N', 1),
(13943, 'Farnham SF Connect', 'FARNHAM', 'C0D5', 1),
(10101, 'Findon Valley SF Connect','WORTHING', 'C0EH', 1),
(10516, 'Finchley Lane SF Connect', 'UXBRIDGE', 'C0FJ', 1),
(13267, 'Flying Red Horse SF Connect','WORTHING', 'C0MK', 1),
(13268, 'Flyover SF Connect', 'HAMMERSMITH', 'C0B2', 1),
(10463, 'Hampton Court SF Connect','EAST MOLESEY', 'C04T', 1),
(10441, 'Kellys Corner SF Connect','LONDON', 'C057', 1),
(12956, 'Kempton Park SF Connect','SUNBURY on THAMES', 'C0DE', 1),
(12945, 'Newham Way Connect','BARNET', 'C074', 1),
(10428, 'Odeon SF Connect','BARNET', 'C04W', 1),
(10514, 'Pinkham Way SF Connect', 'LONDON', 'C0CU', 1),
(12916, 'Ravenscroft SF Connect', 'HOUNSLOW', 'C06E', 1),
(10070, 'Shirley SF Connect', 'CROYDON', 'C0CY', 1),
(14827, 'Thame BP SF Connect', 'THAME', 'C0K2', 1),
(12917, 'Wandsworth SF Connect', 'LONDON', 'C0BX', 1),
(10571, 'Wavendon Gate SF Connect', 'MILTON KEYNES', 'C0BL', 1),
(10195, 'Wilmslow SF Connect','WILMSLOW', 'C0MT', 1),
(13010, 'Woodstock SF Connect','OXFORD', 'C0CP', 1),
(10044, 'Wrythe SF Connect', 'CARSHALTON', 'C0E9', 1);
--checks
INSERT INTO checks(checksText, checksSubText, checksType, checksRequired, imageLink) VALUES (
'Are you going to work on any live electrical, stored energy/pressure system, or the electrical switchboard?',
	'',
	'yesNo',
	false,
	''
),(
  'Are you going to work on any live electrical, stored energy/pressure system, or the electrical switchboard?',
  	'If yes, how will you isolation and lock-out the system to make it safe to work on. What extra precautions will you take?',
  	'yesNo',
  	false,
  	''
  ),
  (
  	'Could your work on site obstruct any access or egress in an emergency?',
  	'If yes, consider alternatives. This includes extinguishers, evacuation routes, assembly area, spill kit. ',
  	'yesNo',
  	false,
  	''
  ),
  (
  	'Is the contractor appropriately dressed, as per the image below?',
  	'If yes, consider alternatives. This includes extinguishers, evacuation routes, assembly area, spill kit. ',
  	'yesNo',
  	false,
  	'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fae01.alicdn.com%2Fkf%2FHTB1QM7zQXXXXXXFaFXXq6xXFXXXn%2FMotorcycle-protective-gear-ski-protection-back-Armor-protection-spine-extreme-sports-protective-gear.jpg&f=1&nofb=1'
  )
  ;

-- checksPage
INSERT INTO checksPage VALUES (1);

-- countryChecks
INSERT INTO countryChecks (countryId, checksPageId) VALUES (1,1);

-- segments
INSERT INTO segments (segmentTitle) VALUES ('Golden Rule Activities '), ('All Work Activities');

--checksPageSegment
INSERT INTO checksPageSegment(segmentId) VALUES(1);

-- associate segments and checks
INSERT INTO segmentChecks(checksId, segmentId) VALUES
(1,1),
(2,2),
(3,2);

