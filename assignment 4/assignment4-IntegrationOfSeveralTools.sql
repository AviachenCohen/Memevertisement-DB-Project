-- ASSIGNMENT 4 - COMBINATION OF TOOLS 

-- TRIGER FOR DELETED LIKES
CREATE TRIGGER Deleted_Likes_Data 
	ON LIKES
	FOR DELETE
AS
	INSERT INTO ARCHIVE_LIKES
	SELECT *
	FROM DELETED

-- TRIGGER FOR DELETED HASHTAGS
CREATE TRIGGER Archived_Hashtags_Data
	ON HASHTAGS
	FOR DELETE
AS
	INSERT INTO ARCHIVE_HASHTAGS
	SELECT * FROM DELETED

-- TRIGER FOR DELETED SHARES
CREATE TRIGGER Deleted_Shares_Data 
	ON SHARES
	FOR DELETE
AS
	INSERT INTO ARCHIVE_SHARES
	SELECT *
	FROM DELETED

-- TRIGER FOR DELETED MEMES
CREATE TRIGGER Archived_Memes_Data
		ON MEMES
		FOR DELETE
AS
	INSERT INTO ARCHIVE_MEMES
	SELECT   *, DeleteDT = getdate()
	FROM DELETED

-- FUNCTION FOR LEAVING/FROZEN CUSTOMERS DATA
CREATE FUNCTION Archived_Customers_Data (@Username VARCHAR(50))
RETURNS TABLE
AS	RETURN
	SELECT C.Username, LeaveDT = getdate(), 
			C.PlanName, C.Email, C.FirstName, C.LastName, C.BirthDate, C.JoinDate,
			TotalMemes = C.TotalMemes + (	SELECT COUNT (AM.Meme)
									FROM ARCHIVE_MEMES AS AM
									WHERE AM.Username = @Username AND AM.CreationDT > C.JoinDate)
	FROM CUSTOMERS AS C 
	WHERE C.Username = @Username

	
-- TEST FOR FUNCTION
SELECT *
	FROM dbo.Archived_Customers_Data('AviaIsTheBest')


--SP FOR DELETING CUSTOMERS
CREATE PROCEDURE SP_DELETE_CUSTOMER @Username VARCHAR(50)
AS
BEGIN	 
	INSERT INTO ARCHIVE_CUSTOMERS
	SELECT *
	FROM dbo.Archived_Customers_Data(@Username)
	DELETE	FROM LIKES -- DELETE ALL LIKES OTHER USERES GAVE TO THIS USERNAME ON SHARES TO SITE SOCIAL NETWORK
			WHERE LIKES.Meme IN (	SELECT M.Meme
									FROM MEMES AS M 
									WHERE M.Username = @Username )
	DELETE	FROM LIKES -- DELETE ALL LIKES MADE BY THIS USER
			WHERE LIKES.Username = @Username

	DELETE	FROM HASHTAGS
			WHERE HASHTAGS.Meme IN (SELECT M.Meme 
								FROM MEMES AS M 
								WHERE M.Username = @Username
								)
	DELETE	FROM SHARES
			WHERE SHARES.Meme IN (	SELECT M.Meme
									FROM MEMES AS M 
									WHERE M.Username = @Username ) 
	DELETE FROM PROPERTIES
	WHERE PROPERTIES.Meme IN (	SELECT M.Meme
								FROM MEMES AS M
								WHERE M.Username = @Username)
	DELETE FROM TEXTBOXES
	WHERE TEXTBOXES.Meme IN (	SELECT M.Meme
								FROM MEMES AS M
								WHERE M.Username = @Username)
	DELETE FROM IMAGES
	WHERE IMAGES.Meme IN (	SELECT M.Meme
								FROM MEMES AS M
								WHERE M.Username = @Username)
	DELETE FROM CUSTOMIZATIONS
	WHERE CUSTOMIZATIONS.Meme IN (	SELECT M.Meme
								FROM MEMES AS M
								WHERE M.Username = @Username)
	DELETE	FROM MEMES 
			WHERE MEMES.Username = @Username
	DELETE	FROM CUSTOMERS
			WHERE CUSTOMERS.Username = @Username
END


-- TESTING SP
EXECUTE SP_DELETE_CUSTOMER '_beans_';
