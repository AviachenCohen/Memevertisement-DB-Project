DROP VIEW IDK_Data
--view that shows each customer how many years hes been on site how much revenue we made from him and how many times he shared his memes in/outside of our websites social media and their total memes
CREATE OR ALTER VIEW Customer_Data_VIEW AS
SELECT
	c.Username,
	c.PlanName,
	c.JoinDate,
	YearsOnSite = DATEDIFF(YEAR, c.JoinDate, CURRENT_TIMESTAMP),
	Revenue = p.price*(DATEDIFF(YEAR, c.JoinDate, CURRENT_TIMESTAMP)+1),
	ns.NumShared,
	ups.OurSiteShares,
	TotalShares = ns.NumShared + ups.OurSiteShares,
	[Our site shares percent of total] =  CAST(ups.OurSiteShares*1.0/(ns.NumShared + ups.OurSiteShares) AS DECIMAL(5,2)),
	[Outside sources shares percent of total] = CAST(ns.NumShared*1.0/(ns.NumShared + ups.OurSiteShares) AS DECIMAL(5,2)),
	l1.NumOfLikes,
	l2.NumLikesGiven,
	c.TotalMemes
FROM CUSTOMERS AS c
JOIN PLANS AS p 
	ON p.Name = c.PlanName
JOIN (SELECT --How many times did a customer share outside our network?
		m.Username,
		NumShared = COUNT(s.Meme)
		FROM MEMES AS m
		JOIN SHARES AS s ON m.Meme = s.Meme
		WHERE s.Destination != 'Site Social Network'
		GROUP BY m.Username
		) AS ns
	ON ns.Username = c.Username
JOIN (SELECT -- how many times did a customer upload to our social network? if none then 0
		c.Username,
		 0 AS OurSiteShares
		FROM CUSTOMERS AS c
		WHERE c.Username NOT IN (
			SELECT
				m.Username
				FROM SHARES AS s
				JOIN MEMES AS m
					ON s.Meme = m.Meme
				WHERE s.Destination = 'Site Social Network'
				GROUP BY m.Username)
		UNION
		SELECT
				m.Username,
				COUNT(s.Meme) OurSiteShares
				FROM SHARES AS s
				JOIN MEMES AS m
				ON s.Meme = m.Meme
				WHERE s.Destination = 'Site Social Network'
				GROUP BY m.Username
	) AS ups
		ON ups.Username = c.Username
JOIN (SELECT --How many likes did a user get?
			m.Username,
			COUNT(l.Meme) AS NumOfLikes
		FROM LIKES AS l
		JOIN MEMES AS m
		ON l.Meme = m.Meme
		GROUP BY m.Username
		UNION
		SELECT
			m.Username,
			0 AS NumOfLikes
		FROM MEMES AS m
		WHERE m.Username NOT IN (
					SELECT
						m.Username
					FROM LIKES AS l
					JOIN MEMES AS m
						ON l.Meme = m.Meme
					GROUP BY m.Username
					)
		) AS l1
			ON l1.Username = c.Username
JOIN (SELECT --How many times did a user like something?
		c.Username,
		COUNT(l.Username) AS NumLikesGiven
		FROM CUSTOMERS AS c
		JOIN LIKES AS l
		ON l.Username = c.Username
		GROUP BY c.Username
	) AS l2
	ON l2.Username = c.Username
GO




SELECT * FROM MEMES
---- View to show all memes, their creator, creationDT, how many text boxes and images (and combined)

CREATE VIEW TableauMemesVIEW
AS
SELECT
	m.Meme,
	m.Username,
	c.PlanName,
	m.CreationDT,
	m.TemplateID,
	m.TotalCustomizationsTextBox,
	m.TotalCustomizationsImage,
	TotalCustomizations = m.TotalCustomizationsTextBox + m.TotalCustomizationsImage
FROM MEMES AS m
JOIN Customer_Data_VIEW AS c
	ON c.Username = m.Username
GO

CREATE OR ALTER VIEW MemeCategory_VIEW
AS
SELECT
	m.Meme,
	m.TemplateID,
	cat.Category,
	m.CreationDT
FROM TableauMemesVIEW AS m
JOIN CATEGORIES AS cat
	ON cat.TemplateID = m.TemplateID
GO

CREATE OR ALTER VIEW ShareCat_VIEW
AS
SELECT
	s.Meme,
	MemeCategory_VIEW.TemplateID,
	MemeCategory_VIEW.Category,
	s.ShareDT,
	s.Destination
FROM SHARES AS s
JOIN MemeCategory_VIEW
	ON MemeCategory_VIEW.Meme = s.Meme


CREATE VIEW V_Revenue_Per_Year AS
SELECT C.Username, C.PlanName, C.JoinDate, 
	[Revnue 2020] = case when (Datediff(yy, C.JoinDate, GETDATE())) = 3 then pp.Price else 0 end,
	[Revnue 2021] = case when (Datediff(yy, C.JoinDate, GETDATE())) >= 2 then pp.Price else 0 end,
	[Revnue 2022] = case when (Datediff(yy, C.JoinDate, GETDATE())) >= 1 then pp.Price else 0 end
FROM CUSTOMERS AS C JOIN (SELECT P.Name, P.Price
									FROM PLANS AS P ) AS PP ON PP.Name = C.PlanName
GROUP BY C.Username, C.PlanName, PP.Price, C.JoinDate

