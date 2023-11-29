/*----------------------------------------------Column Data Encryption----------------------------*/

USE marketplace;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StudentMarketplace_damg6210';

SELECT name KeyName,
symmetric_key_id KeyID,
key_length KeyLength,
algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;


USE marketplace;
GO
CREATE CERTIFICATE Certificatepass WITH SUBJECT = 'Protect Student Marketplace data';
GO

SELECT name CertName, 
    certificate_id CertID, 
    pvt_key_encryption_type_desc EncryptType, 
    issuer_name Issuer
FROM sys.certificates;

CREATE SYMMETRIC KEY Certificatepass_SM
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE Certificatepass;
GO

select * from marketplace.dbo.STUDENT ;

ALTER TABLE marketplace.dbo.STUDENT ADD Email_encrypt varbinary(MAX);
ALTER TABLE marketplace.dbo.STUDENT ADD Phone_encrypt varbinary(MAX);
ALTER TABLE marketplace.dbo.[USER] ADD Payment_Info_encrypt varbinary(MAX);

select * from [USER];

/**************************************** Personally Identifiable Information - Email & Phone Column Encryption & Decryption ***********************************/

/*Encryption Email column*/ -- Run One time only
OPEN SYMMETRIC KEY Certificatepass_SM DECRYPTION BY CERTIFICATE Certificatepass;

UPDATE marketplace.dbo.STUDENT
        SET Email_encrypt = EncryptByKey (Key_GUID('Certificatepass_SM'), Email)
        FROM marketplace.dbo.STUDENT;
        GO

CLOSE SYMMETRIC KEY Certificatepass_SM;

/*-- Drop the old column
ALTER TABLE marketplace.dbo.Student
DROP COLUMN Email;

-- Rename the new column to a temporary name
EXEC sp_rename 'marketplace.dbo.Student.Email_encrypt', 'Email_Temp', 'COLUMN';

-- Rename the column to the original name
EXEC sp_rename 'marketplace.dbo.Student.Email_Temp', 'Email', 'COLUMN';



SELECT * FROM STUDENT;*/

/*Encrypt Phone*/ -- Run One time only

OPEN SYMMETRIC KEY Certificatepass_SM DECRYPTION BY CERTIFICATE Certificatepass;

UPDATE marketplace.dbo.STUDENT 
        SET Phone_encrypt = EncryptByKey (Key_GUID('Certificatepass_SM'), Phone)
        FROM marketplace.dbo.STUDENT;
        GO

CLOSE SYMMETRIC KEY Certificatepass_SM;

/**************************************** Phone & Email Column Decryption ************************************/

/* Decryption Phone & Email */

OPEN SYMMETRIC KEY Certificatepass_SM
        DECRYPTION BY CERTIFICATE Certificatepass;

SELECT Student_ID, First_Name, Last_Name, Date_of_Birth, Address, Zip_Code, Email AS 'Encrypted Email', Phone AS 'Encrypted Phone',Age ,
            CONVERT(varchar, DecryptByKey(Email)) AS 'Decrypted Email',CONVERT(varchar, DecryptByKey(Phone)) AS 'Decrypted Phone'
            FROM STUDENT;

CLOSE SYMMETRIC KEY Certificatepass_SM;


/**************************************** Payment Info Column Encryption & Decryption ***********************************/

/*Payment info to Encryption */ -- Run One time only

OPEN SYMMETRIC KEY Certificatepass_SM DECRYPTION BY CERTIFICATE Certificatepass;

UPDATE marketplace.dbo.[USER]
        SET Payment_Info_encrypt = EncryptByKey (Key_GUID('Certificatepass_SM'), Payment_Info)
        FROM marketplace.dbo.[USER];
        GO

CLOSE SYMMETRIC KEY Certificatepass_SM;

/*Decryption Payment Info Column*/

OPEN SYMMETRIC KEY Certificatepass_SM
        DECRYPTION BY CERTIFICATE Certificatepass;

SELECT Account_ID, User_ID,Shipping_Address,Payment_Info AS 'Encrypted Payment Info' ,
            CONVERT(varchar, DecryptByKey(Payment_Info)) AS 'Decrypted Payment Info'
            FROM [USER];

CLOSE SYMMETRIC KEY Certificatepass_SM;


--SELECT * FROM [user];