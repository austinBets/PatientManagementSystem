--Creates a table called Patients if one does not already exist.
IF NOT EXISTS(SELECT * FROM sys.tables  WHERE name='Patients')
BEGIN
    CREATE TABLE Patients (
        PatientID INT PRIMARY KEY,
        FirstName NVARCHAR(50),
        LastName NVARCHAR(50),
        DateOfBirth DATE,
        Gender NVARCHAR(100),
        Address NVARCHAR(50),
        PhoneNumber NVARCHAR(15)
    );
END;

--Creates a table called Doctors if one does not already exist.
IF NOT EXISTS(SELECT * FROM sys.tables WHERE name='Doctors')
BEGIN
    CREATE TABLE Doctors(
        DoctorID INT PRIMARY KEY,
        FirstName NVARCHAR(50),
        LastName NVARCHAR(50),
        Speciality NVARCHAR(50),
        PhoneNumber NVARCHAR(15)
    );
END;

--Creates a Table called Appointments if one does not already exist
IF NOT EXISTS(SELECT * FROM sys.tables WHERE name='Appointments')
BEGIN
    CREATE TABLE Appointments(
        AppointmentID INT PRIMARY KEY,
        PatientID INT,
        DoctorID INT,
        AppointmentDate DATE,
        Reason NVARCHAR(100),
        FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
        FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
    );
END;

--Creates a table called MedicalHistory if one does not already exist.
IF NOT EXISTS(SELECT * FROM sys.tables WHERE name='MedicalHistory')
BEGIN
    CREATE TABLE MedicalHistory(
      HistoryID INT PRIMARY KEY,
      PatientID INT,
      Diagnosis NVARCHAR(50),
      Treatment NVARCHAR(50),
      VisitDate DATE DEFAULT GETDATE(),
      FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    );
END;

