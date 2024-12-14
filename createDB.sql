-- Tạo cơ sở dữ liệu
CREATE DATABASE IF NOT EXISTS FlightManagement;
USE FlightManagement;

-- Bảng AIRPORTS: Quản lý sân bay
CREATE TABLE IF NOT EXISTS AIRPORTS (
    airportID VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100)
);

-- Bảng FLIGHTS: Quản lý chuyến bay
CREATE TABLE IF NOT EXISTS FLIGHTS (
    flightID VARCHAR(10) PRIMARY KEY,
    departureAirportID VARCHAR(10),
    arrivalAirportID VARCHAR(10),
    departureTime TIME,
    departureDate DATE,
    arrivalTime TIME,
    arrivalDate DATE,
    baseFare DECIMAL(10, 2)
);

-- Bảng CUSTOMERS: Quản lý khách hàng
CREATE TABLE IF NOT EXISTS CUSTOMERS (
    customerID VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(255),
    phone VARCHAR(15),
    email VARCHAR(100),
    dateOfBirth DATE
);

-- Bảng STAFF: Quản lý nhân viên (bao gồm phi công)
CREATE TABLE IF NOT EXISTS STAFF (
    staffID VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(255),
    phone VARCHAR(15),
    salary DECIMAL(10, 2),
    staffType ENUM('Pilot', 'Crew') -- 'Pilot' hoặc 'Crew'
);

-- Bảng AIRCRAFT_TYPES: Loại máy bay
CREATE TABLE IF NOT EXISTS AIRCRAFT_TYPES (
    typeID VARCHAR(10) PRIMARY KEY,
    manufacturer VARCHAR(100),
    model VARCHAR(100)
);

-- Bảng AIRCRAFTS: Quản lý máy bay
CREATE TABLE IF NOT EXISTS AIRCRAFTS (
    aircraftID VARCHAR(10) PRIMARY KEY,
    typeID VARCHAR(10),
    capacity INT
);

-- Bảng SCHEDULES: Quản lý lịch bay
CREATE TABLE IF NOT EXISTS SCHEDULES (
    scheduleID INT AUTO_INCREMENT PRIMARY KEY,
    flightID VARCHAR(10),
    aircraftID VARCHAR(10),
    flightDate DATE
);

-- Bảng BOOKINGS: Quản lý đặt vé
CREATE TABLE IF NOT EXISTS BOOKINGS (
    bookingID INT AUTO_INCREMENT PRIMARY KEY,
    customerID VARCHAR(10),
    flightID VARCHAR(10),
    bookingDate DATETIME,
    ticketPrice DECIMAL(10, 2)
);

-- Bảng ASSIGNMENTS: Phân công nhân viên
CREATE TABLE IF NOT EXISTS ASSIGNMENTS (
    staffID VARCHAR(10),
    scheduleID INT,
    PRIMARY KEY (staffID, scheduleID)
);

-- Bảng SKILLS: Kỹ năng của nhân viên
CREATE TABLE IF NOT EXISTS SKILLS (
    staffID VARCHAR(10),
    typeID VARCHAR(10),
    PRIMARY KEY (staffID, typeID)
);

-- Tạo khóa ngoại cho bảng FLIGHTS tham chiếu khóa chính của bảng AIRPORTS
alter table FLIGHTS
add constraint FK_DepartureAirport
foreign key (departureAirportID)
references AIRPORTS(airportID);

alter table FLIGHTS
add constraint FK_ArrivalAirport
foreign key (arrivalAirportID)
references AIRPORTS(airportID);

-- Tạo khóa ngoại cho bảng AIRCRAFTS tham chiếu khóa chính của bảng AIRCRAFT_TYPES
alter table AIRCRAFTS
add constraint FK_AircraftType
foreign key (typeID)
references AIRCRAFT_TYPES(typeID);

-- Tạo khóa ngoại cho bảng SCHEDULES tham chiếu khóa chính của bảng FLIGHTS và AIRCRAFTS
alter table SCHEDULES
add constraint FK_FlightID
foreign key (flightID)
references FLIGHTS(flightID);

alter table SCHEDULES
add constraint FK_AircraftID
foreign key (aircraftID)
references AIRCRAFTS(aircraftID);

-- Tạo khóa ngoại cho bảng BOOKINGS tham chiếu khóa chính của bảng CUSTOMERS và FLIGHTS
alter table BOOKINGS
add constraint FK_CustomerID
foreign key (customerID)
references CUSTOMERS(customerID);

alter table BOOKINGS
add constraint FK_FlightBooking
foreign key (flightID)
references FLIGHTS(flightID);

-- Tạo khóa ngoại cho bảng ASSIGNMENTS tham chiếu khóa chính của bảng STAFF và SCHEDULES
alter table ASSIGNMENTS
add constraint FK_StaffID
foreign key (staffID)
references STAFF(staffID);

alter table ASSIGNMENTS
add constraint FK_ScheduleID
foreign key (scheduleID)
references SCHEDULES(scheduleID);

-- Tạo khóa ngoại cho bảng SKILLS tham chiếu khóa chính của bảng STAFF và AIRCRAFT_TYPES
alter table SKILLS
add constraint FK_StaffSkills
foreign key (staffID)
references STAFF(staffID);

