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

CREATE TABLE CIModules (
	CIModuleId SERIAL PRIMARY KEY,
	provider VARCHAR(50),
	encoding VARCHAR
);

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

CREATE TABLE RemoteControllers (
	remoteControllerId SERIAL PRIMARY KEY,
	smart BOOLEAN,
	batteryType varchar(50),
	productId INT,
	FOREIGN KEY (productId) REFERENCES Products (productId),
	televisionId INT UNIQUE, -- Ensures one-to-one relationshop
	FOREIGN KEY (televisionId) REFERENCES Televisions (televisionId)
);

CREATE TABLE AttachtmentMethods (
	attachtmentMethodid SERIAL PRIMARY KEY,
	name VARCHAR(20),
	description TEXT,
	productId INT,
	FOREIGN KEY (productId) REFERENCES Products (productId)
);

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

CREATE TABLE Television_WallBracket (
	PRIMARY KEY (televisionId, wallBracketId),
	televisionId INT,
	FOREIGN KEY (televisionId) REFERENCES Televisions (televisionId),
	wallBracketId INT,
	FOREIGN KEY (wallBracketId) REFERENCES WallBrackets (wallBracketId)
);







