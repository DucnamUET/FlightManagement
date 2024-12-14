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





