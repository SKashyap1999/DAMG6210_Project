/*DML Trigger to Assign a Supervisor for newly added row in the Transaction Table */

CREATE TRIGGER update_supervisor_trigger
ON [TRANSACTION]
AFTER INSERT
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @v_supervisor_id INT;

  -- Find the supervisor employed at the time of the transaction
  SELECT @v_supervisor_id = Supervisor_ID
  FROM SUPERVISOR
  WHERE EXISTS (
    SELECT 1
    FROM INSERTED i
    WHERE i.Transaction_Date >= SUPERVISOR.Date_of_Employment
  );

  -- Update the Supervisor_ID in the inserted rows
  UPDATE t
  SET t.Supervisor_ID = @v_supervisor_id
  FROM [TRANSACTION] t
  JOIN INSERTED i ON t.Transaction_ID = i.Transaction_ID;
END;

-- Trigger should automatically assign Supervisor_ID to a New Transaction 
INSERT INTO [TRANSACTION] (Transaction_ID, Transaction_Date, Listing_ID, Transaction_Mode, User_ID, Supervisor_ID)
VALUES
  (28, '2024-03-01', 'Q17', 'DEBIT', 112, NULL);
  
  Select * from [TRANSACTION];