-- Procedure: Tạo đơn đặt vé
DELIMITER $$

CREATE PROCEDURE CreateBooking(
    IN p_customerID VARCHAR(10),
    IN p_flightID VARCHAR(10),
    IN p_seatClass VARCHAR(20)
)
BEGIN
    DECLARE flight_capacity INT;
    DECLARE booked_seats INT;
    DECLARE flight_status VARCHAR(20);

    -- Kiểm tra trạng thái chuyến bay
    SELECT departureDate, arrivalDate INTO flight_status
    FROM FLIGHTS
    WHERE flightID = p_flightID;

    -- Kiểm tra nếu chuyến bay đã bị hủy (status = 'Cancelled')
    IF flight_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Chuyến bay không tồn tại.';
    END IF;

    -- Kiểm tra số ghế đã đặt cho chuyến bay
    SELECT capacity INTO flight_capacity
    FROM AIRCRAFTS
    WHERE aircraftID = (SELECT aircraftID FROM FLIGHTS WHERE flightID = p_flightID);

    -- Lấy số ghế đã đặt cho chuyến bay
    SELECT COUNT(*) INTO booked_seats
    FROM BOOKINGS
    WHERE flightID = p_flightID AND status = 'Confirmed';

    -- Nếu số ghế đã đặt >= số ghế tối đa, không cho phép đặt vé mới
    IF booked_seats >= flight_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể đặt vé. Số ghế cho chuyến bay này đã đầy.';
    END IF;

    -- Thực hiện tạo đơn đặt vé mới
    INSERT INTO BOOKINGS (bookingID, customerID, flightID, bookingDate, seatClass, status)
    VALUES (CONCAT('B', LPAD((SELECT COUNT(*) + 1 FROM BOOKINGS), 5, '0')), p_customerID, p_flightID, CURDATE(), p_seatClass, 'Confirmed');
    
END$$

DELIMITER ;
