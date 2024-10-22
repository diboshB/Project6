-- SQL PROJECT --

-- Creatting the Regions table
CREATE TABLE Regions (
    region_id INT PRIMARY KEY AUTO_INCREMENT,
    region_name VARCHAR(100) NOT NULL
);

-- Create the Agencies table with a region_id column to link regions
CREATE TABLE Agencies (
    agency_id INT PRIMARY KEY AUTO_INCREMENT,
    agency_name VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES Regions(region_id)
);

-- Create the Sales table
CREATE TABLE Sales (
    sales_id INT PRIMARY KEY AUTO_INCREMENT,
    agency_id INT,
    sales_month VARCHAR(10) NOT NULL,
    sales_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (agency_id) REFERENCES Agencies(agency_id)
);

-- Insert sample regions
INSERT INTO Regions (region_name)
VALUES ('North America'), ('Europe'), ('Asia');

-- Insert sample agencies
INSERT INTO Agencies (agency_name, city, state, country, email, phone, region_id)
VALUES 
('TravelX', 'New York', 'NY', 'USA', 'contact@travelx.com', '123-456-7890', 1),
('EuroTravels', 'London', 'England', 'UK', 'info@eurotravels.com', '234-567-8901', 2),
('AsiaTours', 'Tokyo', 'Tokyo', 'Japan', 'support@asiatours.jp', '345-678-9012', 3);

-- Insert sample sales data
INSERT INTO Sales (agency_id, sales_month, sales_amount)
VALUES 
(1, '2024-08', 15000.00),
(1, '2024-09', 16000.00),
(2, '2024-08', 10000.00),
(2, '2024-09', 12000.00),
(3, '2024-08', 8000.00),
(3, '2024-09', 8500.00);

-- Insert additional sample regions
INSERT INTO Regions (region_name)
VALUES 
('South America'), 
('Africa'), 
('Oceania'), 
('Middle East');

-- Insert additional sample agencies
INSERT INTO Agencies (agency_name, city, state, country, email, phone, region_id)
VALUES 
('Global Adventures', 'Los Angeles', 'CA', 'USA', 'info@globaladventures.com', '456-789-0123', 1),
('EuroTrip Agency', 'Paris', 'Ile-de-France', 'France', 'hello@eurotrip.com', '567-890-1234', 2),
('Asian Travels', 'Beijing', 'Beijing', 'China', 'contact@asiantravels.cn', '678-901-2345', 3),
('Safari Tours', 'Nairobi', 'Nairobi', 'Kenya', 'support@safaritours.co.ke', '789-012-3456', 5),
('Down Under Travels', 'Sydney', 'NSW', 'Australia', 'info@downundertravels.com', '890-123-4567', 6),
('Desert Explorers', 'Dubai', 'Dubai', 'UAE', 'contact@desertexplorers.ae', '901-234-5678', 4),
('Northern Lights Tours', 'Reykjavik', 'Capital Region', 'Iceland', 'info@northernlightstours.is', '012-345-6789', 7);

-- Insert additional sample sales data
INSERT INTO Sales (agency_id, sales_month, sales_amount)
VALUES 
(1, '2024-08', 18000.00),
(1, '2024-09', 20000.00),
(1, '2024-10', 22000.00),
(2, '2024-08', 14000.00),
(2, '2024-09', 16000.00),
(2, '2024-10', 15000.00),
(3, '2024-08', 9000.00),
(3, '2024-09', 9500.00),
(3, '2024-10', 10000.00),
(4, '2024-08', 7000.00),
(4, '2024-09', 8000.00),
(4, '2024-10', 8500.00),
(5, '2024-08', 12000.00),
(5, '2024-09', 13000.00),
(5, '2024-10', 14000.00),
(6, '2024-08', 16000.00),
(6, '2024-09', 17000.00),
(6, '2024-10', 18000.00),
(7, '2024-08', 5000.00),
(7, '2024-09', 6000.00),
(7, '2024-10', 5500.00);

