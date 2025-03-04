
-- VIEW(VIEW SITE SOCIAL NETWORK VS FACEBOOK) 
CREATE VIEW V_SSN_VS_FB AS
	SELECT M.Username, [Total Memes] = COUNT (DISTINCT M.Meme),
	[Facebook Shares] = FB_S.FBSHARE, [Site SM Share] = SITE_S.SHARE
	FROM MEMES AS M JOIN (	SELECT M.Username, FBSHARE = COUNT(DISTINCT S.Meme)
							FROM MEMES AS M JOIN SHARES AS S ON M.Meme = S.Meme
							WHERE S.Destination = 'Facebook'
							GROUP BY M.Username
						) AS FB_S ON M.Username = FB_S.Username
						JOIN  (SELECT M.Username, SHARE = COUNT(DISTINCT S.Meme)
								FROM MEMES AS M JOIN SHARES AS S ON M.Meme = S.Meme
								WHERE S.Destination = 'Site Social Network'
								GROUP BY M.Username
						) AS SITE_S ON FB_S.Username = SITE_S.Username
	GROUP BY M.Username, FB_S.FBSHARE, SITE_S.SHARE

-- using the view
SELECT V1.Username, V1.[Total Memes], GAP = V1.[Site SM Share] - V1.[Facebook Shares]
FROM V_SSN_VS_FB AS V1
ORDER BY GAP DESC