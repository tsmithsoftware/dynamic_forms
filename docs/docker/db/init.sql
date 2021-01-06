-- creating tables

CREATE TABLE countries(
	countryId SERIAL PRIMARY KEY NOT NULL,
	countryName VARCHAR(255) NOT NULL
);
INSERT INTO countries (countryName) VALUES ('UK'), ('Australia');

-- used for if company not already listed
CREATE TABLE whenLoaded (
	whenLoadedId SERIAL PRIMARY KEY NOT NULL,
	whenLoadedValue VARCHAR(50) NOT NULL
);

INSERT INTO whenLoaded (whenLoadedValue) VALUES ('INITIAL_LISTING'), ('CUSTOMER_ADDED');

-- set up companies listing
CREATE TABLE companies(
	companyId SERIAL PRIMARY KEY NOT NULL,
	companyName VARCHAR(50) NOT NULL,
	whenLoadedId INT NOT NULL,
		FOREIGN KEY (whenLoadedId)
		REFERENCES whenLoaded(whenLoadedId)
);
INSERT INTO companies(companyname, whenLoadedId) VALUES ('McDonals', 1),('Banter King',1),('Nake',1), ('Himbala',1),('ZZ Slot',1),('Koompani',1);

CREATE TABLE visitors(
    visitorId SERIAL PRIMARY KEY NOT NULL,
    visitorName VARCHAR(50) NOT NULL,
    companyId INT NOT NULL,
  	FOREIGN KEY (companyId)
        REFERENCES companies(companyId)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    imageLink VARCHAR(255),
    createdDateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lastUpdatedDateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sites(
    id SERIAL PRIMARY KEY NOT NULL,
    siteId INT NOT NULL,
    countryId INT NOT NULL,
  		FOREIGN KEY (countryId)
		REFERENCES countries(countryId),
    siteName VARCHAR(255) NOT NULL,
    town VARCHAR(255),
    createdDateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lastUpdatedDateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);

CREATE TABLE vehicles(
    vehicleId SERIAL PRIMARY KEY NOT NULL,
    vehicleReg VARCHAR(20),
    createdDateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lastUpdatedDateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);

CREATE TABLE inductionChecksPage(
          checksPageId SERIAL PRIMARY KEY NOT NULL,
		  countryId INT NOT NULL,
    FOREIGN KEY (countryId)
        REFERENCES countries(countryId)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
          );

CREATE TABLE segments(
          segmentId SERIAL PRIMARY KEY NOT NULL,
          segmentTitle VARCHAR(255),
		  checksPageId INT NOT NULL,
			FOREIGN KEY (checksPageId)
			REFERENCES inductionChecksPage(checksPageId)
			ON UPDATE CASCADE
			ON DELETE NO ACTION
          );

CREATE TYPE checksType AS ENUM ('yesNo', 'string');

CREATE TABLE checks(
          checksId SERIAL PRIMARY KEY NOT NULL,
          checksText VARCHAR(255),
          checksSubText VARCHAR(255),
          checksType checksType,
          checksRequired BOOLEAN NOT NULL,
          imageLink VARCHAR(255),
		  segmentId INT,
			FOREIGN KEY (segmentId)
			REFERENCES segments(segmentId)
			ON UPDATE CASCADE
			ON DELETE NO ACTION
          );

ALTER TABLE checks
ALTER COLUMN checksRequired
SET DEFAULT FALSE;

CREATE TABLE passes(
	passId SERIAL PRIMARY KEY NOT NULL,
	visitorId INT NOT NULL,
    FOREIGN KEY (visitorId)
        REFERENCES visitors(visitorId)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    createdDateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lastUpdatedDateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- visits table
CREATE TABLE visits(
	visitId SERIAL PRIMARY KEY NOT NULL,
	visitorId INT NOT NULL,
		FOREIGN KEY (visitorId)
		REFERENCES visitors(visitorId),
	passId INT NOT NULL,
		FOREIGN KEY (passId)
        REFERENCES passes(passId),
	siteId INT NOT NULL,
		FOREIGN KEY (siteId)
		REFERENCES sites(id),
	createdDateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lastUpdatedDateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- associate checks and visits
CREATE TABLE signInChecks(
	signInCheckId SERIAL PRIMARY KEY NOT NULL,
	visitId INT NOT NULL,
		FOREIGN KEY (visitId)
		REFERENCES visits(visitId),
	checksId INT NOT NULL,
		FOREIGN KEY (checksId)
		REFERENCES checks(checksId),
	status BOOLEAN,
	lastUpdatedDateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- insert sample data
-- countries
INSERT INTO countries (countryName) VALUES ('UK'), ('AU'), ('NZ');
--sites
INSERT INTO sites (siteId, siteName,town, countryId)
VALUES(14501, 'Abington Avenue SF Connect', 'NORTHAMPTON', 1),
(14460, 'Acle SF Connect', 'NORWICH', 1),
(10102, 'Addington SF Connect', 'SOUTH CROYDON',  1),
(15276, 'Adel SF Connect', 'LEEDS',  1),
(15284, 'Airport City SF Connect', 'MANCHESTER',  1),
(10466,'Bagshot SF Connect', 'BAGSHOT',  1),
(14382, 'Bankhead SF Connect', 'GLENROTHES',  1),
(14977, 'Barnwood SF Connect', 'GLOUCESTER',  1),
(10569, 'Bradwell Abbey SF Connect', 'MILTON KEYNES',  1),
(13517, 'Buckingham SF Connect', 'BUCKINGHAM',  1),
(10057, 'Cambridge Road SF Connect', 'CARSHALTON',  1),
(12923, 'Cranford SF Connect', 'HOUNSLOW',   1),
(10472, 'Crownwood SF Connect', 'LONDON',  1),
(13262, 'Emerson Valley SF Connect', 'MILTON KEYNES',  1),
(13943, 'Farnham SF Connect', 'FARNHAM', 1),
(10101, 'Findon Valley SF Connect','WORTHING',  1),
(10516, 'Finchley Lane SF Connect', 'UXBRIDGE',  1),
(13267, 'Flying Red Horse SF Connect','WORTHING', 1),
(13268, 'Flyover SF Connect', 'HAMMERSMITH',  1),
(10463, 'Hampton Court SF Connect','EAST MOLESEY',  1),
(10441, 'Kellys Corner SF Connect','LONDON',  1),
(12956, 'Kempton Park SF Connect','SUNBURY on THAMES',  1),
(12945, 'Newham Way Connect','BARNET',  1),
(10428, 'Odeon SF Connect','BARNET', 1),
(10514, 'Pinkham Way SF Connect', 'LONDON',  1),
(12916, 'Ravenscroft SF Connect', 'HOUNSLOW',  1),
(10070, 'Shirley SF Connect', 'CROYDON',  1),
(14827, 'Thame BP SF Connect', 'THAME',  1),
(12917, 'Wandsworth SF Connect', 'LONDON',  1),
(10571, 'Wavendon Gate SF Connect', 'MILTON KEYNES',  1),
(10195, 'Wilmslow SF Connect','WILMSLOW',  1),
(13010, 'Woodstock SF Connect','OXFORD',  1),
(10044, 'Wrythe SF Connect', 'CARSHALTON',  1),
(33333, 'AU Site One', 'MELBOURNE',  2),
(44444, 'AU Site Two', 'BRISBANE',  3),
(11111, 'NZ Site One', 'AUCKLAND',  3),
(22222, 'NZ Site Two', 'CHRISTCHURCH',  3)
;

-- inductionChecksPage
INSERT INTO inductionChecksPage(countryId)
VALUES (1), (2), (3);

--segment
INSERT INTO segments(segmentTitle, checksPageId)
values 
('General Checks', 1),
('Specific Checks', 1),
('Gen AU Checks', 2),
('Specific AU Checks', 2),
('Work Area', 3),
('Golden Rules Activities', 3),
('All Work Activities', 3),
('Food Safety Requirements', 3),
('Personal Controls - tick relevant box for PPE to be worn', 3),
('Additional Work Area Controls', 3)
;

--checks
INSERT INTO checks(checksText, checksSubText, checksType, checksRequired, imageLink, segmentId) VALUES (
'Are you going to work on anything else?',
	'',
	'yesNo',
	false,
	'',
	1
),(
  'Are you going to work on any live electrical, stored energy/pressure system, or the electrical switchboard?',
  	'If yes, how will you isolation and lock-out the system to make it safe to work on. What extra precautions will you take?',
  	'yesNo',
  	false,
  	'',
	1
  ),
  (
  	'Could your work on site obstruct any access or egress in an emergency?',
  	'If yes, consider alternatives. This includes extinguishers, evacuation routes, assembly area, spill kit. ',
  	'yesNo',
  	false,
  	'',
	2
  ),
  (
  	'Is the contractor appropriately dressed, as per the image below?',
  	'If yes, consider alternatives. This includes extinguishers, evacuation routes, assembly area, spill kit. ',
  	'yesNo',
  	false,'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fae01.alicdn.com%2Fkf%2FHTB1QM7zQXXXXXXFaFXXq6xXFXXXn%2FMotorcycle-protective-gear-ski-protection-back-Armor-protection-spine-extreme-sports-protective-gear.jpg&f=1&nofb=1',
	2
  ),
  (
  'Ignition Sources',
  'No smoking or naked flames on site \n No mobile phones or electronic equipment to be used anywhere on site (except for inside the store) \n All maintenance work to be conducted in accordance with sage ways of working and correct PPE worn at all times.',
  'yesNo',
  true,
  '',
  3
  ),
  (
  'Asbestos',
  'Ensure Asbestos Register for the store has been sighted and any works adjusted accordingly.',
  'yesNo',
  false,
  '',
  3
  ),
  (
  'Contractors',
  'No Hot Work in hazardous zones to be completed without a written permit',
  'yesNo',
  false,
  '',
  3
  ),
    (
  'Emergency Procedures',
  'In the event of an emergency follow direction of BP site staff',
  'yesNo',
  false,
  '',
  3
  ),
    (
  'Incidents / Hazards',
  'Report all incidents and hazards to a BP site staff member',
  'yesNo',
  false,
  '',
  3
  ),
  (
	'Shop/Store',
	'',
	'yesNo',
	false,
	'',
	5
  ),
    (
	'Fuel Hazardous Area(s)',
	'',
	'yesNo',
	false,
	'',
	5
  ),
    (
	'Food Handling Area',
	'Kitchen, Freezer, Chiller',
	'yesNo',
	false,
	'',
	5
  ),
  (
	'Electrical Switchboard',
	'Includes work within 0.5m',
	'yesNo',
	false,
	'',
	5
  ),
  (
	'External Grounds',
	'',
	'yesNo',
	false,
	'',
	5
  ),
  (
	'Carwash',
	'',
	'yesNo',
	false,
	'',
	5
  ),
  (
  'Are you going to work on any live electrical, stored energy/pressure system, or the electrical switchboard?',
  	'If yes, how will you isolation and lock-out the system to make it safe to work on. What extra precautions will you take?',
  	'yesNo',
  	false,
  	'',
	6
  ),
    (
  'Will your work involve any ground disturbances?',
  	'If yes, a BP Permit is required. This includes concrete cutting of the forecourt at a depth of 100mm or greater. Check for services prior to start.',
  	'yesNo',
  	false,
  	'',
	6
  ),
    (
  'Is your work are within a confined space?',
  	'If yes, a BP Permit is required. This includes tanks, pits, open top tanks equal to or deeper than 1.2m, excavations equal to or deeper than 1.2m, manholes, and enclosed drains.',
  	'yesNo',
  	false,
  	'',
	6
  ),
      (
  'Can your work involve you being at a height where you could fall 2m (6 feet) or more?',
  	'If yes, use fall restraint. This can include a mobile scaffold, elevated work platforms (diesel only), harness system, edge protections, etc.',
  	'yesNo',
  	false,
  	'',
	6
  ),
  (
  'Do you plan to use a crane or heavy lifting device?',
  	'If yes, a BP Permit is required. Do you have a lift plan or agreed lift procedure?',
  	'yesNo',
  	false,
  	'',
	6
  ),
    (
  'Will your work involve being within the sites Hazardous Area Zone (view the site plan to identify)?',
  	'If yes, a BP Permit is required, if your work involves grinding and cutting, battery tools, potential ignition source.',
  	'yesNo',
  	false,
  	'',
	6
  ),
  (
  	'Could your work on site obstruct any access or egress in an emergency?',
  	'If yes, consider alternatives. This includes extinguishers, evacuation routes, assembly area, spill kit. ',
  	'yesNo',
  	false,
  	'',
	7
  ),
    (
  	'Is your work going to impact the public, our staff, or other contractors around site?',
  	'If yes, what cones, barriers and signs do you need to warn everyone? Discuss your work and hazards with them, understand theirs too. ',
  	'yesNo',
  	false,
  	'',
	7
  ),
      (
  	'Does the contractor need access to the sites restricted areas, e.g. Office, IT&S systems',
  	'If yes, photo indentification to be recorded in the identification section and a work order, email, communication has been received explaining work. ',
  	'yesNo',
  	false,
  	'',
	7
  ),
      (
  	'Will you be carrying out work within any food handling area (e.g. Kitchen, Freezer, and Chiller?)',
  	'If yes, Contractor must not have been sick within the last 48 hours. Ensure additional controls to prevent food contamination are listed below?',
  	'yesNo',
  	false,
  	'',
	8
  ),
  (
  	'Do your activities have the potential to affect food safety / suitability?',
  	'If yes, remove or cover food contact surfaces. Tools should be cleaned before use. Hand hygiene to be followed at all times.',
  	'yesNo',
  	false,
  	'',
	8
  ),
    (
  	'Hardhat',
  	'',
  	'yesNo',
  	false,
  	'',
	9
  ),
      (
  	'Eye Protection',
  	'',
  	'yesNo',
  	false,
  	'',
	9
  ),
      (
  	'Ear Protection',
  	'',
  	'yesNo',
  	false,
  	'',
	9
  ),
      (
  	'Neck-to-toe clothing',
  	'',
  	'yesNo',
  	false,
  	'',
	9
  ),
      (
  	'Hi-Viz Vest',
  	'',
  	'yesNo',
  	false,
  	'',
	9
  ),
      (
  	'Safety Boots',
  	'',
  	'yesNo',
  	false,
  	'',
	9
  ),
      (
  	'Gloves',
  	'',
  	'yesNo',
  	false,
  	'',
	9
  ),
      (
  	'Food Safety Clothing',
  	'',
  	'yesNo',
  	false,
  	'',
	9
  ),
      (
  	'Food Grade/non-allergenic lubricant',
  	'',
  	'yesNo',
  	false,
  	'',
	9
  ),
  (
  	'Other(note in Additional Work Area Controls)',
  	'',
  	'yesNo',
  	false,
  	'',
	9
  ),
    (
  	'Additional Work Area Controls',
  	'',
  	'string',
  	false,
  	'',
	9
  )
  ;
  
insert into visitors (visitorName,companyId) values ('bob', 1);
insert into passes (visitorId) values (1);
insert into visits(visitorId, passId, siteId) values (1,1,1);
insert into signInChecks (visitId, checksId, status) values (1, 1, TRUE);
insert into signInChecks (visitId, checksId, status) values (1, 2, FALSE);
insert into signInChecks (visitId, checksId, status) values (1, 3, FALSE);

insert into visitors (visitorName,companyId) values ('john', 1);
insert into passes (visitorId) values (2);
insert into visits(visitorId, passId, siteId) values (2,2,1);
insert into signInChecks (visitId, checksId, status) values (2, 1, FALSE);
insert into signInChecks (visitId, checksId, status) values (2, 4, TRUE);
insert into signInChecks (visitId, checksId, status) values (2, 5, FALSE);

-- select all checks for a visit
/**
select visits.visitid, visitors.visitorname, sites.siteName, visits.createdDateTime, checks.checksText, signInChecks.status from
visitors inner join passes on visitors.visitorId = passes.visitorId
inner join visits on passes.passId = visits.passId
inner join sites on visits.siteId = sites.id
inner join signInChecks on visits.visitId = signInChecks.visitId
inner join checks on checks.checksId = signInChecks.checksId;
**/

-- return how many checks were true/false per visit
/**
select visits.visitid, signInChecks.status, count(signInChecks.status)
from visits
inner join signInChecks on visits.visitId = signInChecks.visitId
where signInChecks.status = false
group by visits.visitid, signInChecks.status
;

-- select count of how many checks were false or true per visit
select visits.visitid, visitors.visitorName, sites.siteName, signInChecks.status, count(signInChecks.status) from
visitors inner join passes on visitors.visitorId = passes.visitorId
inner join visits on passes.passId = visits.passId
inner join sites on visits.siteId = sites.id
inner join signInChecks on visits.visitId = signInChecks.visitId
group by visits.visitid, signInChecks.status, visitors.visitorName, sites.siteName
order by visitid asc
;
**/