-- Queries --

/* Total Sales per Agency */
SELECT agency_name, SUM(sales_amount) AS total_sales
FROM Agencies
JOIN Sales ON Agencies.agency_id = Sales.agency_id
GROUP BY agency_name;

/* Monthly Sales Report */
SELECT sales_month, SUM(sales_amount) AS total_sales
FROM Sales
GROUP BY sales_month
ORDER BY sales_month;

/* Top 3 Agencies by Sales */
SELECT agency_name, SUM(sales_amount) AS total_sales
FROM Agencies
JOIN Sales ON Agencies.agency_id = Sales.agency_id
GROUP BY agency_name
ORDER BY total_sales DESC
LIMIT 3;

/* Select All Agencies with Their Corresponding Region Names */
SELECT a.agency_name, a.city, a.state, a.country, r.region_name
FROM Agencies a
JOIN Regions r ON a.region_id = r.region_id;

/* Retrieving Sales Data for a Specific Month */
SELECT a.agency_name, s.sales_month, s.sales_amount
FROM Sales s
JOIN Agencies a ON s.agency_id = a.agency_id
WHERE s.sales_month = '2024-09';

/* Get Average Sales Amount per Agency */
SELECT 
    a.agency_name, 
    AVG(s.sales_amount) AS average_sales
FROM 
    Agencies a
JOIN 
    Sales s ON a.agency_id = s.agency_id
GROUP BY 
    a.agency_name;

/* Finding Agencies with Sales Above a Certain Threshold */
SELECT 
    a.agency_name, 
    SUM(s.sales_amount) AS total_sales
FROM 
    Agencies a
JOIN 
    Sales s ON a.agency_id = s.agency_id
GROUP BY 
    a.agency_name
HAVING 
    total_sales > 25000;

/* Get Agencies That Have Not Made Any Sales */
SELECT 
    a.agency_name 
FROM 
    Agencies a
WHERE 
    a.agency_id NOT IN (SELECT agency_id FROM Sales);

/* Get the Agency with the Highest Sales */
SELECT 
    a.agency_name, 
    SUM(s.sales_amount) AS total_sales
FROM 
    Agencies a
JOIN 
    Sales s ON a.agency_id = s.agency_id
GROUP BY 
    a.agency_name
ORDER BY 
    total_sales DESC
LIMIT 1;

/* Count Agencies by Region */
SELECT 
    r.region_name, 
    COUNT(a.agency_id) AS agency_count
FROM 
    Regions r
LEFT JOIN 
    Agencies a ON r.region_id = a.region_id
GROUP BY 
    r.region_name;

/* Get Total Sales Per Region */
SELECT 
    r.region_name, 
    SUM(s.sales_amount) AS total_sales
FROM 
    Regions r
LEFT JOIN 
    Agencies a ON r.region_id = a.region_id
LEFT JOIN 
    Sales s ON a.agency_id = s.agency_id
GROUP BY 
    r.region_name;

/* Inserting Multiple Sales Records in One Query */
INSERT INTO Sales (agency_id, sales_month, sales_amount)
VALUES 
(1, '2024-10', 17000.00),
(2, '2024-10', 13000.00),
(3, '2024-10', 9000.00),
(4, '2024-10', 25000.00),
(5, '2024-10', 14000.00);

/* Update Multiple Records with Conditional Logic */
-- Disabling safe update mode
SET SQL_SAFE_UPDATES = 0;
-- Now we can perform updates or deletes without the key restriction
DELETE FROM Sales WHERE agency_id = 5;  

/* Get Detailed Sales Report with Agency and Region Information */
SELECT 
    a.agency_name, 
    r.region_name, 
    s.sales_month, 
    s.sales_amount
FROM 
    Sales s
JOIN 
    Agencies a ON s.agency_id = a.agency_id
JOIN 
    Regions r ON a.region_id = r.region_id
ORDER BY 
    r.region_name, s.sales_month;


-- END --


