--ASSIGNMENT 1

-- query 1
-- which paying customers over 18 who uses the site for at least one year - shared over 10 memes they have created
SELECT [Name] = C.FirstName + ' ' + C.LastName,
	   C.Email,
	   C.PlanName,
	   TotalMemesShared = count (DISTINCT M.meme),
	   AGE = Datediff(yy, BirthDate, Getdate()), 
	   YearsOfMembership = Datediff(dd, JoinDate, Getdate()) / 365
FROM CUSTOMERS AS C JOIN MEMES AS M ON C.Username = M.Username
	JOIN SHARES AS S ON S.Meme = M.Meme
WHERE C.PlanName = 'Pro' OR C.PlanName = 'Business'
GROUP BY C.Email, C.FirstName, C.LastName, C.BirthDate, C.JoinDate, C.PlanName
HAVING count (DISTINCT M.meme) > 10 AND (Datediff(dd, JoinDate, Getdate()) / 365) > 0 
ORDER BY TotalMemesShared DESC

-- query 2
-- top 5 templates for free customers
SELECT DISTINCT TOP 5 ST.StockTemplateID, ST.Usagecount 
FROM MEMES AS M JOIN STOCK_TEMPLATES AS ST ON M.TemplateID = ST.StockTemplateID
	JOIN PROPERTIES AS P ON P.Meme = M.Meme
WHERE P.PlanName = 'Free'
ORDER BY ST.Usagecount DESC

-- query 3
-- Nested select query 1 - which templates weren't used in 2022?
SELECT TemplateID
FROM TEMPLATES
WHERE TemplateID NOT IN (
						SELECT DISTINCT TemplateID
						FROM MEMES
						WHERE YEAR (CreationDT) = 2022
						)

-- query 4
-- Nested select query 2 - for each customer, how many times did he share in the year of 2022 his memes ?
SELECT M.Username, ShareCount = SUM(SC.SCount)
FROM MEMES AS M JOIN (	SELECT S.Meme, Scount = COUNT(S.Meme)  
						FROM SHARES AS S
						WHERE S.Destination != 'Download' AND YEAR (S.ShareDT) = 2022
						GROUP BY Meme) AS SC ON M.Meme = SC.Meme
GROUP BY M.Username
ORDER BY ShareCount DESC


-- query 5
-- Update query
UPDATE MEMES 
SET TotalCustomizationsTextBox = (	SELECT COUNT(DISTINCT T.TextboxID) 
									FROM TEXTBOXES AS T 
									WHERE MEMES.Meme = T.Meme 
								 ),		  
	TotalCustomizationsImage =   ( SELECT COUNT(DISTINCT I.ImageID) 
								   FROM IMAGES AS I   
								   WHERE MEMES.Meme = I.Meme
								 )
-- test: SELECT * FROM MEMES

-- query 6
-- intersect query - returns templates under "other" category from Uploaded templates that users under 18 used
SELECT M.TemplateID
FROM CATEGORIES AS C JOIN MEMES AS M ON C.TemplateID = M.TemplateID
WHERE C.Category = 'Other' AND M.TemplateID IN (SELECT UT.UploadTemplateID
																		FROM UPLOAD_TEMPLATES AS UT)
INTERSECT
SELECT M.TemplateID
FROM CUSTOMERS AS C JOIN MEMES AS M ON C.Username = M.Username
WHERE Datediff(yy, C.BirthDate, Getdate()) < 18 


