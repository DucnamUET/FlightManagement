-- a. Query using INNER JOIN
-- Lấy danh sách chuyến bay, bao gồm thông tin sân bay khởi hành và sân bay đến.
USE FlightManagement;

SELECT 
    FLIGHTS.flightID,
    AIRPORTS1.name AS departureAirport,
    AIRPORTS2.name AS arrivalAirport,
    FLIGHTS.departureTime,
    FLIGHTS.arrivalTime
FROM FLIGHTS
INNER JOIN AIRPORTS AS AIRPORTS1 ON FLIGHTS.departureAirportID = AIRPORTS1.airportID
INNER JOIN AIRPORTS AS AIRPORTS2 ON FLIGHTS.arrivalAirportID = AIRPORTS2.airportID;
-- b. Query using OUTER JOIN
-- Lấy danh sách tất cả sân bay và các chuyến bay khởi hành từ đó (nếu có).

SELECT 
    AIRPORTS.name AS airportName,
    FLIGHTS.flightID AS flightID,
    FLIGHTS.departureTime AS departureTime
FROM AIRPORTS
LEFT OUTER JOIN FLIGHTS ON AIRPORTS.airportID = FLIGHTS.departureAirportID;

-- c. Using subquery in WHERE
-- Tìm các chuyến bay có giá vé cơ bản cao hơn giá vé trung bình.

SELECT 
    flightID, 
    baseFare 
FROM FLIGHTS
WHERE baseFare > (SELECT AVG(baseFare) FROM FLIGHTS);

-- d. Using subquery in FROM
-- Hiển thị số chuyến bay từ mỗi sân bay khởi hành.
    
SELECT 
    AIRPORTS.name AS airportName,
    flightCounts.totalFlights
FROM 
    (SELECT 
         departureAirportID, 
         COUNT(*) AS totalFlights 
     FROM 
         FLIGHTS 
     GROUP BY 
         departureAirportID) AS flightCounts
INNER JOIN AIRPORTS 
    ON flightCounts.departureAirportID = AIRPORTS.airportID;
    
-- e. Query using GROUP BY and aggregate functions
-- Tính tổng số chuyến bay và giá vé trung bình của mỗi sân bay khởi hành.

SELECT 
    AIRPORTS.name AS airportName,
    COUNT(FLIGHTS.flightID) AS totalFlights,
    AVG(FLIGHTS.baseFare) AS averageFare
FROM 
    FLIGHTS
INNER JOIN AIRPORTS 
    ON FLIGHTS.departureAirportID = AIRPORTS.airportID
GROUP BY 
    AIRPORTS.name;



