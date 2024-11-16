Drop DATABASE ProApp;
CREATE DATABASE ProApp;
USE ProApp;

CREATE TABLE CUSTOMER (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Full_name CHAR(50),
    Email CHAR(100),
    Mobile CHAR(20)
);

INSERT INTO CUSTOMER (Full_name, Email, Mobile) VALUES
('Rizky Adi', 'rizky.adi@example.com', '08123456789'),
('Siti Nurhaliza', 'siti.nurhaliza@example.com', '08223334455'),
('Andi Putra', 'andi.putra@example.com', '08334455667'),
('Budi Santoso', 'budi.santoso@example.com', '08445566778'),
('Dewi Ayu', 'dewi.ayu@example.com', '08556677889');

CREATE TABLE TASKER (
    TaskerID INT PRIMARY KEY AUTO_INCREMENT,
    Full_name VARCHAR(100),
    Mobile VARCHAR(15),
    Email CHAR(100),
    Specialization VARCHAR(100),
    Background TEXT,          -- Allows for detailed descriptions
    Membership VARCHAR(50)    -- Stores "Tradespeople" or "Supplier"
);

INSERT INTO TASKER (Full_name, Mobile, Email, Specialization, Background, Membership) VALUES
('Rina Sari', '0817-8901-2345', 'rina.sari@example.com', 'Cleaner', 
 '6 years of experience in residential and commercial cleaning services', 
 'Tradespeople'),
('Siti Nurhaliza', '0818-9012-3456', 'siti.nurhaliza@example.com', 'Early Childcare Educator', 
 'Currently studying Bachelor of Early Childhood, 6 months of experience in childcare field ', 
 'Tradespeople'),
('Andi Budi', '0819-0123-4567', 'andi.budi@example.com', 'Gardener', 
 '4 years of experience in providing cleaning services for homes and businesses.', 
 'Tradespeople'),
('Joko Widodo', '0820-1234-5678', 'joko.widodo@example.com', 'Plumber', 
 '8 years of experience in plumbing installation and repairs', 
 'Tradespeople'),
('Lina Maharani', '0821-2345-6789', 'lina.maharani@example.com', 'Handyman', 
 '5 years of experience in general repairs and home maintenance', 
 'Tradespeople');

CREATE TABLE SERVICE (
    ServiceID INT AUTO_INCREMENT PRIMARY KEY,
    TaskerID INT,
    Category VARCHAR(100),
    FOREIGN KEY (TaskerID) REFERENCES TASKER(TaskerID)
);

INSERT INTO SERVICE (TaskerID,Category) VALUES
(1, 'Cleaning'),
(NULL, 'Cleaning'),
(NULL, 'Childcare'),
(4, 'Plumbing'),
(5, 'Assembly'),
(NULL, 'Gardening');

CREATE TABLE Request (
    CustomerID INT NOT NULL,
    ServiceID INT NOT NULL,
    Request_Time DATETIME NOT NULL,
    PaymentAmount DECIMAL(15, 2),
    PaymentMethod CHAR(50),
    Review TEXT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    PRIMARY KEY (CustomerID, ServiceID)  -- Composite primary key
);

INSERT INTO Request (CustomerID, ServiceID, Request_Time, PaymentAmount, PaymentMethod, Review, Rating) VALUES
(3, 1, '2024-08-01 14:30:00', 2000000.00, 'Credit', 'Great service!', 5),
(4, 2, '2024-09-30 14:30:00', NULL, NULL, NULL, NULL),   
(1, 3, '2024-09-30 09:00:00', NULL, NULL, NULL, NULL), 
(5, 4, '2024-09-10 10:00:00', 7500000.00, 'Credit', 'Not bad, but I was expecting a bit more.', 4), 
(4, 5, '2024-05-10 12:00:00', 1000000.00, 'Debit', 'Satisfactory service.', 4),
(2, 6, '2024-10-05 12:00:00', NULL, NULL, NULL, NULL);

CREATE TABLE TASK (
    TaskID INT AUTO_INCREMENT PRIMARY KEY,
    ServiceID INT,
    TaskerID INT,
    Task_Status ENUM('Open', 'Assigned', 'Completed'),
    StartDate DATE,
    EndDate DATE,
    Task_Description TEXT,
    Location TEXT,
    Budget DECIMAL(15, 2),
    FOREIGN KEY (ServiceID) REFERENCES SERVICE(ServiceID),
    FOREIGN KEY (TaskerID) REFERENCES TASKER(TaskerID)
);

