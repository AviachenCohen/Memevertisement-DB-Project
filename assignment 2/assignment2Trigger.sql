
CREATE	TRIGGER 	LastMemeCreatedAt_AND_TotalMemes
ON 		MEMES		FOR 	INSERT, UPDATE, DELETE
AS
UPDATE	CUSTOMERS 
SET 		LastMemeCreatedAt =  (
			SELECT  MAX(M.CreationDT) 
			FROM    MEMES AS M
			WHERE   M.Username = CUSTOMERS.Username),
			TotalMemes = (
			SELECT  COUNT(M.Meme) 
			FROM    MEMES AS M
			WHERE   M.Username = CUSTOMERS.Username
				)
WHERE 	Username IN (
			SELECT DISTINCT Username from INSERTED
			UNION
			SELECT DISTINCT Username from DELETED)	
