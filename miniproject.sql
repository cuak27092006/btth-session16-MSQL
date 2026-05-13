DROP DATABASE CarRentalManagement; 
CREATE DATABASE CarRentalManagement;
USE CarRentalManagement;

-- PHẦN 1
CREATE TABLE Vehicles (
    vehicle_id VARCHAR(10) PRIMARY KEY,
    vehicle_name VARCHAR(100) NOT NULL,
    vehicle_type ENUM('Sedan', 'SUV', 'Van', 'Hatchback') NOT NULL,
    daily_rate DECIMAL(12,2) NOT NULL CHECK (daily_rate > 0),
    status ENUM('Available', 'Rented', 'Maintenance') DEFAULT 'Available'
);
CREATE TABLE Clients (
    client_id VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    citizen_id VARCHAR(20) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    register_date DATE DEFAULT (CURRENT_DATE)
);
CREATE TABLE Rentals (
    rental_id VARCHAR(10) PRIMARY KEY,
    client_id VARCHAR(10),
    vehicle_id VARCHAR(10),
    start_date DATE NOT NULL,
    expected_return_date DATE NOT NULL,
    total_amount DECIMAL(12,2) CHECK (total_amount >= 0),
    status ENUM('Active', 'Completed', 'Cancelled') DEFAULT 'Active',
	FOREIGN KEY (client_id)REFERENCES Clients(client_id),
	FOREIGN KEY (vehicle_id)REFERENCES Vehicles(vehicle_id)
);
CREATE TABLE Payments (
	payment_id VARCHAR(10) PRIMARY KEY,
    rental_id VARCHAR(10),
    payment_date DATE NOT NULL,
    amount DECIMAL(12,2) NOT NULL CHECK (amount > 0),
    method ENUM('Cash', 'Card', 'Transfer') NOT NULL,
	FOREIGN KEY (rental_id)REFERENCES Rentals(rental_id)
);
CREATE TABLE Maintenance_Logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id VARCHAR(10),
    description VARCHAR(255),
    maintenance_date DATE NOT NULL,
    cost DECIMAL(12,2) DEFAULT 0 CHECK (cost >= 0),
	FOREIGN KEY (vehicle_id)REFERENCES Vehicles(vehicle_id)
);
INSERT INTO Vehicles
VALUES
('V001', 'Toyota Vios', 'Sedan', 700000, 'Available'),
('V002', 'Hyundai Tucson', 'SUV', 1200000, 'Rented'),
('V003', 'Ford Transit', 'Van', 1800000, 'Available'),
('V004', 'Mazda CX5', 'SUV', 1300000, 'Maintenance'),
('V005', 'Kia Morning', 'Hatchback', 500000, 'Available');

INSERT INTO Clients
VALUES
('C001', 'Nguyen Van An', '001199900001', '0901112223', '2024-01-15'),
('C002', 'Tran Thi Bich', '001198800002', '0988877766', '2024-06-20'),
('C003', 'Le Hoang Nam', '001200000003', '0903334445', '2025-03-10'),
('C004', 'Nguyen Minh Duc', '001199500004', '0355556667', '2023-12-05'),
('C005', 'Pham Thu Ha', '001200100005', '0779998881', '2026-01-01');


INSERT INTO Rentals
VALUES
('R001', 'C001', 'V002', '2025-01-10', '2025-01-15', 6000000, 'Active'),
('R002', 'C002', 'V001', '2025-02-05', '2025-02-08', 2100000, 'Completed'),
('R003', 'C003', 'V003', '2025-03-12', '2025-03-15', 5400000, 'Completed'),
('R004', 'C004', 'V005', '2024-12-20', '2024-12-22', 1000000, 'Completed'),
('R005', 'C005', 'V004', '2026-01-05', '2026-01-10', 6500000, 'Cancelled');


INSERT INTO Payments
VALUES
('P001', 'R002', '2025-02-08', 2100000, 'Cash'),
('P002', 'R003', '2025-03-15', 5400000, 'Transfer'),
('P003', 'R004', '2024-12-22', 1000000, 'Card'),
('P004', 'R001', '2025-01-10', 3000000, 'Transfer'),
('P005', 'R005', '2026-01-05', 2000000, 'Cash');

INSERT INTO Maintenance_Logs
(log_id, vehicle_id, description, maintenance_date, cost)
VALUES
(1, 'V004', 'Bao duong dong co', '2025-12-01', 1500000),
(2, 'V001', 'Thay dau may', '2023-11-15', 300000),
(3, 'V003', 'Kiem tra phanh', '2024-05-20', 700000),
(4, 'V005', 'Ve sinh noi that', '2023-10-10', 200000),
(5, 'V002', 'Sua dieu hoa', '2025-01-05', 900000);

UPDATE Vehicles
SET daily_rate = daily_rate *1.10
WHERE vehicle_type = 'SUV';

DELETE FROM Maintenance_Logs
WHERE cost < 500000
AND maintenance_date < '2024-01-01';

-- PHẦN 2
-- CÂU 1
SELECT *
FROM Rentals
WHERE  '2025-01-01'< start_date
AND start_date < '2025-03-31';

-- CÂU 2
SELECT full_name, phone_number
FROM Clients
WHERE full_name LIKE 'Nguyen%'
AND register_date < '2025-01-01';

-- CÂU 3
SELECT *
FROM Payments
ORDER BY amount DESC
LIMIT 4 OFFSET 2;

-- PHẦN 3
-- CÂU 1
SELECT 
	v.vehicle_name,
    v.vehicle_type,
    r.start_date,
    r.total_amount
FROM Vehicles v
LEFT JOIN Rentals r
ON v.vehicle_id = r.vehicle_id;
-- CÂU 2

-- CÂU 3


-- PHẦN 4
-- CÂU 1
CREATE INDEX idx_rental_dates
ON Rentals(start_date, expected_return_date);
-- CÂU 2

-- PHẦN 5
-- CÂU 1
DELIMITER //
CREATE TRIGGER trg_after_payment_insert
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
    UPDATE Rentals
    SET status = 'Completed'
    WHERE rental_id = NEW.rental_id;
    UPDATE Vehicles
    SET status = 'Available'
    WHERE vehicle_id = (
        SELECT vehicle_id
        FROM Rentals
        WHERE rental_id = NEW.rental_id
    );

END //
DELIMITER ;

-- CÂU 2
DELIMITER //
CREATE TRIGGER trg_prevent_delete_active_client
BEFORE DELETE ON Clients
FOR EACH ROW
BEGIN

END //
DELIMITER 

-- PHẦN 6
-- CÂU 1
DELIMITER //
CREATE PROCEDURE sp_get_vehicle_availability(
    IN p_vehicle_id VARCHAR(10),
    OUT p_message VARCHAR(50)
)
BEGIN


END //
DELIMITER ;

-- CÂU 2
DELIMITER //
CREATE PROCEDURE sp_create_rental_transaction(
	IN p_client_id VARCHAR(10),
	IN p_vehicle_id VARCHAR(10),
	IN p_rental_days INT,
	OUT p_message VARCHAR(100)

)
BEGIN


END //
DELIMITER ;