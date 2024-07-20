-- creating trigger to calculate total price for accommodation reservation
DELIMITER //

CREATE TRIGGER update_acc_res_price
BEFORE INSERT ON acc_res
FOR EACH ROW
BEGIN
    DECLARE acc_price DECIMAL(10, 2);
    DECLARE num_nights INT;

    -- Get the price per night from the accommodation table
    SELECT PRICE_PER_NIGHT INTO acc_price
    FROM ACCOMMODATION
    WHERE ACCOMMODATION_ID = NEW.ACCOMMODATION_ID;

    -- Calculate the number of nights
    SET num_nights = DATEDIFF(NEW.CHECK_OUT_DATE, NEW.CHECK_IN_DATE);

    -- Calculate the total price based on the number of rooms
    SET NEW.price = acc_price * num_nights * NEW.NO_ROOMS;
END //

DELIMITER ;

--trigger for updating available rooms 
DELIMITER //

CREATE TRIGGER update_available_rooms
AFTER INSERT ON acc_res
FOR EACH ROW
BEGIN
    UPDATE ACCOMMODATION
    SET AVAIL_ROOMS = AVAIL_ROOMS - NEW.NO_ROOMS
    WHERE ACCOMMODATION_ID = NEW.ACCOMMODATION_ID;
END //

DELIMITER ;

