USE master;


--Adding data from patients CSV file to the patients table after checking to ensure data does not already exist
IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = 'Patient_Staging')
BEGIN
    CREATE TABLE Patient_Staging (
        PatientID INT PRIMARY KEY,
        FirstName NVARCHAR(50),
        LastName NVARCHAR(50),
        DateOfBirth DATE,
        Gender NVARCHAR(100),
        Address NVARCHAR(50),
        PhoneNumber NVARCHAR(15)
    );
END;

-- Ensure the table exists before attempting to use it
IF OBJECT_ID('Patient_Staging', 'U') IS NOT NULL
BEGIN
    BULK INSERT Patient_Staging
    FROM 'C:\Users\austi\PateintManagementSystem\data\Patients.csv'
    WITH (
        FIELDTERMINATOR = ',',  
        ROWTERMINATOR = '\n',   
        FIRSTROW = 2            
    );

    INSERT INTO Patients (PatientID, FirstName, LastName, DateOfBirth, Gender, Address, PhoneNumber)
    SELECT PatientID, FirstName, LastName, DateOfBirth, Gender, Address, PhoneNumber
    FROM Patient_Staging AS ps
    WHERE NOT EXISTS (
        SELECT 1
        FROM Patients AS p
        WHERE p.PhoneNumber = ps.PhoneNumber
    );

    TRUNCATE TABLE Patient_Staging;

END;

--Adding Data from Doctors.csv to the  Doctors data table
IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = 'Doctor_Staging')
BEGIN
    CREATE TABLE Doctor_Staging (
        DoctorID INT PRIMARY KEY,
        FirstName NVARCHAR(50),
        LastName NVARCHAR(50),
        Speciality NVARCHAR(50),
        PhoneNumber NVARCHAR(15)
    );
END;

-- Ensure the table exists before attempting to use it
IF OBJECT_ID('Doctor_Staging', 'U') IS NOT NULL
BEGIN
    BULK INSERT Doctor_Staging
    FROM 'C:\Users\austi\PateintManagementSystem\data\Doctors.csv'
    WITH (
        FIELDTERMINATOR = ',',  
        ROWTERMINATOR = '\n',   
        FIRSTROW = 2            
    );

    INSERT INTO Doctors (DoctorID, FirstName, LastName, Speciality, PhoneNumber)
    SELECT DoctorID, FirstName, LastName, Speciality, PhoneNumber
    FROM Doctor_Staging AS ds
    WHERE NOT EXISTS (
        SELECT 1
        FROM Doctors AS d
        WHERE d.PhoneNumber = ds.PhoneNumber
    );

    TRUNCATE TABLE Doctor_Staging;

END;

--Adding Data from Medical_History.csv to the Medical_History data table
IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = 'Medical_History_Staging')
BEGIN
    CREATE TABLE Medical_History_Staging (
        HistoryID INT PRIMARY KEY,
        PatientID INT,
        Diagnosis NVARCHAR(50),
        Treatment NVARCHAR(50),
        VisitDate DATE DEFAULT GETDATE()
    );
END;

-- Ensure the table exists before attempting to use it
IF OBJECT_ID('Medical_History_Staging', 'U') IS NOT NULL
BEGIN
    BULK INSERT Medical_History_Staging
    FROM 'C:\Users\austi\PateintManagementSystem\data\Medical_History.csv'
    WITH (
        FIELDTERMINATOR = ',',  
        ROWTERMINATOR = '\n',   
        FIRSTROW = 2            
    );

    INSERT INTO MedicalHistory (HistoryID, PatientID, Diagnosis, Treatment, VisitDate)
    SELECT HistoryID, PatientID, Diagnosis, Treatment, VisitDate
    FROM Medical_History_Staging AS MHS
    WHERE NOT EXISTS (
        SELECT 1
        FROM MedicalHistory AS MH
        WHERE MH.HistoryID = MHS.HistoryID
    );

    TRUNCATE TABLE Medical_History_Staging;

END;

--Adding Data from Appointments.csv to the Appointments data table
IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = 'Appointment_Staging')
BEGIN
    CREATE TABLE Appointment_Staging (
        AppointmentID INT PRIMARY KEY,
        PatientID INT,
        DoctorID INT,
        AppointmentDate DATE,
        Reason NVARCHAR(100)
    );
END;

-- Ensure the table exists before attempting to use it
IF OBJECT_ID('Appointment_Staging', 'U') IS NOT NULL
BEGIN
    BULK INSERT Appointment_Staging
    FROM 'C:\Users\austi\PateintManagementSystem\data\Appointments.csv'
    WITH (
        FIELDTERMINATOR = ',',  
        ROWTERMINATOR = '\n',   
        FIRSTROW = 2            
    );

    INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, AppointmentDate, Reason)
    SELECT AppointmentID, PatientID, DoctorID, AppointmentDate, Reason
    FROM Appointment_Staging AS ast
    WHERE NOT EXISTS (
        SELECT 1
        FROM Appointments AS a
        WHERE a.AppointmentID = ast.AppointmentID
    );

    TRUNCATE TABLE Appointment_Staging;

END;
