-- NEW Stored Procedure
CREATE PROCEDURE SP_FreeActiveCustomersData  @FromAge Int, @ToAge Int, @FromDate Date, @ToDate Date
AS BEGIN
IF (SELECT OBJECT_ID('DATA_FOR_BUSSINES_CUSTOMERS')) IS NOT NULL DROP TABLE DATA_FOR_BUSSINES_CUSTOMERS
CREATE TABLE DATA_FOR_BUSSINES_CUSTOMERS (
Age						INTEGER		NOT NULL,
Total_Memes_Created		INTEGER		NOT NULL,
Total_Users				INTEGER		NOT NULL,
Average_Memes_Amount	INTEGER		NOT NULL,
)
INSERT INTO DATA_FOR_BUSSINES_CUSTOMERS
	SELECT	Age = Datediff(yy, C.BirthDate, Getdate()), 
			[Total Memes Created] = COUNT(C.TotalMemes),
			[Total Users] = COUNT(DISTINCT C.JoinDate),
			[Average Memes Amount] = COUNT(C.TotalMemes) / COUNT(DISTINCT C.JoinDate)
	FROM CUSTOMERS AS C JOIN MEMES AS M ON C.Username = M.Username
	WHERE C.PlanName = 'Free' AND M.CreationDT BETWEEN @FromDate AND @ToDate 
	GROUP BY Datediff(yy, C.BirthDate, Getdate())
	HAVING Datediff(yy, BirthDate, Getdate()) BETWEEN @FromAge AND @ToAge 
	ORDER BY Age
END

EXECUTE SP_FreeActiveCustomersData 22, 30, '3/20/2020', '12/25/2022'

SELECT *
FROM DATA_FOR_BUSSINES_CUSTOMERS