alter table SKILLS
add constraint FK_AircraftTypeSkills
foreign key (typeID)
references AIRCRAFT_TYPES(typeID);
-- Tạo cơ sở dữ liệu
CREATE DATABASE IF NOT EXISTS FlightManagement;
USE FlightManagement;

-- Bảng AIRPORTS: Quản lý sân bay
CREATE TABLE IF NOT EXISTS AIRPORTS (
    airportID VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100)
);

-- Bảng FLIGHTS: Quản lý chuyến bay
CREATE TABLE IF NOT EXISTS FLIGHTS (
    flightID VARCHAR(10) PRIMARY KEY,
    departureAirportID VARCHAR(10),
    arrivalAirportID VARCHAR(10),
    departureTime TIME,
    departureDate DATE,
    arrivalTime TIME,
    arrivalDate DATE,
    baseFare DECIMAL(10, 2)
);

-- Bảng CUSTOMERS: Quản lý khách hàng
CREATE TABLE IF NOT EXISTS CUSTOMERS (
    customerID VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(255),
    phone VARCHAR(15),
    email VARCHAR(100),
    dateOfBirth DATE
);

-- Bảng STAFF: Quản lý nhân viên (bao gồm phi công)
CREATE TABLE IF NOT EXISTS STAFF (
    staffID VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(255),
    phone VARCHAR(15),
    salary DECIMAL(10, 2),
    staffType ENUM('Pilot', 'Crew') -- 'Pilot' hoặc 'Crew'
);

-- Bảng AIRCRAFT_TYPES: Loại máy bay
CREATE TABLE IF NOT EXISTS AIRCRAFT_TYPES (
    typeID VARCHAR(10) PRIMARY KEY,
    manufacturer VARCHAR(100),
    model VARCHAR(100)
);

-- Bảng AIRCRAFTS: Quản lý máy bay
CREATE TABLE IF NOT EXISTS AIRCRAFTS (
    aircraftID VARCHAR(10) PRIMARY KEY,
    typeID VARCHAR(10),
    capacity INT
);

-- Bảng SCHEDULES: Quản lý lịch bay
CREATE TABLE IF NOT EXISTS SCHEDULES (
    scheduleID INT AUTO_INCREMENT PRIMARY KEY,
    flightID VARCHAR(10),
    aircraftID VARCHAR(10),
    flightDate DATE
);

-- Bảng BOOKINGS: Quản lý đặt vé
CREATE TABLE IF NOT EXISTS BOOKINGS (
    bookingID INT AUTO_INCREMENT PRIMARY KEY,
    customerID VARCHAR(10),
    flightID VARCHAR(10),
    bookingDate DATETIME,
    ticketPrice DECIMAL(10, 2)
);

-- Bảng ASSIGNMENTS: Phân công nhân viên
CREATE TABLE IF NOT EXISTS ASSIGNMENTS (
    staffID VARCHAR(10),
    scheduleID INT,
    PRIMARY KEY (staffID, scheduleID)
);

-- Bảng SKILLS: Kỹ năng của nhân viên
CREATE TABLE IF NOT EXISTS SKILLS (
    staffID VARCHAR(10),
    typeID VARCHAR(10),
    PRIMARY KEY (staffID, typeID)
);

-- Tạo khóa ngoại cho bảng FLIGHTS tham chiếu khóa chính của bảng AIRPORTS
alter table FLIGHTS
add constraint FK_DepartureAirport
foreign key (departureAirportID)
references AIRPORTS(airportID);

alter table FLIGHTS
add constraint FK_ArrivalAirport
foreign key (arrivalAirportID)
references AIRPORTS(airportID);

-- Tạo khóa ngoại cho bảng AIRCRAFTS tham chiếu khóa chính của bảng AIRCRAFT_TYPES
alter table AIRCRAFTS
add constraint FK_AircraftType
foreign key (typeID)
references AIRCRAFT_TYPES(typeID);

-- Tạo khóa ngoại cho bảng SCHEDULES tham chiếu khóa chính của bảng FLIGHTS và AIRCRAFTS
alter table SCHEDULES
add constraint FK_FlightID
foreign key (flightID)
references FLIGHTS(flightID);

alter table SCHEDULES
add constraint FK_AircraftID
foreign key (aircraftID)
references AIRCRAFTS(aircraftID);

-- Tạo khóa ngoại cho bảng BOOKINGS tham chiếu khóa chính của bảng CUSTOMERS và FLIGHTS
alter table BOOKINGS
add constraint FK_CustomerID
foreign key (customerID)
references CUSTOMERS(customerID);

alter table BOOKINGS
add constraint FK_FlightBooking
foreign key (flightID)
references FLIGHTS(flightID);

-- Tạo khóa ngoại cho bảng ASSIGNMENTS tham chiếu khóa chính của bảng STAFF và SCHEDULES
alter table ASSIGNMENTS
add constraint FK_StaffID
foreign key (staffID)
references STAFF(staffID);

alter table ASSIGNMENTS
add constraint FK_ScheduleID
foreign key (scheduleID)
references SCHEDULES(scheduleID);

-- Tạo khóa ngoại cho bảng SKILLS tham chiếu khóa chính của bảng STAFF và AIRCRAFT_TYPES
alter table SKILLS
add constraint FK_StaffSkills
foreign key (staffID)
references STAFF(staffID);

alter table SKILLS
add constraint FK_AircraftTypeSkills
foreign key (typeID)
references AIRCRAFT_TYPES(typeID);
