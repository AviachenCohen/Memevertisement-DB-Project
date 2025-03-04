

-- VIEW FOR ASSIGNMENT 3 - Business Report
-- First View: returns first schema of info about abandon customers, no specific order
CREATE VIEW V_Abandon_Customers AS
SELECT AC.Username, AC.LeaveDt, AC.PlanName, AC.JoinDate,
	[Membership Years] = (Datediff(yy, AC.JoinDate, AC.LeaveDT)+1), 
	[Total Revenue] = (Datediff(yy, AC.JoinDate, AC.LeaveDT)+1) * PP.Price,
	[Estimated Loss] = (Datediff(yy, AC.LeaveDt, Getdate())) * PP.Price
FROM ARCHIVE_CUSTOMERS AS AC JOIN (SELECT P.Name, P.Price
									FROM PLANS AS P ) AS PP ON PP.Name = AC.PlanName
GROUP BY AC.Username, AC.LeaveDt, AC.PlanName, PP.Price, AC.JoinDate


-- simple query returning all information needed about abandon customers
SELECT *
FROM V_Abandon_Customers AS VAC
ORDER BY VAC.PlanName
--WHERE VAC.PlanName = 'Business'


