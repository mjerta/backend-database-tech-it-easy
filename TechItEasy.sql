DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Television_WallBracket;
DROP TABLE IF EXISTS WallBrackets;
DROP TABLE IF EXISTS RemoteControllers;
DROP TABLE IF EXISTS Televisions;
DROP TABLE IF EXISTS CIModules;
DROP TABLE IF EXISTS attachtmentMethods;
DROP TABLE IF EXISTS Products;

CREATE TABLE Users (
	userId SERIAL PRIMARY KEY,
	userName VARCHAR(20),
	passWord VARCHAR(20),
	address VARCHAR,
	function VARCHAR(30),
	payRate INT,
	vacationDays INT
);

INSERT INTO Users (userName, passWord, address, function, payRate, vacationDays)
VALUES 
('john_doe', 'password123', '123 Elm St, Springfield', 'Manager', 80000, 20),
('jane_smith', 'password456', '456 Oak St, Springfield', 'Sales Associate', 50000, 15),
('alice_jones', 'password789', '789 Pine St, Springfield', 'Technician', 60000, 10);


CREATE TABLE Products (
	productId SERIAL PRIMARY KEY,
	name VARCHAR(30),
	brand VARCHAR(15),
	price DECIMAL,
	currentStock INT,
	sold INT,
	dateSold DATE,
	type VARCHAR(10)
);

INSERT INTO Products (name, brand, price, currentStock, sold, dateSold, type)
VALUES
('Samsung QLED', 'Samsung', 1200.99, 10, 5, '2024-07-10', 'Television'),
('LG OLED', 'LG', 1500.49, 8, 2, '2024-07-11', 'Television'),
('Sony Bravia', 'Sony', 1300.75, 12, 4, '2024-07-12', 'Television'),
('Roku Remote', 'Roku', 29.99, 50, 25, '2024-07-05', 'Remote'),
('Wall Mount', 'Mount-It!', 89.99, 20, 10, '2024-07-06', 'Bracket');

CREATE TABLE CIModules (
	CIModuleId SERIAL PRIMARY KEY,
	provider VARCHAR(50),
	encoding VARCHAR
);

INSERT INTO CIModules (provider, encoding)
VALUES
('Ziggo', 'MPEG-4'),
('KPN', 'H.264'),
('Odido', 'HEVC');


CREATE TABLE Televisions (
	televisionId SERIAL PRIMARY KEY,
	height DECIMAL,
	width DECIMAL,
	screenQuality VARCHAR,
	wifi BOOLEAN,
	smartTV BOOLEAN,
	voiceControle BOOLEAN,
	HDR BOOLEAN,
	productId INT,
	FOREIGN KEY (productId) REFERENCES Products (productId),
	CIModuleId INT,
	FOREIGN KEY (CIModuleId) REFERENCES CIModules (CIModuleId)
);

INSERT INTO Televisions (height, width, screenQuality, wifi, smartTV, voiceControle, HDR, productId, CIModuleId)
VALUES
(50.5, 89.5, '4K', TRUE, TRUE, TRUE, TRUE, 1, 1),
(55.0, 95.0, '4K', TRUE, TRUE, TRUE, TRUE, 2, 1),
(60.0, 100.0, '8K', TRUE, TRUE, TRUE, TRUE, 3, 3);

CREATE TABLE RemoteControllers (
	remoteControllerId SERIAL PRIMARY KEY,
	smart BOOLEAN,
	batteryType varchar(50),
	productId INT,
	FOREIGN KEY (productId) REFERENCES Products (productId),
	televisionId INT UNIQUE, -- Ensures one-to-one relationshop
	FOREIGN KEY (televisionId) REFERENCES Televisions (televisionId)
);

INSERT INTO RemoteControllers (smart, batteryType, productId, televisionId)
VALUES
(TRUE, 'AAA', 4, 1),
(TRUE, 'AA', 4, 2),
(FALSE, 'AAA', 4, 3);


