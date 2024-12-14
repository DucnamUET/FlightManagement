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
    departureTime TIME NOT NULL,
    departureDate DATE NOT NULL,
    arrivalTime TIME NOT NULL,
    arrivalDate DATE NOT NULL,
    baseFare DECIMAL(10, 2) NOT NULL CHECK (baseFare > 0),
    UNIQUE (flightID, departureDate), -- Đảm bảo mỗi chuyến bay trong ngày là duy nhất
    CHECK ((departureDate < arrivalDate) OR (departureDate = arrivalDate AND departureTime < arrivalTime)) -- Kiểm tra logic thời gian
);

-- Bảng CUSTOMERS: Quản lý khách hàng
CREATE TABLE IF NOT EXISTS CUSTOMERS (
    customerID VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE, -- Số điện thoại duy nhất
    email VARCHAR(100) UNIQUE, -- Email duy nhất
    dateOfBirth DATE
);

-- Bảng STAFF: Quản lý nhân viên (bao gồm phi công)
CREATE TABLE IF NOT EXISTS STAFF (
    staffID VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(15) NOT NULL UNIQUE,
    salary DECIMAL(10, 2) CHECK (salary > 0), -- Lương phải lớn hơn 0
    staffType ENUM('Pilot', 'Crew') NOT NULL -- 'Pilot' hoặc 'Crew'
);

