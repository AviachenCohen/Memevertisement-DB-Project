CREATE FUNCTION ReachedLikesTarget (@Username VARCHAR(50), @Target INT)
RETURNS TABLE
AS
RETURN
   	SELECT
   	c.Username, m.Meme, COUNT(l.Meme) AS LikeCount,
   	PercentOfTotal = CONVERT(DECIMAL(5,2),
                          		CONVERT(FLOAT,COUNT(L.Meme)) / CONVERT(FLOAT,( SELECT
                                 		COUNT(L.Meme) FROM LIKES AS l
                                 		JOIN MEMES AS m ON l.Meme = m.Meme
                    	             	WHERE m.Username = @Username))),
   	PassedTarget = CASE
                                 		WHEN COUNT(L.Meme) >= 10 THEN 'YES'
                                 		ELSE 'NO'
                          		END,
   	[Deviates from Target by] = COUNT(L.Meme) - @Target
   	FROM MEMES AS m JOIN LIKES AS l ON m.Meme = l.Meme
   	JOIN CUSTOMERS AS c ON c.Username = m.Username
   	WHERE m.Username = @Username AND c.PlanName != 'Free'
   	GROUP BY m.Meme, c.Username

SELECT * FROM dbo.ReachedLikesTarget('_beans_', 10)