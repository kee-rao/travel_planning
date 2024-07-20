CREATE TABLE USER(
    username varchar(30),
    user_id varchar(15) primary key,
    email varchar(30),
    password varchar(20) NOT NULL,
    phno bigint
);
CREATE TABLE DESTINATION
(
    DESTINATION_ID INT AUTO_INCREMENT PRIMARY KEY,
    Dest_NAME VARCHAR(50),
    COUNTRY VARCHAR(20),
    DESCRIPTION TEXT,
    POPULARITY INT
);
CREATE TABLE FLIGHT(
    FLIGHT_ID INT AUTO_INCREMENT PRIMARY KEY,
    DEPARTURE_DATE DATE,
    RETURN_DATE DATE,
    DEPARTURE_TIME TIME, -- Added for departure time
    RETURN_TIME TIME,
    PRICE DECIMAL(10,2),
    AIRLINE VARCHAR(40),
    DESTINATION_ID INT,
    AVAIL_SEATS INT,
    FOREIGN KEY (DESTINATION_ID) REFERENCES Destination(DESTINATION_ID)
);
CREATE TABLE ACCOMMODATION(
    ACCOMMODATION_ID INT AUTO_INCREMENT PRIMARY KEY,
    ACCOMODATION_NAME VARCHAR(30),
    PRICE_PER_NIGHT DECIMAL(10,2),
    AVAIL_ROOMS INT,
    DESTINATION_ID INT,
    FOREIGN KEY(DESTINATION_ID) REFERENCES DESTINATION(DESTINATION_ID)
);
CREATE TABLE acc_res(
    Reservation_ID INT AUTO_INCREMENT PRIMARY KEY,
    ACCOMMODATION_ID INT,
    USER_ID VARCHAR(15),
    NO_ROOMS INT,
    CHECK_IN_DATE DATE,
    CHECK_OUT_DATE DATE,
    price decimal(10,2),
    FOREIGN KEY (ACCOMMODATION_ID) REFERENCES ACCOMMODATION(ACCOMMODATION_ID),
    FOREIGN KEY (USER_ID) REFERENCES USER(USER_ID)
);
CREATE TABLE flight_res (
    flight_resID INT AUTO_INCREMENT PRIMARY KEY,
    User_ID Varchar(15),
    Flight_ID INT,
    TotalPrice DECIMAL(10, 2),
    no_tickets int,
    FOREIGN KEY (User_ID) REFERENCES User(User_id),
    FOREIGN KEY (Flight_ID) REFERENCES Flight(Flight_ID)
);

--inserting records into destination
INSERT INTO DESTINATION (Dest_NAME, COUNTRY, DESCRIPTION, POPULARITY)
VALUES 
('Paris', 'France', 'The capital city of France, known for its art, fashion, and culture. Home to the Eiffel Tower and the Louvre Museum.', 95),
('Tokyo', 'Japan', 'A bustling metropolis with a unique blend of modern skyscrapers and historic temples. Famous for its cuisine and technology.', 90),
('New York City', 'USA', 'Known as "The Big Apple," it is a major cultural and financial center. Attractions include Times Square, Central Park, and the Statue of Liberty.', 88),
('Sydney', 'Australia', 'A vibrant city known for the Sydney Opera House, the Harbour Bridge, and beautiful beaches.', 85),
('Rome', 'Italy', 'The capital city of Italy, rich in history and home to the Colosseum, the Vatican City, and many ancient ruins.', 87),
('Barcelona', 'Spain', 'A city known for its art and architecture, including the works of Antoni Gaudí such as the Sagrada Familia.', 83),
('Dubai', 'UAE', 'A city known for its ultramodern architecture, luxury shopping, and lively nightlife scene. Home to the Burj Khalifa.', 80),
('Cape Town', 'South Africa', 'Known for its stunning landscapes, including Table Mountain and beautiful beaches. A cultural hub with a rich history.', 78),
('Rio de Janeiro', 'Brazil', 'Famous for its Carnival festival, the Christ the Redeemer statue, and its beautiful beaches like Copacabana and Ipanema.', 82),
('Istanbul', 'Turkey', 'A city that straddles Europe and Asia, known for its historic sites such as the Hagia Sophia, the Blue Mosque, and the Grand Bazaar.', 84);

INSERT INTO ACCOMMODATION (ACCOMODATION_NAME, PRICE_PER_NIGHT, AVAIL_ROOMS, DESTINATION_ID)
VALUES 
('Hotel Eiffel', 20500.00, 15, 1),
('Parisian Inn', 12300.00, 20, 1),
('Luxury Suites Paris', 32800.00, 10, 1),

('Tokyo Plaza Hotel', 16400.00, 25, 2),
('Sakura Inn', 9840.00, 30, 2),
('Shinjuku Grand Hotel', 28700.00, 12, 2),

('Manhattan Hotel', 24600.00, 18, 3),
('NYC Boutique Inn', 14760.00, 22, 3),
('Empire State Hotel', 36900.00, 8, 3),

('Sydney Harbour Hotel', 18040.00, 20, 4),
('Bondi Beach Resort', 13940.00, 25, 4),
('Sydney Opera Suites', 28700.00, 10, 4),

