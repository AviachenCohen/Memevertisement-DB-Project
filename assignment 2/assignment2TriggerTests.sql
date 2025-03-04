

-- TESTING TRIGGER:			
-- RESETTING MEMES AND USERNAME FOR TEST
DELETE FROM MEMES WHERE Username = 'AviaIsTheBest' 
DELETE FROM CUSTOMERS WHERE Username = 'AviaIsTheBest' 

-- Adding new customer
INSERT INTO CUSTOMERS (Username, Password, PlanName, Email, FirstName, LastName, BirthDate, JoinDate, CreditCardNumber, LastMemeCreatedAt, TotalMemes) 
		Values ('AviaIsTheBest', 8843838, 'Free', 'aviacoheen@gmail.com', 'Avia', 'Cohen', '3/24/1995', '1/1/2022', '1234123412341234',NULL, NULL)
--SHOW  NEW CUSTOMER
SELECT * FROM CUSTOMERS WHERE Username = 'AviaIsTheBest'
							
-- Adding new memes (Show case when inserting 2 record simultaneously)
INSERT INTO MEMES(Meme, Username, TemplateID, CreationDT, FileSize, TotalCustomizationsTextBox, TotalCustomizationsImage)
VALUES (4143, 'AviaIsTheBest', 82, '1/3/2022 10:34:09 AM', 450, 1, 2),(4144, 'AviaIsTheBest', 81, '1/2/2022 12:29:10 PM', 450, 1, 2)
--SHOW NEW CUSTOMER LAST CREATED MEME
SELECT * FROM CUSTOMERS WHERE Username = 'AviaIsTheBest'

-- Adding new meme
INSERT INTO MEMES(Meme, Username, TemplateID, CreationDT, FileSize, TotalCustomizationsTextBox, TotalCustomizationsImage)
VALUES (4146, 'AviaIsTheBest', 97, '2/4/22 11:35:15 AM', 300, 2, 3)
--SHOW NEW CUSTOMER LAST CREATED MEME
SELECT * FROM CUSTOMERS WHERE Username = 'AviaIsTheBest'

-- adding meme with old date
INSERT INTO MEMES(Meme, Username, TemplateID, CreationDT, FileSize, TotalCustomizationsTextBox, TotalCustomizationsImage)
VALUES (4145, 'AviaIsTheBest', 97, '1/4/22 17:27:32 PM', 300, 2, 3)
--SHOW NEW CUSTOMER LAST CREATED MEME
--NOTE: meme 4146 datetime is still the newest, even though theoretically it dosen't make sense that meme 4145 will be added after 4146, just for check
SELECT * FROM CUSTOMERS WHERE Username = 'AviaIsTheBest'

-- deleting last meme created
DELETE FROM MEMES WHERE Meme = 4146
--SHOW NEW CUSTOMER LAST CREATED MEME
SELECT * FROM CUSTOMERS WHERE Username = 'AviaIsTheBest'
									
-- delete from archive memes
DELETE FROM ARCHIVE_MEMES WHERE ARCHIVE_MEMES.Username = 'AviaIsTheBest'