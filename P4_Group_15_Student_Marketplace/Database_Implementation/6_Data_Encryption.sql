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

/*Encrypt Email*/
OPEN SYMMETRIC KEY Certificatepass_SM DECRYPTION BY CERTIFICATE Certificatepass;


UPDATE marketplace.dbo.STUDENT
       SET Email_encrypt = EncryptByKey (Key_GUID('Certificatepass_SM'), Email)
       FROM marketplace.dbo.STUDENT;
       GO


CLOSE SYMMETRIC KEY Certificatepass_SM;


/*UPDATE STUDENT
SET Email_encrypt = Email;*/


SELECT * FROM STUDENT;


/*Encrypt Phone*/
OPEN SYMMETRIC KEY Certificatepass_SM DECRYPTION BY CERTIFICATE Certificatepass;


UPDATE marketplace.dbo.STUDENT
       SET Phone_encrypt = EncryptByKey (Key_GUID('Certificatepass_SM'), Phone)
       FROM marketplace.dbo.STUDENT;
       GO


CLOSE SYMMETRIC KEY Certificatepass_SM;


/*Payment info to Encryption */
select * from [USER];


OPEN SYMMETRIC KEY Certificatepass_SM DECRYPTION BY CERTIFICATE Certificatepass;


UPDATE marketplace.dbo.[USER]
       SET Payment_Info_encrypt = EncryptByKey (Key_GUID('Certificatepass_SM'), Payment_Info)
       FROM marketplace.dbo.[USER];
       GO


CLOSE SYMMETRIC KEY Certificatepass_SM;