('Rome City Hotel', 17220.00, 15, 5),
('Colosseum Inn', 14760.00, 18, 5),
('Vatican View Hotel', 26240.00, 9, 5),

('Barcelona Central', 15580.00, 20, 6),
('Gaudí Hotel', 12300.00, 25, 6),
('Barcelona Beach Resort', 24600.00, 12, 6),

('Dubai Marina Hotel', 22960.00, 22, 7),
('Palm Jumeirah Resort', 36900.00, 10, 7),
('Burj Khalifa Suites', 41000.00, 8, 7),

('Cape Town Lodge', 13120.00, 18, 8),
('Table Mountain Hotel', 18040.00, 15, 8),
('Cape Town Beach Resort', 22960.00, 12, 8),

('Rio Beach Hotel', 16400.00, 20, 9),
('Copacabana Inn', 12300.00, 25, 9),
('Christ the Redeemer Suites', 24600.00, 10, 9),

('Istanbul Grand Hotel', 14760.00, 22, 10),
('Blue Mosque Inn', 12300.00, 20, 10),
('Hagia Sophia Suites', 20500.00, 12, 10);

--inserting records into flight
INSERT INTO FLIGHT (DEPARTURE_DATE, RETURN_DATE, DEPARTURE_TIME, RETURN_TIME, PRICE, AIRLINE, DESTINATION_ID, AVAIL_SEATS)
VALUES 
('2024-08-01', '2024-08-08', '10:00:00', '15:00:00', 37500.00, 'Air France', 1, 200),
('2024-08-02', '2024-08-09', '11:30:00', '16:30:00', 36000.00, 'Lufthansa', 1, 200),
('2024-08-03', '2024-08-10', '09:45:00', '14:45:00', 39000.00, 'British Airways', 1, 200),
('2024-08-05', '2024-08-12', '12:00:00', '17:00:00', 45000.00, 'Japan Airlines', 2, 200),
('2024-08-06', '2024-08-13', '13:30:00', '18:30:00', 43500.00, 'ANA', 2, 200),
('2024-08-07', '2024-08-14', '11:15:00', '16:15:00', 46500.00, 'Singapore Airlines', 2, 200),
('2024-08-10', '2024-08-17', '08:00:00', '13:00:00', 52500.00, 'Delta Airlines', 3, 200), 
('2024-08-11', '2024-08-18', '09:30:00', '14:30:00', 51000.00, 'American Airlines', 3, 200),
('2024-08-12', '2024-08-19', '07:45:00', '12:45:00', 54000.00, 'United Airlines', 3, 200),
('2024-08-15', '2024-08-22', '14:00:00', '19:00:00', 41250.00, 'Qantas', 4, 200),
('2024-08-16', '2024-08-23', '15:30:00', '20:30:00', 39750.00, 'Virgin Australia', 4, 200),
('2024-08-17', '2024-08-24', '13:45:00', '18:45:00', 42750.00, 'Emirates', 4, 200),
('2024-08-20', '2024-08-27', '09:00:00', '14:00:00', 36000.00, 'Alitalia', 5, 200),
('2024-08-21', '2024-08-28', '10:30:00', '15:30:00', 34500.00, 'Lufthansa', 5, 200),
('2024-08-22', '2024-08-29', '08:45:00', '13:45:00', 37500.00, 'Air France', 5, 200),
('2024-08-25', '2024-09-01', '11:00:00', '16:00:00', 39000.00, 'Iberia', 6, 200),
('2024-08-26', '2024-09-02', '12:30:00', '17:30:00', 37500.00, 'Vueling', 6, 200),
('2024-08-27', '2024-09-03', '10:45:00', '15:45:00', 40500.00, 'British Airways', 6, 200),
('2024-08-30', '2024-09-06', '18:00:00', '23:00:00', 48750.00, 'Emirates', 7, 200),
('2024-08-31', '2024-09-07', '19:30:00', '00:30:00', 47250.00, 'Etihad Airways', 7, 200),
('2024-09-01', '2024-09-08', '17:45:00', '22:45:00', 50250.00, 'Qatar Airways', 7, 200),
('2024-09-05', '2024-09-12', '20:00:00', '01:00:00', 45000.00, 'South African Airways', 8, 200),
('2024-09-06', '2024-09-13', '21:30:00', '02:30:00', 43500.00, 'British Airways', 8, 200),
('2024-09-07', '2024-09-14', '19:45:00', '00:45:00', 46500.00, 'KLM', 8, 200),
('2024-09-10', '2024-09-17', '06:00:00', '11:00:00', 52500.00, 'LATAM Airlines', 9, 200),
('2024-09-11', '2024-09-18', '07:30:00', '12:30:00', 51000.00, 'Azul Brazilian Airlines', 9, 200),
('2024-09-12', '2024-09-19', '05:45:00', '10:45:00', 54000.00, 'GOL Airlines', 9, 200),
('2024-09-15', '2024-09-22', '16:00:00', '21:00:00', 41250.00, 'Turkish Airlines', 10, 200),
('2024-09-16', '2024-09-23', '17:30:00', '22:30:00', 39750.00, 'Pegasus Airlines', 10, 200),
('2024-09-17', '2024-09-24', '15:45:00', '20:45:00', 42750.00, 'Lufthansa', 10, 200);

