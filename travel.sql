CREATE TABLE USER(
	name varchar(30),
    user_id varchar(15) primary key,
    email varchar(30),
    phno int
);
CREATE TABLE DESTINATION
(
	Dest_NAME VARCHAR(50) PRIMARY KEY,
    COUNTRY VARCHAR(20),
    CITY VARCHAR(20),
    POPULARITY INT
);
CREATE TABLE FLIGHT(
	FLIGHT_ID INT AUTO_INCREMENT PRIMARY KEY ,
    DEPARTURE_DATE DATE,
    RETURN_DATE DATE,
    PRICE DECIMAL(10,2),
    DEPARTURE_AIRPORT VARCHAR(20),
    DESTINATION_AIRPORT VARCHAR(20),
    NO_TRAVELLERS INT,
    AIRLINE VARCHAR(20),
	Destination_ID INT,
    FOREIGN KEY (Destination_ID) REFERENCES Destination(Destination_ID)
);
CREATE TABLE ACCOMMODATION
(
	ACCOMMODATION_ID VARCHAR(20) PRIMARY KEY,
    name varchar(30),
    check_in_date date,
    check_out_date date,
    price decimal(10,2),
    no_of_people INT,
    Dest_NAME VARCHAR(20),
    FOREIGN KEY (Dest_NAME) REFERENCES Destination(Dest_name)
);
CREATE TABLE Booking (
    Booking_ID INT PRIMARY KEY,
    User_ID INT,
    Accommodation_ID INT,
    Flight_ID INT,
    FROMDATE DATE,
    TODATE DATE,
    TotalPrice DECIMAL(10, 2),
    FOREIGN KEY (User_ID) REFERENCES User(User_id),
    FOREIGN KEY (Accommodation_ID) REFERENCES Accommodation(Accommodation_ID),
    FOREIGN KEY (Flight_ID) REFERENCES Flight(Flight_ID)
);

