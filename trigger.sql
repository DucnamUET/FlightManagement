USE FlightManagement;
-- Trigger 1: Cập nhật trạng thái đơn đặt vé khi chuyến bay bị hủy
DELIMITER $$

CREATE TRIGGER update_booking_status_on_flight_cancel
AFTER UPDATE ON FLIGHTS
FOR EACH ROW
BEGIN
    -- Kiểm tra xem chuyến bay có bị hủy (status = 'Cancelled') không
    IF NEW.departureDate <> OLD.departureDate AND NEW.arrivalDate <> OLD.arrivalDate THEN
        -- Cập nhật trạng thái của tất cả các đơn đặt vé liên quan
        UPDATE BOOKINGS
        SET status = 'Cancelled'
        WHERE flightID = OLD.flightID AND status = 'Confirmed';
    END IF;
END$$

DELIMITER ;

-- Trigger 2: Giới hạn số lượng vé đặt cho mỗi chuyến bay
DELIMITER $$

CREATE TRIGGER limit_booking_capacity
BEFORE INSERT ON BOOKINGS
FOR EACH ROW
BEGIN
    DECLARE flight_capacity INT;
    DECLARE booked_seats INT;

    -- Lấy số lượng ghế tối đa của chuyến bay từ bảng AIRCRAFTS
    SELECT capacity INTO flight_capacity
    FROM AIRCRAFTS
    WHERE aircraftID = (SELECT aircraftID FROM FLIGHTS WHERE flightID = NEW.flightID);

    -- Lấy số lượng ghế đã được đặt cho chuyến bay
    SELECT COUNT(*) INTO booked_seats
    FROM BOOKINGS
    WHERE flightID = NEW.flightID AND status = 'Confirmed';

    -- Nếu số lượng ghế đã đặt >= số ghế tối đa, không cho phép đặt vé mới
    IF booked_seats >= flight_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể đặt vé. Số ghế cho chuyến bay này đã đầy.';
    END IF;
END$$

DELIMITER ;

