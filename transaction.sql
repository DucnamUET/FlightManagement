USE FlightManagement;
-- Bắt đầu giao dịch
START TRANSACTION;

-- Thêm một khách hàng mới vào bảng CUSTOMERS
INSERT INTO CUSTOMERS (customerID, name, address, phone, email, dateOfBirth) 
VALUES ('C001', 'Nguyễn Văn A', 'Hà Nội, Việt Nam', '0123456789', 'nguyenvana@example.com', '1990-05-20');

-- Lưu lại trạng thái hiện tại của giao dịch (Savepoint)
SAVEPOINT BeforeBooking;

-- Thêm một đơn đặt vé vào bảng BOOKINGS
INSERT INTO BOOKINGS (bookingID, customerID, flightID, bookingDate, seatClass, status)
VALUES ('B001', 'C001', 'FL123', '2024-12-09', 'Economy', 'Confirmed');

-- Giả sử có lỗi xảy ra (ví dụ: vé này không thể đặt được hoặc khách hàng đã tồn tại)
-- Ở đây tôi giả sử chuyến bay 'FL123' không tồn tại trong bảng FLIGHTS, nên sẽ gây lỗi

-- Để mô phỏng lỗi, tôi sẽ cố tình thêm chuyến bay không tồn tại
-- Lệnh này sẽ tạo lỗi vì chuyến bay 'FL999' không có trong bảng FLIGHTS
INSERT INTO BOOKINGS (bookingID, customerID, flightID, bookingDate, seatClass, status)
VALUES ('B002', 'C001', 'FL999', '2024-12-09', 'Business', 'Confirmed');

-- Nếu có lỗi xảy ra, quay lại Savepoint để hủy các thao tác sau điểm lưu (Savepoint)
ROLLBACK TO SAVEPOINT BeforeBooking;
COMMIT;



