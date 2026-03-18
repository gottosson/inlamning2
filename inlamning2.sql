/*
Min lilla bokhandel
*/

CREATE DATABASE Bokhandel; -- skapar databasen
USE Bokhandel;

-- skapa kundtabellen
CREATE TABLE Kunder (
	KundID INT AUTO_INCREMENT PRIMARY KEY,
    Namn VARCHAR(100) NOT NULL, -- det måste finnas någonting, får inte vara tomt
	Email VARCHAR(255) UNIQUE NOT NULL,
    Telefon VARCHAR(100) UNIQUE NOT NULL,
    Adress VARCHAR(255) NOT NULL
    );
    
-- skapa produkttabellen
CREATE TABLE Produkter (
	ISBN VARCHAR(15) PRIMARY KEY,
    Titel VARCHAR(100) NOT NULL,
    Författare VARCHAR(100) NOT NULL,
    Pris DECIMAL(10,2) NOT NULL CHECK(Pris > 0), -- constraint att priset alltid är över 0
    Lagerstatus INT DEFAULT 0 -- det kommer default att stå 0 istället för tomt
    );
    
-- skapa beställningar-tabellen
CREATE TABLE Bestallningar (
	Ordernummer INT AUTO_INCREMENT PRIMARY KEY,
    KundID INT NOT NULL,
    Datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Totalbelopp DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (KundID) REFERENCES Kunder(KundID) -- vi lånar KundID PK från Kunder-tabellen
    );
    
-- skapa orderrader-tabellen
CREATE TABLE Orderrader (
	OrderradID INT AUTO_INCREMENT PRIMARY KEY,
    Ordernummer INT NOT NULL,
    ISBN VARCHAR(15) NOT NULL,
    Antal INT NOT NULL CHECK (Antal > 0),
    Pris DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Ordernummer) REFERENCES Bestallningar(Ordernummer),
    FOREIGN KEY (ISBN) REFERENCES Produkter(ISBN)
    );

-- nu infogar vi lite data i de olika tabellerna
INSERT INTO Kunder (Namn, Email, Telefon, Adress) VALUES
('Anna Lindberg', 'anna.lindberg@email.com', '+46701234567', 'Storgatan 12, 12345 Stockholm'),
('Johan Svensson', 'johan.svensson@email.com', '+46707654321', 'Lillvägen 7, 54321 Göteborg'),
('Maria Ekström', 'maria.ekstrom@email.com', '+46701122334', 'Björkvägen 2, 12233 Malmö'),
('Erik Holm', 'erik.holm@email.com', '+46704545456', 'Tallgatan 9, 56151 Huskvarna'),
('Sara Nilsson', 'sara.nilsson@email.com', '+46709988771', 'Ängsvägen 5, 38690 Kalmar');

INSERT INTO Produkter (ISBN, Titel, Författare, Pris, Lagerstatus) VALUES
('9789113100364', 'Vitön', 'Bea Uusma', '349', '25'),
('9789177754664', 'Tvättbjörnarnas stad', 'Fabian Göransson', '189', '15'),
('9789100199906', 'Den yttersta hemligheten', 'Dan Brown', '249', '50'),
('9789100808266', 'Artens överlevnad', 'Lydia Sandgren', '269', '19'),
('9789189928114', 'Klanen', 'Pascal Engman', '249', '27');

INSERT INTO Bestallningar (KundID, Totalbelopp) VALUES
('3', '349'),
('3', '618'),
('1', '189'),
('3', '538'),
('5', '249'),
('2', '518');

INSERT INTO Orderrader (Ordernummer, ISBN, Antal, Pris) VALUES
('1', '9789177754664', '1', '189'),
('1', '9789113100364', '1', '349'),
('2', '9789100199906', '1', '249'),
('3', '9789100808266', '1', '269'),
('3', '9789189928114', '1', '249'),
('4', '9789113100364', '1', '349'),
('4', '9789100808266', '1', '269'),
('5', '9789177754664', '1', '189'),
('6', '9789113100364', '1', '349');

SELECT * FROM Orderrader;

-- visa alla kunder
SELECT * FROM Kunder;

-- visa alla beställningar
SELECT * FROM Bestallningar;

-- hämta data från Kunder-tabellen
SELECT Namn, Email FROM Kunder;

SELECT * FROM Kunder WHERE Namn = 'Sara Nilsson';

SELECT * FROM Kunder WHERE Email = 'maria.ekstrom@email.com';

-- filtrera data i Produkter-tabellen
SELECT * FROM Produkter WHERE Pris > 200; -- priset är över 200kronor