-- Bảng AIRCRAFT_TYPES: Loại máy bay
CREATE TABLE IF NOT EXISTS AIRCRAFT_TYPES (
    typeID VARCHAR(10) PRIMARY KEY,
    manufacturer VARCHAR(100)
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
CREATE TABLE BOOKINGS (
    bookingID VARCHAR(10) PRIMARY KEY,
    customerID VARCHAR(10) NOT NULL,
    flightID VARCHAR(10) NOT NULL,
    bookingDate DATE NOT NULL,
    seatClass VARCHAR(20) CHECK (seatClass IN ('Economy', 'Business', 'First Class')), -- Kiểm tra loại ghế
    status VARCHAR(20) CHECK (status IN ('Confirmed', 'Pending', 'Cancelled')) -- Kiểm tra trạng thái đặt vé
);


-- Bảng ASSIGNMENTS: Phân công nhân viên
CREATE TABLE IF NOT EXISTS ASSIGNMENTS (
    staffID VARCHAR(10),
    scheduleID INT,
    PRIMARY KEY (staffID, scheduleID)
);

-- Bảng SKILLS: Kỹ năng của nhân viên
CREATE TABLE SKILLS (
    staffID VARCHAR(10) NOT NULL,
    typeID VARCHAR(10) NOT NULL,
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

-- Nhập dữ liệu cho bảng CUSTOMERS
INSERT INTO CUSTOMERS (customerID, name, address, phone, email, dateOfBirth) VALUES
('0009', 'Nga', '223 Nguyen Trai', '0912345678', 'nga19900515@gmail.com', '1990-05-15'),
('0101', 'Anh', '567 Tran Phu', '0988765432', 'anh19851020@gmail.com', '1985-10-20'),
('0045', 'Thu', '285 Le Loi', '0911223344', 'thu19920225@gmail.com', '1992-02-25'),
('0012', 'Ha', '435 Quang Trung', '0933445566', 'ha19930811@gmail.com', '1993-08-11'),
('0238', 'Hung', '456 Pasteur', '0987112233', 'hung19871204@gmail.com', '1987-12-04'),
('0397', 'Thanh', '234 Le Van Sy', '0912345679', 'thanh19910316@gmail.com', '1991-03-16'),
('0582', 'Mai', '789 Nguyen Du', '0935556677', 'mai19940730@gmail.com', '1994-07-30'),
('0934', 'Minh', '678 Le Lai', '0916789012', 'minh19900110@gmail.com', '1990-01-10'),
('0091', 'Hai', '345 Hung Vuong', '0922334455', 'hai19880605@gmail.com', '1988-06-05'),
('0314', 'Phuong', '385 Vo Van Tuan', '0917665545', 'phuong19920418@gmail.com', '1992-04-18'),
('0613', 'Vu', '348 CMT8', '0923445566', 'vu19950922@gmail.com', '1995-09-22'),
('0586', 'Son', '123 Bach Dang', '0932334455', 'son19891109@gmail.com', '1989-11-09'),
('0422', 'Tien', '75 Nguyen Thong', '0911998877', 'tien19861214@gmail.com', '1986-12-14'),
('0173', 'Lan', '101 Hong Bang', '0932123456', 'lan19810101@gmail.com', '1981-01-01'),
('0485', 'Kien', '223 Hoang Hoa Tham', '0912123456', 'kien19951005@gmail.com', '1995-10-05'),
('0531', 'Hoa', '345 Duong Quang Ham', '0988321456', 'hoa19871107@gmail.com', '1987-11-07'),
('0120', 'Ngoc', '456 Le Duan', '0914123456', 'ngoc19930123@gmail.com', '1993-01-23'),
('0239', 'Tung', '567 Bach Mai', '0936223345', 'tung19870218@gmail.com', '1987-02-18'),
('0745', 'Bao', '678 Mai Thi Luu', '0924321234', 'bao19951212@gmail.com', '1995-12-12'),
('0179', 'Yen', '789 Thai Thi Buoi', '0987322345', 'yen19860325@gmail.com', '1986-03-25'),
('0270', 'Bich', '890 Tran Quang Khai', '0915345678', 'bich19921114@gmail.com', '1992-11-14'),
('0917', 'Lam', '101 Duong Thi Minh', '0922445566', 'lam19840520@gmail.com', '1984-05-20'),
('0672', 'Mai', '123 Lam Son', '0911334455', 'mai19901215@gmail.com', '1990-12-15'),
('0853', 'Tam', '456 Thanh Long', '0989322111', 'tam19960107@gmail.com', '1996-01-07'),
('0523', 'Hien', '789 Huynh Tan Phat', '0915443233', 'hien19820313@gmail.com', '1982-03-13'),
('0325', 'Hoa', '876 Lieu Gia', '0933122334', 'hoa19930805@gmail.com', '1993-08-05'),
('0401', 'Tu', '145 Thanh Son', '0918654332', 'tu19870917@gmail.com', '1987-09-17'),
('0167', 'Quyen', '234 Phan Dinh Phung', '0922233445', 'quyen19931230@gmail.com', '1993-12-30'),
('0593', 'Thao', '543 Ngo Quyen', '0914443322', 'thao19970111@gmail.com', '1997-01-11'),
('0395', 'Dung', '122 Hoang Quoc Viet', '0925546777', 'dung19900410@gmail.com', '1990-04-10'),
('0532', 'Quang', '245 Thien Thai', '0913223456', 'quang19940420@gmail.com', '1994-04-20'),
('0421', 'Mai', '234 Dai Loc', '0911992333', 'mai19870714@gmail.com', '1987-07-14'),
('0721', 'Trang', '345 Thanh Tay', '0935566778', 'trang19950521@gmail.com', '1995-05-21'),
('0563', 'Ha', '456 Thuong Thanh', '0917654433', 'ha19930818@gmail.com', '1993-08-18'),
('0772', 'Kim', '567 Xo Viet Nghe Tinh', '0987654321', 'kim19870519@gmail.com', '1987-05-19'),
('0633', 'Son', '678 Lieu Tho', '0922331122', 'son19970305@gmail.com', '1997-03-05'),
('0875', 'Bich', '789 Lien Chieu', '0917888223', 'bich19891212@gmail.com', '1989-12-12'),
('0786', 'Anh', '890 Tam Son', '0934455566', 'anh19850620@gmail.com', '1985-06-20'),
('0274', 'Anh', '101 Vuong Chi Minh', '0911777889', 'anh19900215@gmail.com', '1990-02-15'),
('0518', 'Chien', '234 Duong Duy Tan', '0927888777', 'chien19920330@gmail.com', '1992-03-30'),
('0643', 'Thu', '345 Nguyen Trung', '0933557788', 'thu19891222@gmail.com', '1989-12-22'),
('0724', 'Huong', '456 Thanh Hoa', '0912345680', 'huong19870720@gmail.com', '1987-07-20'),
('0801', 'Tuan', '567 Hoang Hoa', '0922334456', 'tuan19910202@gmail.com', '1991-02-02'),
('0664', 'Kien', '678 Dong Tam', '0918554433', 'kien19930605@gmail.com', '1993-06-05'),
('0715', 'Anh', '789 Duy Tien', '0933445567', 'anh19900722@gmail.com', '1990-07-22'),
('0792', 'Phong', '890 Le Quang', '0922123456', 'phong19830504@gmail.com', '1983-05-04'),
('0267', 'Minh', '101 Xuan Thien', '0918332211', 'minh19850325@gmail.com', '1985-03-25'),
('0465', 'Tung', '234 Mai Thi Lieu', '0917665444', 'tung19940216@gmail.com', '1994-02-16'),
('0172', 'Phong', '345 Vinh Son', '0932234567', 'phong19891213@gmail.com', '1989-12-13'),
('0298', 'Trang', '567 Thanh Tho', '0924333344', 'trang19920829@gmail.com', '1992-08-29'),
('0377', 'Lan', '678 Duong Bang', '0913665432', 'lan19890710@gmail.com', '1989-07-10'),
('0456', 'My', '789 Khoi Bao', '0927888222', 'my19840622@gmail.com', '1984-06-22'),
('0318', 'Vy', '890 Thanh Son', '0914332211', 'vy19951206@gmail.com', '1995-12-06'),
('0572', 'Ngoc', '101 Ba Tri', '0931223344', 'ngoc19890519@gmail.com', '1989-05-19'),
('0350', 'Thanh', '234 Lieu Thanh', '0917665555', 'thanh19940918@gmail.com', '1994-09-18');

-- Nhập thông tin với bảng Flights
INSERT INTO FLIGHTS (flightID, departureAirportID, arrivalAirportID, departureTime, departureDate, arrivalTime, arrivalDate, baseFare) VALUES
('100', 'SLC', 'BOS', '08:00', '2019-01-10', '17:59', '2019-01-10', 200.00),
('112', 'DCA', 'DEN', '14:00', '2019-02-15', '18:07', '2019-02-15', 250.00),
('121', 'STL', 'SLC', '07:00', '2019-03-12', '09:13', '2019-03-12', 220.00),
('122', 'STL', 'YYV', '08:30', '2019-04-05', '10:19', '2019-04-05', 240.00),
('206', 'DFW', 'STL', '09:00', '2019-05-20', '11:40', '2019-05-20', 260.00),
('330', 'JFK', 'YYV', '16:00', '2019-06-18', '18:53', '2019-06-18', 280.00),
('334', 'ORD', 'MIA', '12:00', '2019-07-07', '14:14', '2019-07-07', 300.00),
('335', 'MIA', 'ORD', '15:00', '2019-08-13', '17:14', '2019-08-13', 310.00),
('336', 'ORD', 'MIA', '18:00', '2019-09-09', '20:14', '2019-09-09', 320.00),
('337', 'MIA', 'ORD', '20:30', '2019-10-19', '23:53', '2019-10-19', 330.00),
('394', 'DFW', 'MIA', '19:00', '2019-11-25', '21:30', '2019-11-25', 340.00),
('395', 'MIA', 'DFW', '21:00', '2019-12-12', '23:43', '2019-12-12', 350.00),
('449', 'CDG', 'DEN', '10:00', '2019-03-15', '19:29', '2019-03-15', 400.00),
('930', 'YYV', 'DCA', '13:00', '2019-04-25', '16:10', '2019-04-25', 150.00),
('931', 'DCA', 'YYV', '17:00', '2019-06-10', '18:10', '2019-06-10', 160.00),
('932', 'DCA', 'YYV', '18:00', '2019-07-20', '19:10', '2019-07-20', 170.00),
('991', 'BOS', 'ORD', '17:00', '2019-08-17', '18:22', '2019-08-17', 180.00),
('992', 'BOS', 'LAX', '06:00', '2019-10-05', '09:30', '2019-10-05', 220.00),
('993', 'LAX', 'SFO', '07:00', '2019-11-01', '08:30', '2019-11-01', 210.00),
('994', 'ORD', 'LAX', '09:00', '2019-02-14', '12:00', '2019-02-14', 230.00),
('995', 'LAX', 'ORD', '10:00', '2019-04-18', '13:30', '2019-04-18', 240.00),
('996', 'STL', 'MIA', '11:00', '2019-05-09', '14:00', '2019-05-09', 250.00),
('997', 'MIA', 'DFW', '12:00', '2019-07-30', '15:00', '2019-07-30', 260.00),
('998', 'DFW', 'STL', '13:00', '2019-09-13', '15:45', '2019-09-13', 270.00),
('999', 'STL', 'ORD', '14:00', '2019-11-22', '16:00', '2019-11-22', 280.00),
('1000', 'MIA', 'BOS', '15:00', '2019-01-27', '17:00', '2019-01-27', 290.00),
('1001', 'BOS', 'ORD', '16:00', '2019-03-03', '18:15', '2019-03-03', 300.00),
('1002', 'ORD', 'MIA', '17:00', '2019-05-08', '19:30', '2019-05-08', 310.00),
('1003', 'MIA', 'ORD', '18:00', '2019-07-15', '20:00', '2019-07-15', 320.00),
('1004', 'LAX', 'SFO', '06:30', '2019-09-25', '07:45', '2019-09-25', 330.00),
('1005', 'SFO', 'LAX', '08:00', '2019-10-03', '09:30', '2019-10-03', 340.00),
('1006', 'JFK', 'YYV', '09:30', '2019-12-18', '11:30', '2019-12-18', 350.00),
('1007', 'YYV', 'JFK', '10:00', '2019-03-10', '12:30', '2019-03-10', 360.00),
('1008', 'ORD', 'STL', '11:00', '2019-06-29', '12:30', '2019-06-29', 370.00),
('1009', 'STL', 'ORD', '12:30', '2019-08-14', '14:00', '2019-08-14', 380.00),
('1010', 'DFW', 'BOS', '13:30', '2019-11-04', '16:00', '2019-11-04', 390.00),
('1011', 'MIA', 'JFK', '14:00', '2019-12-01', '16:30', '2019-12-01', 400.00),
('1012', 'STL', 'YYV', '15:00', '2019-02-22', '16:30', '2019-02-22', 410.00),
('1013', 'YYV', 'STL', '16:00', '2019-04-07', '17:30', '2019-04-07', 400.00);

INSERT INTO AIRCRAFT_TYPES (typeID, manufacturer) 
VALUES
('B737', 'Boeing'),
('A320', 'Airbus'),
('B777', 'Boeing'),
('E175', 'Embraer'),
('A330', 'Airbus'),
('CRJ700', 'Bombardier'),
('B757', 'Boeing'),
('A350', 'Airbus'),
('B747', 'Boeing'),
('A321', 'Airbus'),
('B787', 'Boeing'),
('CRJ200', 'Bombardier'),
('E190', 'Embraer'),
('A220', 'Airbus'),
('B767', 'Boeing'),
('A340', 'Airbus'),
('CRJ900', 'Bombardier');

 

-- Nhập thông tin với bảng Aicrafts
INSERT INTO AIRCRAFTS (aircraftID, typeID, capacity) VALUES
('A001', 'B737', 180),
('A002', 'A320', 160),
('A003', 'B777', 350),
('A004', 'E175', 76),
('A005', 'A330', 290),
('A006', 'CRJ700', 70),
('A007', 'B757', 243),
('A008', 'A350', 300),
('A009', 'B747', 410),
('A010', 'A321', 200),
('A011', 'B737', 180),
('A012', 'A320', 160),
('A013', 'B787', 242),
('A014', 'CRJ200', 50),
('A015', 'E190', 97),
('A016', 'A220', 140),
('A017', 'B737', 180),
('A018', 'A330', 290),
('A019', 'B767', 275),
('A020', 'A340', 330),
('A021', 'B777', 350),
('A022', 'B747', 410),
('A023', 'A320', 160),
('A024', 'CRJ900', 76),
('A025', 'B757', 243),
('A026', 'A350', 300),
('A027', 'B737', 180),
('A028', 'A320', 160),
('A029', 'B737', 180),
('A030', 'E175', 76),
('A031', 'CRJ700', 70),
('A032', 'B787', 242),
('A033', 'A321', 200),
('A034', 'B777', 350),
('A035', 'A320', 160),
('A036', 'B757', 243),
('A037', 'A350', 300),
('A038', 'CRJ900', 76),
('A039', 'B747', 410);

-- Nhập dữ liệu cho bảng AIRPORTS
INSERT INTO AIRPORTS (airportID, name, city, country) VALUES
('SLC', 'Salt Lake City International Airport', 'Salt Lake City', 'USA'),
('BOS', 'Boston Logan International Airport', 'Boston', 'USA'),
('DCA', 'Ronald Reagan Washington National Airport', 'Washington DC', 'USA'),
('DEN', 'Denver International Airport', 'Denver', 'USA'),
('STL', 'St. Louis Lambert International Airport', 'St. Louis', 'USA'),
('YYV', 'Yarmouth Airport', 'Yarmouth', 'Canada'),
('DFW', 'Dallas/Fort Worth International Airport', 'Dallas', 'USA'),
('JFK', 'John F. Kennedy International Airport', 'New York', 'USA'),
('ORD', 'Chicago O\'Hare International Airport', 'Chicago', 'USA'),
('MIA', 'Miami International Airport', 'Miami', 'USA'),
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'USA'),
('SFO', 'San Francisco International Airport', 'San Francisco', 'USA'),
('CDG', 'Charles de Gaulle Airport', 'Paris', 'France');

-- Nhập dữ liệu cho bảng STAFF
INSERT INTO STAFF (staffID, name, address, phone, salary, staffType) VALUES
('S001', 'John Doe', '123 Elm Street, Boston, USA', '0914567890', 85000.00, 'Pilot'),
('S002', 'Jane Smith', '456 Oak Avenue, Denver, USA', '0925678901', 60000.00, 'Crew'),
('S003', 'Alice Johnson', '789 Pine Road, Dallas, USA', '0936789012', 90000.00, 'Pilot'),
('S004', 'Robert Brown', '321 Maple Lane, Chicago, USA', '0947890123', 62000.00, 'Crew'),
('S005', 'Emily Davis', '654 Birch Drive, Miami, USA', '0958901234', 87000.00, 'Pilot'),
('S006', 'Michael Wilson', '987 Cedar Boulevard, Los Angeles, USA', '0969012345', 58000.00, 'Crew'),
('S007', 'Sarah Miller', '111 Spruce Court, Washington DC, USA', '0970123456', 88000.00, 'Pilot'),
('S008', 'David Martinez', '222 Palm Way, San Francisco, USA', '0981234567', 60000.00, 'Crew'),
('S009', 'Olivia Garcia', '333 Redwood Street, Paris, France', '0992345678', 92000.00, 'Pilot'),
('S010', 'James Anderson', '444 Cypress Avenue, New York, USA', '0903456789', 61000.00, 'Crew'),
('S011', 'Chris Thompson', '555 Willow Drive, Boston, USA', '0911122334', 85000.00, 'Pilot'),
('S012', 'Patricia Lewis', '666 Maple Road, Dallas, USA', '0922233445', 62000.00, 'Crew'),
('S013', 'Matthew Walker', '777 Oak Street, Miami, USA', '0933344556', 87000.00, 'Pilot'),
('S014', 'Amanda Scott', '888 Birch Avenue, San Francisco, USA', '0944455667', 60000.00, 'Crew'),
('S015', 'Joshua Young', '999 Cedar Court, Chicago, USA', '0955566778', 90000.00, 'Pilot'),
('S016', 'Sophia Harris', '1010 Elm Street, Los Angeles, USA', '0966677889', 62000.00, 'Crew'),
('S017', 'Liam King', '1111 Pine Road, Washington DC, USA', '0977788990', 85000.00, 'Pilot'),
('S018', 'Megan Adams', '1212 Spruce Avenue, Denver, USA', '0988899001', 61000.00, 'Crew'),
('S019', 'Ethan Clark', '1313 Palm Boulevard, Paris, France', '0999000112', 92000.00, 'Pilot'),
('S020', 'Charlotte Harris', '1414 Redwood Street, New York, USA', '0901122333', 60000.00, 'Crew'),
('S021', 'Oliver Robinson', '1515 Willow Avenue, Boston, USA', '0912233444', 87000.00, 'Pilot'),
('S022', 'Isabella Walker', '1616 Oak Lane, Dallas, USA', '0923344555', 61000.00, 'Crew'),
('S023', 'Jack Turner', '1717 Maple Road, Miami, USA', '0934455666', 85000.00, 'Pilot'),
('S024', 'Ava Lee', '1818 Birch Court, San Francisco, USA', '0945566777', 60000.00, 'Crew'),
('S025', 'Noah Carter', '1919 Cedar Boulevard, Los Angeles, USA', '0956677888', 92000.00, 'Pilot'),
('S026', 'Sophie Perez', '2020 Elm Avenue, Washington DC, USA', '0967788999', 61000.00, 'Crew'),
('S027', 'Lucas Martin', '2121 Spruce Court, New York, USA', '0978899000', 87000.00, 'Pilot'),
('S028', 'Lily Lee', '2222 Pine Road, Denver, USA', '0989900101', 60000.00, 'Crew'),
('S029', 'Gabriel White', '2323 Oak Lane, Paris, France', '0990011212', 85000.00, 'Pilot'),
('S030', 'Chloe Brown', '2424 Willow Street, Miami, USA', '0901122334', 62000.00, 'Crew'),
('S031', 'Daniel Green', '2525 Maple Avenue, Chicago, USA', '0912233445', 87000.00, 'Pilot'),
('S032', 'Ella Hall', '2626 Birch Drive, San Francisco, USA', '0913344556', 60000.00, 'Crew'),
('S033', 'Mason Allen', '2727 Cedar Road, Los Angeles, USA', '0934455667', 92000.00, 'Pilot'),
('S034', 'Amelia Wright', '2828 Elm Court, Washington DC, USA', '0945566778', 61000.00, 'Crew'),
('S035', 'James Hill', '2929 Pine Lane, New York, USA', '0956677889', 85000.00, 'Pilot'),
('S036', 'Liam Roberts', '3030 Spruce Street, Dallas, USA', '0967788992', 62000.00, 'Crew'),
('S037', 'Mia Clark', '3131 Oak Court, Paris, France', '0978899001', 87000.00, 'Pilot'),
('S038', 'Benjamin Walker', '3232 Maple Road, Miami, USA', '0989900112', 60000.00, 'Crew'),
('S039', 'Ella Turner', '3333 Birch Street, Los Angeles, USA', '0990011223', 92000.00, 'Pilot'),
('S040', 'Ryan Scott', '3434 Pine Road, Boston, USA', '0912345578', 60000.00, 'Crew'),
('S041', 'Grace Johnson', '3535 Oak Lane, Denver, USA', '0923455789', 85000.00, 'Pilot'),
('S042', 'Hannah Lee', '3636 Maple Boulevard, Dallas, USA', '0934567890', 87000.00, 'Crew'),
('S043', 'Evan Turner', '3737 Birch Street, Miami, USA', '0945678900', 60000.00, 'Pilot'),
('S044', 'Oliver Harris', '3838 Cedar Avenue, San Francisco, USA', '0956789002', 92000.00, 'Crew'),
('S045', 'Zoe White', '3939 Spruce Court, Los Angeles, USA', '0967890113', 85000.00, 'Pilot'),
('S046', 'James Moore', '4040 Palm Avenue, Washington DC, USA', '0978901224', 60000.00, 'Crew'),
('S047', 'Catherine Martin', '4141 Redwood Street, Paris, France', '0989012245', 92000.00, 'Pilot'),
('S048', 'Michael Davis', '4242 Elm Drive, Chicago, USA', '0980123456', 61000.00, 'Crew'),
('S049', 'Aidan Harris', '4343 Pine Boulevard, Miami, USA', '0901134567', 85000.00, 'Pilot'),
('S050', 'Lily Green', '4444 Oak Road, Dallas, USA', '0912345671', 60000.00, 'Crew'),
('S051', 'Nathan White', '4545 Birch Lane, San Francisco, USA', '0913452789', 87000.00, 'Pilot'),
('S052', 'Emma Turner', '4646 Cedar Boulevard, Los Angeles, USA', '0924367890', 60000.00, 'Crew'),
('S053', 'Liam Harris', '4747 Palm Avenue, Washington DC, USA', '0945671901', 85000.00, 'Pilot'),
('S054', 'Ella Adams', '4848 Redwood Avenue, Paris, France', '0956786012', 92000.00, 'Crew'),
('S055', 'Sophie Brown', '4949 Spruce Street, New York, USA', '0967820123', 60000.00, 'Pilot'),
('S056', 'Benjamin Lee', '5050 Elm Avenue, Dallas, USA', '0978903234', 87000.00, 'Crew'),
('S057', 'Alexander Scott', '5151 Maple Road, Chicago, USA', '0981012345', 92000.00, 'Pilot'),
('S058', 'Charlotte Turner', '5252 Birch Drive, Miami, USA', '0990923456', 60000.00, 'Crew'),
('S059', 'Sophia Roberts', '5353 Pine Court, San Francisco, USA', '0901134507', 85000.00, 'Pilot'),
('S060', 'Lucas Wright', '5454 Oak Avenue, New York, USA', '0912315677', 92000.00, 'Crew'),
('S061', 'Maya Allen', '5555 Birch Boulevard, Washington DC, USA', '0923450781', 60000.00, 'Pilot'),
('S062', 'Evan Harris', '5656 Cedar Drive, Miami, USA', '0934461890', 87000.00, 'Crew'),
('S063', 'Chloe Martin', '5757 Palm Avenue, Chicago, USA', '0945578901', 60000.00, 'Pilot'),
('S064', 'James Young', '5858 Redwood Road, Paris, France', '0951789012', 92000.00, 'Crew'),
('S065', 'Emma White', '5959 Spruce Court, Dallas, USA', '0960890123', 85000.00, 'Pilot'),
('S066', 'Liam Scott', '6060 Willow Street, San Francisco, USA', '0970901234', 60000.00, 'Crew'),
('S067', 'Ava Roberts', '6161 Maple Lane, Miami, USA', '0989011345', 87000.00, 'Pilot'),
('S068', 'Ethan Adams', '6262 Birch Court, Washington DC, USA', '0990120456', 60000.00, 'Crew'),
('S069', 'Olivia Turner', '6363 Cedar Road, New York, USA', '0911233567', 92000.00, 'Pilot'),
('S070', 'Daniel Harris', '6464 Palm Boulevard, Dallas, USA', '0912345670', 87000.00, 'Crew'),
('S071', 'Benjamin Roberts', '6565 Redwood Street, Paris, France', '0923456780', 60000.00, 'Pilot'),
('S072', 'Charlotte White', '6666 Spruce Avenue, Miami, USA', '0934567891', 85000.00, 'Crew'),
('S073', 'Lucas Scott', '6767 Birch Drive, Washington DC, USA', '0945678901', 60000.00, 'Pilot'),
('S074', 'Chloe Young', '6868 Maple Road, San Francisco, USA', '0956789012', 87000.00, 'Crew'),
('S075', 'Liam Brown', '6969 Palm Avenue, Dallas, USA', '0967890123', 60000.00, 'Pilot'),
('S076', 'Megan Lee', '7070 Cedar Boulevard, Chicago, USA', '0978901234', 92000.00, 'Crew'),
('S077', 'Sophia Green', '7171 Birch Court, Paris, France', '0989012345', 85000.00, 'Pilot'),
('S078', 'Benjamin Adams', '7272 Maple Lane, Miami, USA', '0990123456', 60000.00, 'Crew');


INSERT INTO SCHEDULES (scheduleID, flightID, aircraftID, flightDate) VALUES
(1, '100', 'A001', '2019-01-10'),
(2, '112', 'A002', '2019-02-15'),
(3, '121', 'A003', '2019-03-12'),
(4, '122', 'A004', '2019-04-05'),
(5, '206', 'A005', '2019-05-20'),
(6, '330', 'A006', '2019-06-18'),
(7, '334', 'A007', '2019-07-07'),
(8, '335', 'A008', '2019-08-13'),
(9, '336', 'A009', '2019-09-09'),
(10, '337', 'A010', '2019-10-19'),
(11, '394', 'A011', '2019-11-25'),
(12, '395', 'A012', '2019-12-12'),
(13, '449', 'A013', '2019-03-15'),
(14, '930', 'A014', '2019-04-25'),
(15, '931', 'A015', '2019-06-10'),
(16, '932', 'A016', '2019-07-20'),
(17, '991', 'A017', '2019-08-17'),
(18, '992', 'A018', '2019-10-05'),
(19, '993', 'A019', '2019-11-01'),
(20, '994', 'A020', '2019-02-14'),
(21, '995', 'A021', '2019-04-18'),
(22, '996', 'A022', '2019-05-09'),
(23, '997', 'A023', '2019-07-30'),
(24, '998', 'A024', '2019-09-13'),
(25, '999', 'A025', '2019-11-22'),
(26, '1000', 'A026', '2019-01-27'),
(27, '1001', 'A027', '2019-03-03'),
(28, '1002', 'A028', '2019-05-08'),
(29, '1003', 'A029', '2019-07-15'),
(30, '1004', 'A030', '2019-09-25'),
(31, '1005', 'A031', '2019-10-03'),
(32, '1006', 'A032', '2019-12-18'),
(33, '1007', 'A033', '2019-03-10'),
(34, '1008', 'A034', '2019-06-29'),
(35, '1009', 'A035', '2019-08-14'),
(36, '1010', 'A036', '2019-11-04'),
(37, '1011', 'A037', '2019-12-01'),
(38, '1012', 'A038', '2019-02-22'),
(39, '1013', 'A039', '2019-04-07');



-- Nhập dữ liệu cho bảng BOOKINGS
INSERT INTO BOOKINGS (bookingID, customerID, flightID, bookingDate, seatClass, status) VALUES
('B001', '0009', '100', '2019-12-01', 'Economy', 'Confirmed'),
('B002', '0101', '112', '2019-12-02', 'Business', 'Confirmed'),
('B003', '0045', '121', '2019-12-03', 'Economy', 'Confirmed'),
('B004', '0012', '122', '2019-12-04', 'First Class', 'Pending'),
('B005', '0238', '206', '2019-12-05', 'Economy', 'Cancelled'),
('B006', '0397', '330', '2019-12-06', 'Business', 'Confirmed'),
('B007', '0582', '334', '2019-12-07', 'Economy', 'Confirmed'),
('B008', '0934', '335', '2019-12-08', 'First Class', 'Pending'),
('B009', '0091', '336', '2019-12-09', 'Business', 'Confirmed'),
('B010', '0314', '337', '2019-12-10', 'Economy', 'Cancelled'),
('B011', '0613', '394', '2019-12-11', 'Economy', 'Confirmed'),
('B012', '0586', '930', '2019-12-12', 'Business', 'Confirmed'),
('B013', '0422', '931', '2019-12-13', 'First Class', 'Pending'),
('B014', '0173', '932', '2019-12-14', 'Economy', 'Confirmed'),
('B015', '0485', '991', '2019-12-15', 'Business', 'Confirmed'),
('B016', '0531', '992', '2019-12-16', 'Economy', 'Cancelled'),
('B017', '0009', '100', '2019-12-01', 'Economy', 'Confirmed'),
('B018', '0101', '112', '2019-12-02', 'Business', 'Confirmed'),
('B019', '0045', '121', '2019-12-03', 'Economy', 'Confirmed'),
('B020', '0012', '122', '2019-12-04', 'First Class', 'Pending'),
('B021', '0238', '206', '2019-12-05', 'Economy', 'Cancelled'),
('B022', '0397', '330', '2019-12-06', 'Business', 'Confirmed'),
('B023', '0582', '334', '2019-12-07', 'Economy', 'Confirmed'),
('B024', '0934', '335', '2019-12-08', 'First Class', 'Pending'),
('B025', '0091', '336', '2019-12-09', 'Business', 'Confirmed'),
('B026', '0314', '337', '2019-12-10', 'Economy', 'Cancelled'),
('B027', '0613', '394', '2019-12-11', 'Economy', 'Confirmed'),
('B028', '0586', '930', '2019-12-12', 'Business', 'Confirmed'),
('B029', '0422', '931', '2019-12-13', 'First Class', 'Pending'),
('B030', '0173', '932', '2019-12-14', 'Economy', 'Confirmed'),
('B031', '0485', '991', '2019-12-15', 'Business', 'Confirmed'),
('B032', '0531', '992', '2019-12-16', 'Economy', 'Cancelled'),
('B033', '0422', '993', '2019-12-17', 'Economy', 'Confirmed'),
('B034', '0613', '994', '2019-12-18', 'Business', 'Confirmed'),
('B035', '0586', '995', '2019-12-19', 'First Class', 'Pending'),
('B036', '0397', '996', '2019-12-20', 'Economy', 'Confirmed'),
('B037', '0523', '997', '2019-12-21', 'Economy', 'Confirmed'),
('B038', '0563', '998', '2019-12-22', 'Business', 'Confirmed'),
('B039', '0582', '999', '2019-12-23', 'First Class', 'Pending'),
('B040', '0633', '1000', '2019-12-24', 'Economy', 'Confirmed'),
('B041', '0724', '1001', '2019-12-25', 'Business', 'Confirmed'),
('B042', '0801', '1002', '2019-12-26', 'Economy', 'Confirmed'),
('B043', '0801', '1003', '2019-12-27', 'Economy', 'Cancelled'),
('B044', '0643', '1004', '2019-12-28', 'First Class', 'Confirmed'),
('B045', '0721', '1005', '2019-12-29', 'Economy', 'Confirmed'),
('B046', '0724', '1006', '2019-12-30', 'Business', 'Confirmed'),
('B047', '0792', '1007', '2019-12-31', 'Economy', 'Pending'),
('B048', '0518', '1008', '2019-01-01', 'First Class', 'Confirmed'),
('B049', '0792', '1009', '2019-01-02', 'Business', 'Confirmed');


INSERT INTO ASSIGNMENTS (staffID, scheduleID) VALUES
('S001', 1),
('S002', 2),
('S003', 3),
('S004', 4),
('S005', 5),
('S006', 6),
('S007', 7),
('S008', 8),
('S009', 9),
('S010', 10),
('S011', 11),
('S012', 12),
('S013', 13),
('S014', 14),
('S015', 15),
('S016', 16),
('S017', 17),
('S018', 18),
('S019', 19),
('S020', 20),
('S021', 21),
('S022', 22),
('S023', 23),
('S024', 24),
('S025', 25),
('S026', 26),
('S027', 27),
('S028', 28),
('S029', 29),
('S030', 30),
('S031', 31),
('S032', 32),
('S033', 33),
('S034', 34),
('S035', 35),
('S036', 36),
('S037', 37),
('S038', 38),
('S039', 39),
('S040', 1),
('S041', 2),
('S042', 3),
('S043', 4),
('S044', 5),
('S045', 6),
('S046', 7),
('S047', 8),
('S048', 9),
('S049', 10),
('S050', 11),
('S051', 12),
('S052', 13),
('S053', 14),
('S054', 15),
('S055', 16),
('S056', 17),
('S057', 18),
('S058', 19),
('S059', 20),
('S060', 21),
('S061', 22),
('S062', 23),
('S063', 24),
('S064', 25),
('S065', 26),
('S066', 27),
('S067', 28),
('S068', 29),
('S069', 30),
('S070', 31),
('S071', 32),
('S072', 33),
('S073', 34),
('S074', 35),
('S075', 36),
('S076', 37),
('S077', 38),
('S078', 39);


-- Nhập thông tin cho bảng SKILLS
INSERT INTO SKILLS (staffID, typeID) VALUES
('S001', 'B737'),
('S002', 'A320'),
('S003', 'B777'),
('S004', 'E175'),
('S005', 'A330'),
('S006', 'CRJ700'),
('S007', 'B757'),
('S008', 'A350'),
('S009', 'B747'),
('S010', 'A321'),
('S011', 'B737'),
('S012', 'A320'),
('S013', 'B787'),
('S014', 'CRJ200'),
('S015', 'E190'),
('S016', 'A220'),
('S017', 'B737'),
('S018', 'A330'),
('S019', 'B767'),
('S020', 'A340'),
('S021', 'B777'),
('S022', 'B747'),
('S023', 'A320'),
('S024', 'CRJ900'),
('S025', 'B757'),
('S026', 'A350'),
('S027', 'B737'),
('S028', 'A320'),
('S029', 'B737'),
('S030', 'E175'),
('S031', 'CRJ700'),
('S032', 'B787'),
('S033', 'A321'),
('S034', 'B777'),
('S035', 'A320'),
('S036', 'B757'),
('S037', 'A350'),
('S038', 'CRJ900'),
('S039', 'B747'),
('S040', 'B737'),
('S041', 'A320'),
('S042', 'B777'),
('S043', 'E175'),
('S044', 'A330'),
('S045', 'CRJ700'),
('S046', 'B757'),
('S047', 'A350'),
('S048', 'B747'),
('S049', 'A321'),
('S050', 'B737'),
('S051', 'A320'),
('S052', 'B787'),
('S053', 'CRJ200'),
('S054', 'E190'),
('S055', 'A220'),
('S056', 'B737'),
('S057', 'A330'),
('S058', 'B767'),
('S059', 'A340'),
('S060', 'B777'),
('S061', 'B747'),
('S062', 'A320'),
('S063', 'CRJ900'),
('S064', 'B757'),
('S065', 'A350'),
('S066', 'B737'),
('S067', 'A320'),
('S068', 'B737'),
('S069', 'E175'),
('S070', 'CRJ700'),
('S071', 'B787'),
('S072', 'A321'),
('S073', 'B777'),
('S074', 'A320'),
('S075', 'B757'),
('S076', 'A350'),
('S077', 'CRJ900'),
('S078', 'B747');