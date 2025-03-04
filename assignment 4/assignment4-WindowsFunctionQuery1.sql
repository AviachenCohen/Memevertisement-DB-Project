SELECT
   	DISTINCT c.Username,
   	[Rank based on memes created] = DENSE_RANK() OVER(ORDER BY mc.MemeCount DESC),
   	[Rank Based on Seniority] = NTILE(2) OVER(ORDER BY c.JoinDate DESC),
   	[Memes Created] = COUNT(m.Username) OVER(PARTITION BY c.Username),
   	[AVG memes Created] = AVG(mc.MemeCount) OVER(),
   	MostMemes = MAX(mc.MemeCount) OVER(),
   	DeviatesFromMost = mc.MemeCount - MAX(mc.MemeCount) OVER(),
   	LeastMemes = MIN(mc.MemeCount) OVER(),
   	[Deviates From Least] = mc.MemeCount - MIN(mc.MemeCount) OVER()
 
FROM MEMES AS m
   	JOIN CUSTOMERS AS c ON m.Username = c.Username
   	JOIN (SELECT  distinct Username, COUNT(Meme) AS MemeCount FROM MEMES
          	GROUP BY Username) AS mc ON mc.Username = m.Username
