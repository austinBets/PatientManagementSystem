--Selecting all rows and columns from the patients table
GO
SELECT * 
FROM Patients;

--Selecting all rows and columns from the Doctors table
GO
SELECT *
FROM Doctors;

--Selecting all rows and columns from the Medical History Table
GO
SELECT *
FROM MedicalHistory;

--Selecting all rows and columns from the Appointments Table
GO
SELECT *
FROM Appointments;

-- Retrieve patients along with their latest medical history (diagnosis and treatment).
WITH LatestMedicalHistory AS (
    SELECT 
        mh.PatientID,
        mh.Diagnosis,
        mh.Treatment,
        mh.VisitDate,
        ROW_NUMBER() OVER (PARTITION BY mh.PatientID ORDER BY mh.VisitDate DESC) AS RowNum
    FROM 
        MedicalHistory mh
)
SELECT 
    p.PatientID,
    p.FirstName,
    p.LastName,
    p.Gender,
    lmh.Diagnosis AS Diagnosis,
    lmh.Treatment AS Treatment
FROM 
    Patients p
LEFT JOIN 
    LatestMedicalHistory lmh ON p.PatientID = lmh.PatientID AND lmh.RowNum = 1;

--Retrieves the patients name (first and last) and the doctors name (first and last) using the 
SELECT
    p.PatientID AS PatientID,
    p.FirstName AS PatientFirstName,
    p.LastName AS PatientLastName,
    d.FirstName AS DoctorFirstName,
    d.LastName AS DoctorLastName,
    d.Speciality AS Speciality
FROM
    Patients p
INNER JOIN
    Appointments a ON p.PatientID = a.PatientID
INNER JOIN
    Doctors d ON a.DoctorID = d.DoctorID;

--Retrieves the patients name, and their diagnois from the Patients table and the MedicalHistory table 
SELECT
    p.FirstName AS PatientFirstName,
    p.LastName AS PatientLastName,
    mh.Diagnosis AS Diagnosis,
    d.FirstName AS DoctorFirstName,
    d.LastName AS DoctorsLastName,
    d.Speciality AS DoctorsSpeciality
FROM
    Patients p
INNER JOIN
    Appointments a ON p.PatientID = a.PatientID
INNER JOIN
    Doctors d ON a.DoctorID = D.DoctorID
LEFT JOIN
    MedicalHistory mh ON p.PatientID = mh.PatientID;