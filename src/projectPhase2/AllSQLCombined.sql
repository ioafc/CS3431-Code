CREATE TABLE Employee (
                          ID NUMBER PRIMARY KEY,
                          FName VARCHAR(50) NOT NULL,
                          LName VARCHAR(50) NOT NULL,
                          Salary DECIMAL(10, 2) NOT NULL CHECK ( Salary >= 0 ),
                          jobTitle VARCHAR(100) NOT NULL,
                          OfficeNum NUMBER,
                          empRank NUMBER NOT NULL CHECK ( empRank IN (0,1,2)), -- Rank of the employee: 0 for Regular, 1 for Division Manager, 2 for General Manager
                          SupervisorID NUMBER,
                          AddressStreet VARCHAR(100) NOT NULL,
                          AddressCity VARCHAR(50) NOT NULL,
                          CONSTRAINT supervisorID_fk FOREIGN KEY (SupervisorID) REFERENCES Employee(ID)
);

CREATE TABLE Doctor (
                        EmployeeID NUMBER PRIMARY KEY,
                        Gender CHAR(1) NOT NULL CHECK ( Gender IN ('M', 'F')),
                        Specialty VARCHAR(100) NOT NULL,
                        GraduatedFrom VARCHAR(100) NOT NULL,
                        CONSTRAINT empID_fk FOREIGN KEY (EmployeeID) REFERENCES Employee(ID)
);

CREATE TABLE EquipmentTechnician (
                                     EmployeeID NUMBER PRIMARY KEY,
                                     CONSTRAINT empIDTech_fk FOREIGN KEY (EmployeeID) REFERENCES Employee(ID)
);

CREATE TABLE EquipmentType (
                               TypeID NUMBER PRIMARY KEY,
                               Description VARCHAR(255) NOT NULL,
                               Model VARCHAR(50) NOT NULL,
                               Instructions CLOB, -- CLOB is a character large object in Oracle SQL
                               NumberOfUnits NUMBER NOT NULL CHECK ( NumberOfUnits >= 0 )
);

CREATE TABLE CanRepairEquipment (
                                    EmployeeID NUMBER,
                                    EquipmentType NUMBER,
                                    CONSTRAINT canRepairEquipmentPK PRIMARY KEY (EmployeeID, EquipmentType),
                                    CONSTRAINT empIDCanRepair_fk FOREIGN KEY (EmployeeID) REFERENCES Employee(ID),
                                    CONSTRAINT eqType_fk FOREIGN KEY (EquipmentType) REFERENCES EquipmentType(TypeID)
);

CREATE TABLE Room (
                      Num NUMBER PRIMARY KEY,
                      OccupiedFlag CHAR(1) NOT NULL CHECK ( OccupiedFlag IN ('Y', 'N') )   -- Indicates if the room is occupied
);

CREATE TABLE Equipment (
                           SerialNum VARCHAR(50) PRIMARY KEY,
                           TypeID NUMBER NOT NULL,
                           PurchaseYear NUMBER NOT NULL,
                           LastInspection DATE,
                           RoomNumber NUMBER,
                           CONSTRAINT typeID_fk FOREIGN KEY (TypeID) REFERENCES EquipmentType(TypeID),
                           CONSTRAINT roomNUM_fk FOREIGN KEY (RoomNumber) REFERENCES ROOM(Num)
);

CREATE TABLE RoomService (
                             RoomNum NUMBER,
                             Service VARCHAR(250) NOT NULL, -- description of the service
                             CONSTRAINT roomService_pk PRIMARY KEY (RoomNum, Service),
                             CONSTRAINT roomServiceRoomNUM_fk FOREIGN KEY (RoomNum) REFERENCES Room(Num)
);

CREATE TABLE RoomAccess (
                            RoomNum NUMBER,
                            EmployeeID NUMBER,
                            CONSTRAINT roomAccess_pk PRIMARY KEY (RoomNum, EmployeeID),
                            CONSTRAINT roomAccessRoomNUM_fk FOREIGN KEY (RoomNum) REFERENCES Room(Num),
                            CONSTRAINT roomAccessEmpID_fk FOREIGN KEY (RoomNum) REFERENCES Employee(ID)
);

CREATE TABLE Patient (
                         PatientSSN CHAR(11) PRIMARY KEY,
                         PatientFName VARCHAR(50) NOT NULL,
                         PatientLName VARCHAR(50) NOT NULL,
                         PatientAddress VARCHAR(255) NOT NULL,
                         PatientTelNum VARCHAR(20)
);

CREATE TABLE Admission (
                           AdmissionNum NUMBER PRIMARY KEY,
                           AdmissionDate DATE NOT NULL,
                           LeaveDate DATE,
                           TotalPayment NUMBER(10,2) NOT NULL CHECK ( TotalPayment >= 0 ),
                           InsurancePayment NUMBER(10,2) NOT NULL CHECK ( InsurancePayment >= 0 ),
                           PatientSSN CHAR(11) NOT NULL,
                           FutureVisitDate DATE,
                           CONSTRAINT admittedPatientSSN_fk FOREIGN KEY (PatientSSN) REFERENCES Patient(PatientSSN)
);

CREATE TABLE Examine (
                         DoctorID NUMBER,
                         AdmissionNUM NUMBER,
                         ExamComment CLOB NOT NULL, -- assume each examination must have some comment related to it
                         CONSTRAINT examination_pk PRIMARY KEY (DoctorID, AdmissionNUM),
                         CONSTRAINT examiningDoctorID_fk FOREIGN KEY (DoctorID) REFERENCES Doctor(EmployeeID),
                         CONSTRAINT examinationAdmissionNum_fk FOREIGN KEY (AdmissionNUM) REFERENCES Admission(AdmissionNum)
);

CREATE TABLE StayIn (
                        AdmissionNum NUMBER,
                        RoomNum NUMBER,
                        StartDate DATE NOT NULL,
                        EndDate DATE NOT NULL, -- assume since we are in a hospital, knowing duration of stay (start and end) is crucial
                        CONSTRAINT stayIn_pk PRIMARY KEY (AdmissionNum, RoomNum, StartDate),

                        CONSTRAINT stayInRoomAdmissionNum_fk FOREIGN KEY (AdmissionNum) REFERENCES Admission(AdmissionNum),
                        CONSTRAINT stayInRoomNum_fk FOREIGN KEY (RoomNum) REFERENCES Room(Num) -- not entirely sure.---------------------------
);

-- Adding patients
INSERT INTO PATIENT (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES ('124-12-4545', 'John', 'smith', '3-pname', '1234567890');
INSERT INTO PATIENT (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('123-45-6789', 'John', 'Doe', '123 Elm St', '555-1234');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('234-56-7890', 'Jane', 'Smith', '456 Oak St', '555-2345');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('345-67-8901', 'Emily', 'Brown', '789 Pine St', '555-3456');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('456-78-9012', 'Michael', 'Johnson', '101 Maple St', '555-4567');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('567-89-0123', 'David', 'Williams', '202 Cedar St', '555-5678');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('678-90-1234', 'Sarah', 'Jones', '303 Birch St', '555-6789');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('789-01-2345', 'Chris', 'Miller', '404 Spruce St', '555-7890');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('890-12-3456', 'Anna', 'Davis', '505 Redwood St', '555-8901');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('901-23-4567', 'James', 'Garcia', '606 Walnut St', '555-9012');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('012-34-5678', 'Karen', 'Martinez', '707 Ash St', '555-0123');

SELECT* FROM PATIENT;