-- sortera data i Produkter-tabellen
SELECT * FROM Produkter ORDER BY Pris ASC; -- lägsta till högsta pris

-- test för att uppdatera kunds e-post
START TRANSACTION; -- börja en transaktion

UPDATE Kunder
SET Email = 'maria.ekstrom.ny@email.com'
WHERE KundID = 3;

SELECT * FROM Kunder WHERE KundID = 3; -- titta om ändringen är korrekt

COMMIT; -- spara ändringen permanent 

ROLLBACK; -- ångra ändringen 

-- test för att ta bort en kund 
START TRANSACTION;

-- eftersom Anna lagt en beställning måste vi gå den här vägen för att kunna ta bort henne
DELETE FROM Orderrader WHERE OrderradID = 8; 
DELETE FROM Bestallningar WHERE Ordernummer = 5;
DELETE FROM Bestallningar WHERE KundID = 1;
DELETE FROM Kunder WHERE KundID = 1;

SELECT * FROM Kunder; -- titta om Anna är borttagen

COMMIT; 

ROLLBACK;

-- visa alla kunder som gjort minst en beställning
SELECT Kunder.Namn, Bestallningar.KundID 
FROM Kunder INNER JOIN Bestallningar 
ON Kunder.KundID = Bestallningar.KundID;

-- visa alla kunder, även de som inte gjort någon beställning
SELECT Kunder.Namn, Bestallningar.Ordernummer 
FROM Kunder LEFT JOIN Bestallningar 
ON Kunder.KundID = Bestallningar.KundID;

-- visa alla beställningar, även om de inte är kopplade till en kund
SELECT Bestallningar.Ordernummer, Kunder.Namn 
FROM Bestallningar RIGHT JOIN Kunder 
ON Bestallningar.KundID = Kunder.KundID;

-- visa hur många beställningar varje kund gjort
SELECT KundID, COUNT(Ordernummer) AS AntalBeställningar 
FROM Bestallningar GROUP BY KundID;

-- visa med namn istället för KundID
SELECT Kunder.Namn, COUNT(Ordernummer) AS AntalBeställningar 
FROM Bestallningar 
INNER JOIN Kunder ON Bestallningar.KundID = Kunder.KundID
GROUP BY Kunder.Namn;

-- visa kunder som har gjort fler än två köp 
SELECT Kunder.Namn, COUNT(Ordernummer) AS AntalBeställningar 
FROM Bestallningar 
INNER JOIN Kunder ON Bestallningar.KundID = Kunder.KundID
GROUP BY Kunder.Namn HAVING COUNT(Ordernummer) > 2;

-- skapa ett index över kunders e-post
CREATE INDEX idx_email ON Kunder(Email);

-- visa vårt index 
SHOW INDEX FROM Kunder;

-- skapa vår trigger för att uppdatera lagersaldo efter en order
DELIMITER $$

CREATE TRIGGER uppdatera_lager
AFTER INSERT ON Orderrader
FOR EACH ROW 
BEGIN
	UPDATE Produkter
    SET Lagerstatus = Lagerstatus - NEW.Antal
    WHERE ISBN = NEW.ISBN;
END $$

DELIMITER ;

-- test för att se om vår trigger fungerar
SELECT * FROM Produkter;
SELECT * FROM Orderrader;

INSERT INTO Orderrader (Ordernummer, ISBN, Antal, Pris) VALUES
('2', '9789100199906', '1', '249');

SELECT * FROM Produkter; -- nu var det 49 böcker istället för 50

-- skapa vår kundlogg inför införandet av vår trigger
CREATE TABLE Kundlogg (
	LoggID INT AUTO_INCREMENT PRIMARY KEY,
    KundID INT,
    Registreringsdatum TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (KundID) REFERENCES Kunder (KundID)
);

SELECT * FROM Kundlogg;
    
-- skapa vår trigger som loggar när en ny kund registreras
DELIMITER $$

CREATE TRIGGER logga_ny_kund
AFTER INSERT ON Kunder
FOR EACH ROW 
BEGIN
	INSERT INTO Kundlogg (KundID)
    VALUES (NEW.KundID);
END $$

DELIMITER ;

-- test för att se om vår trigger för kundloggen fungerar
INSERT INTO Kunder (Namn, Email, Telefon, Adress) VALUES
('Peter Sten', 'peter.sten@email.com', '+46709900443', 'Rödhakevägen 85, 12345 Stockholm');

SELECT * FROM Kundlogg; -- nu finns Peters registrering där