CREATE TABLE AttachtmentMethods (
	attachtmentMethodid SERIAL PRIMARY KEY,
	name VARCHAR(20),
	description TEXT,
	productId INT,
	FOREIGN KEY (productId) REFERENCES Products (productId)
);

INSERT INTO AttachtmentMethods (name, description, productId)
VALUES
('Wall Mount', 'Mounts to the wall', 5),
('Rail Mount', 'Mounts to a rail system', 5),
('Ceiling Mount', 'Hangs from the ceiling', 5),
('Stand Mount', 'Free-standing mount', 5);

CREATE TABLE WallBrackets (
	wallBracketId SERIAL PRIMARY KEY,
	height DECIMAL,
	width DECIMAL,
	adjustable BOOLEAN,
	attachtmentMethodId INT,
	FOREIGN KEY (attachtmentMethodId) REFERENCES AttachtmentMethods (attachtmentMethodId),
	productId INT,
	FOREIGN KEY (productId) REFERENCES Products (productId)	
);

INSERT INTO WallBrackets (height, width, adjustable, attachtmentMethodId, productId)
VALUES
(50.0, 70.0, TRUE, 1, 5),
(45.0, 65.0, FALSE, 2, 5),
(55.0, 75.0, TRUE, 3, 5),
(40.0, 60.0, FALSE, 4, 5);

CREATE TABLE Television_WallBracket (
	PRIMARY KEY (televisionId, wallBracketId),
	televisionId INT,
	FOREIGN KEY (televisionId) REFERENCES Televisions (televisionId),
	wallBracketId INT,
	FOREIGN KEY (wallBracketId) REFERENCES WallBrackets (wallBracketId)
);


INSERT INTO Television_WallBracket (televisionId, wallBracketId)
VALUES
(1, 1),
(2, 2),
(3, 3);

-- Just a overal overview
SELECT 
    p.*,
    tv.*,
    cm.*,
    rc.*,
    wb.*,
    am.*,
    twb.*
FROM Products p
LEFT JOIN Televisions tv ON p.productId = tv.productId
LEFT JOIN CIModules cm ON tv.CIModuleId = cm.CIModuleId
LEFT JOIN RemoteControllers rc ON p.productId = rc.productId
LEFT JOIN WallBrackets wb ON p.productId = wb.productId
LEFT JOIN AttachtmentMethods am ON wb.attachtmentMethodId = am.attachtmentMethodId
LEFT JOIN Television_WallBracket twb ON tv.televisionId = twb.televisionId;

-- One on One relationshop between Televisions and RemoteController
SELECT 
    tv.televisionId,
    tv.height AS televisionHeight,
    tv.width AS televisionWidth,
    tv.screenQuality,
    tv.wifi,
    tv.smartTV,
    tv.voiceControle,
    tv.HDR,
    rc.remoteControllerId,
    rc.smart AS remoteSmart,
    rc.batteryType
FROM Televisions tv
JOIN RemoteControllers rc ON tv.televisionId = rc.televisionId;

-- One to many relationship of Televisions and CIModules
SELECT 
    tv.televisionId,
    tv.height AS televisionHeight,
    tv.width AS televisionWidth,
    tv.screenQuality,
    tv.wifi,
    tv.smartTV,
    tv.voiceControle,
    tv.HDR,
    cm.CIModuleId,
    cm.provider AS CIModuleProvider,
    cm.encoding AS CIModuleEncoding
FROM Televisions tv
LEFT JOIN CIModules cm ON tv.CIModuleId = cm.CIModuleId;



-- The many to many relations between televisions and the wall mounts
SELECT 
    tv.televisionId,
    tv.height AS televisionHeight,
    tv.width AS televisionWidth,
    tv.screenQuality,
    tv.wifi,
    tv.smartTV,
    tv.voiceControle,
    tv.HDR,
    wb.wallBracketId,
    wb.height AS wallBracketHeight,
    wb.width AS wallBracketWidth,
    wb.adjustable
FROM Television_WallBracket twb
LEFT JOIN Televisions tv ON twb.televisionId = tv.televisionId
LEFT JOIN WallBrackets wb ON twb.wallBracketId = wb.wallBracketId;



