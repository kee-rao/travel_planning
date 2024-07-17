CREATE TABLE USER(
    username varchar(30),
    user_id varchar(15) primary key,
    email varchar(30),
    password varchar(20) NOT NULL,
    phno int
);
CREATE TABLE DESTINATION
(
    DESTINATION_ID INT PRIMARY KEY,
    Dest_NAME VARCHAR(50),
    COUNTRY VARCHAR(20),
    DESCRIPTION TEXT,
    POPULARITY INT
);
CREATE TABLE FLIGHT(
    FLIGHT_ID INT AUTO_INCREMENT PRIMARY KEY,
    DEPARTURE_DATE DATE,
    RETURN_DATE DATE,
    PRICE DECIMAL(10,2),
    DEPARTURE_AIRPORT VARCHAR(20),
    DESTINATION_AIRPORT VARCHAR(20),
    NO_TRAVELLERS INT,
    AIRLINE VARCHAR(20),
    DESTINATION_ID INT,
    FOREIGN KEY (DESTINATION_ID) REFERENCES Destination(DESTINATION_ID)
);
CREATE TABLE ACCOMMODATION
(
    ACCOMMODATION_ID INT AUTO_INCREMENT PRIMARY KEY ,
    name varchar(30),
    check_in_date date,
    check_out_date date,
    price decimal(10,2),
    no_of_people INT,
    rooms INT,
    DESTINATION_ID INT,
    FOREIGN KEY (DESTINATION_ID) REFERENCES Destination(DESTINATION_ID)
);
CREATE TABLE Booking (
    Booking_ID INT AUTO_INCREMENT PRIMARY KEY ,
    User_ID Varchar(15),
    Accommodation_ID INT,
    Flight_ID INT,
    FROMDATE DATE,
    TODATE DATE,
    TotalPrice DECIMAL(10, 2),
    FOREIGN KEY (User_ID) REFERENCES User(User_id),
    FOREIGN KEY (Accommodation_ID) REFERENCES Accommodation(Accommodation_ID),
    FOREIGN KEY (Flight_ID) REFERENCES Flight(Flight_ID)
);
--adding user_id as foreign key to accommodation--
alter table accommodation
add column user_id(15);

alter table accommodation
add constraint fk_user
foreign key (user_id) references user(user_id);

-- Step 1: Add the User_ID column to the Flight table
ALTER TABLE Flight
ADD COLUMN User_ID VARCHAR(15);

-- Step 2: Add the foreign key constraint
ALTER TABLE Flight
ADD CONSTRAINT fk_flight_user
FOREIGN KEY (User_ID) REFERENCES User(User_id);
