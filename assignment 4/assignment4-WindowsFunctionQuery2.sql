SELECT
   	c.JoinedYear AS FiscalYear,
   	[Quarter] = CASE
                                	WHEN c.JoinedQuarter = 1 THEN 'Q1'
                                	WHEN c.JoinedQuarter = 2 THEN 'Q2'
                                	WHEN c.JoinedQuarter = 3 THEN 'Q3'
                                	ELSE 'Q4'
                         	END,
   	c.PlanName,
   	[New Q users] = c.[New users in quarter],
   	[Previous Q users] = LAG(c.[New users in quarter],2,0) OVER(ORDER BY c.JoinedYear),
   	[Diffrence cur and prev Q] = c.[New users in quarter] - LAG(c.[New users in quarter],2,0) OVER(ORDER BY c.JoinedYear),
   	[New yearly Users per plan] = c.[New Users Per Year],
   	[Total users for plan] =  0.25*SUM(c.[New Users Per Year]) OVER(PARTITION BY c.PlanName ORDER BY c.JoinedYear),
   	[Quarterly Revenue From Plan] = c.[New users in quarter]*P.Price,
   	[Yearly Revenue By Plan] = SUM(c.[New Users Per Year]*p.Price/4) OVER(PARTITION BY c.PlanName,c.JoinedYear),
   	[New Revenue for the YEAR] = SUM(CAST(0.25*p.Price*c.[New Users Per Year] AS DECIMAL(10,2))) OVER(PARTITION BY c.JoinedYear),
   	[Rolling Revenue] = SUM(c.[New users in quarter]*P.Price) OVER(ORDER BY c.JoinedYear, c.JoinedQuarter ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM (SELECT
          	PlanName,
          	YEAR(JoinDate) AS JoinedYear,
          	[New Users Per Year] = SUM(COUNT(YEAR(JoinDate))) OVER(PARTITION BY YEAR(JoinDate), PlanName),
          	[New users in quarter] = SUM(COUNT(DATEPART(QUARTER,JoinDate))) OVER(PARTITION BY YEAR(JoinDate), DATEPART(QUARTER, JoinDate), PlanName),
          	DATEPART(QUARTER, JoinDate) AS JoinedQuarter
   	FROM CUSTOMERS
   	WHERE PlanName != 'Free'
   	GROUP BY PlanName, YEAR(JoinDate), DATEPART(QUARTER, JoinDate)
   	) AS c
JOIN PLANS AS p ON c.PlanName = p.Name
GROUP BY c.PlanName, P.Price, c.JoinedYear,P.Price,c.JoinedQuarter, c.[New users in quarter], c.[New Users Per Year]
ORDER BY c.JoinedYear, c.JoinedQuarter, c.PlanName
GO