INSERT INTO TASK (ServiceID, TaskerID, Task_Status, StartDate, EndDate, Task_Description, Location, Budget) VALUES
(1, 1, 'Completed','2024-08-05', '2024-08-06', 'End-of-lease cleaning for a rental property', 
 'Jl. Merdeka No. 10, Jakarta', 2050000.00), 
(2, 1, 'Assigned', '2024-10-07','2024-10-10', 'Cleaning for new office', 
 'Jl. Kebon Jeruk No. 25, Bandung', 3000000.00),  
(3, NULL, 'Open','2024-10-01','2023-10-09', 'Provide childcare service for 2 boys aged 3 and 5 during school holiday', 
 'Jl. Pahlawan No. 45, Jakarta', 4200000.00), 
(4, 4, 'Completed','2024-9-12', '2024-9-12', 'Fix leaking pipes and general repairs', 
 'Jl. Raya No. 30, Surabaya', 7500000.00),  
(5, 5, 'Completed','2024-5-15', '2024-5-16', 'Assemble new office furniture', 
 'Jl. Bunga No. 15, Surabaya', 1100000.00),
 (6, 3, 'Assigned', '2024-10-07','2024-10-10', 'Create a new vegetable garden in the backyard', 
 'Jl. Kebon Jeruk No. 25, Bandung', 3000000.00); 
 
CREATE TABLE BID (
    BidID INT AUTO_INCREMENT PRIMARY KEY,
    TaskID INT,
    TaskerID INT,
    CustomerID INT,
    Bid_Amount DECIMAL(10, 2),
    Submission_Time DATETIME NOT NULL,
    Status ENUM('Approved', 'Pending', 'Rejected'),
    FOREIGN KEY (TaskID) REFERENCES TASK(TaskID),
    FOREIGN KEY (TaskerID) REFERENCES TASKER(TaskerID),
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);

INSERT INTO BID (TaskID, TaskerID, CustomerID, Bid_Amount, Submission_Time, Status) VALUES
(1, 1, 3, 2000000.00, '2024-08-03 12:00:00', 'Approved'),  
(2, 3, 1, 3000000.00, '2024-10-01 10:00:00', 'Approved'),  
(4, 4, 5, 7500000.00, '2024-09-11 09:00:00', 'Approved'), 
(5, 5, 4, 1000000.00, '2024-05-13 15:00:00', 'Approved'),
(6, 3, 2, 2500000.00, '2024-10-06 15:00:00', 'Approved'),  
(5, 2, 4, 900000.00, '2024-05-11 11:00:00', 'Rejected');    

# Customer Return Rate
SELECT 
    (COUNT(DISTINCT ReturningCustomers.CustomerID) / COUNT(DISTINCT R.CustomerID)) * 100 AS Customer_Return_Rate
FROM 
    REQUEST R
LEFT JOIN 
    (SELECT CustomerID 
     FROM REQUEST 
     GROUP BY CustomerID 
     HAVING COUNT(ServiceID) > 1) ReturningCustomers ON R.CustomerID = ReturningCustomers.CustomerID;

# Average customer rating for services?
SELECT AVG(Rating) AS Average_Rating
FROM Request;
 
# Task Completetion Rate = request/completed
SELECT 
    COUNT(*) AS Total_Requests,
    SUM(CASE WHEN T.Task_Status = 'Completed' THEN 1 ELSE 0 END) AS Total_Completed_Tasks,
    SUM(CASE WHEN T.Task_Status = 'Completed' THEN 1 ELSE 0 END) * 100 / NULLIF(COUNT(*), 0) AS Rate_in_Percentage
FROM 
    Request R
LEFT JOIN 
    TASK T ON R.ServiceID = T.ServiceID;
    
# Bid Rate
SELECT 
    AVG(TotalBid) AS Average_Bids_Per_Task
FROM (
    SELECT 
        TaskID,
        COUNT(BidID) AS TotalBid
    FROM 
        BID
    GROUP BY 
        TaskID
) AS BidsPerTask;


# Average time of btw posting and receiving the 1st bid? 
SELECT 
    AVG(TIMESTAMPDIFF(SECOND, R.Request_Time, B.First_Submission_Time)) / 86400 AS Average_Waiting_Time_In_Days
FROM 
    Request R
JOIN (
    SELECT 
        TaskID,
        MIN(Submission_Time) AS First_Submission_Time
    FROM 
        BID
    GROUP BY 
        TaskID
) B ON R.ServiceID = B.TaskID;
