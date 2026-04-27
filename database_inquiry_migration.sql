-- to add INQUIRY FEATURE
-- Run after initial database.sql has been executed

USE vcunt_db;

-- TRIP (groups multiple Inquiries)
CREATE TABLE IF NOT EXISTS TRIP (
    Trip_ID             VARCHAR(12)  NOT NULL,
    Customer_Account_ID VARCHAR(12)  NOT NULL,
    Trip_Name           VARCHAR(100) NOT NULL,
    Planned_Start       DATETIME     DEFAULT NULL,
    Planned_End         DATETIME     DEFAULT NULL,
    Pickup_Location     VARCHAR(100) DEFAULT NULL,
    Drop_off_Location   VARCHAR(100) DEFAULT NULL,
    Created_Date        DATE         NOT NULL,
    PRIMARY KEY (Trip_ID),
    FOREIGN KEY (Customer_Account_ID) REFERENCES PERSON(Account_ID)
);

-- INQUIRY 
CREATE TABLE IF NOT EXISTS INQUIRY (
    Inquiry_ID               VARCHAR(12)   NOT NULL,
    Trip_ID                  VARCHAR(12)   DEFAULT NULL,
    Vehicle_ID               VARCHAR(12)   NOT NULL,
    Customer_Account_ID      VARCHAR(12)   NOT NULL,
    Owner_Account_ID         VARCHAR(12)   NOT NULL,
    Transaction_ID           VARCHAR(12)   DEFAULT NULL,   -- set once booked

    -- Rental details submitted by customer 
    Rental_Duration          INT           NOT NULL,
    Distance_KM              DECIMAL(10,2) DEFAULT NULL,
    Pickup_Location          VARCHAR(100)  DEFAULT NULL,
    Drop_off_Location        VARCHAR(100)  DEFAULT NULL,
    Start_Date               DATETIME      DEFAULT NULL,
    End_Date                 DATETIME      DEFAULT NULL,
    With_Driver              TINYINT(1)    DEFAULT 0,
    Customer_Message         VARCHAR(300)  DEFAULT NULL,

    -- Status 
    Inquiry_Status           VARCHAR(20)   DEFAULT 'Pending',

    -- Owner response 
    Owner_Response_Type      VARCHAR(10)   DEFAULT NULL,   -- 'range' | 'fixed'
    Owner_Price_Min          DECIMAL(10,2) DEFAULT NULL,   -- used when range
    Owner_Price_Max          DECIMAL(10,2) DEFAULT NULL,   -- used when range
    Owner_Set_Price          DECIMAL(10,2) DEFAULT NULL,   -- used when fixed
    Owner_Message            VARCHAR(300)  DEFAULT NULL,

    -- Customer counter 
    Customer_Decision        VARCHAR(20)   DEFAULT NULL,   -- 'accept' | 'decline' | 'negotiate'
    Customer_Counter_Price   DECIMAL(10,2) DEFAULT NULL,
    Customer_Counter_Message VARCHAR(300)  DEFAULT NULL,

    -- Agreed price (set on Confirmed) 
    Final_Agreed_Price       DECIMAL(10,2) DEFAULT NULL,

    Inquiry_Date             DATE          NOT NULL,
    Updated_At               DATETIME      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (Inquiry_ID),
    FOREIGN KEY (Trip_ID)             REFERENCES TRIP(Trip_ID) ON DELETE SET NULL,
    FOREIGN KEY (Vehicle_ID)          REFERENCES VEHICLE(Vehicle_ID),
    FOREIGN KEY (Customer_Account_ID) REFERENCES PERSON(Account_ID),
    FOREIGN KEY (Owner_Account_ID)    REFERENCES PERSON(Account_ID),
    FOREIGN KEY (Transaction_ID)      REFERENCES RENTAL_TRANSACTION(Transaction_ID),

    CHECK (Inquiry_Status IN ('Pending','Owner_Quoted','Negotiating','Confirmed','Cancelled','Booked')),
    CHECK (Owner_Response_Type IN ('range','fixed') OR Owner_Response_Type IS NULL),
    CHECK (Customer_Decision  IN ('accept','decline','negotiate') OR Customer_Decision IS NULL)
);

-- ID counters for new entities 
INSERT INTO ID_COUNTER (entity, last_num)
VALUES ('TRIP', 0), ('INQUIRY', 0)
ON DUPLICATE KEY UPDATE entity = entity;
