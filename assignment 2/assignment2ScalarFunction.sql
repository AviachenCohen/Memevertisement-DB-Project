-- Scalaer Valued Function
CREATE FUNCTION GrowthPercentageFromYear (@YEAR int)
RETURNS DECIMAL (10,2) 
AS BEGIN
		DECLARE		@GrowthPercentage	 DECIMAL (10,2), @BASE_VAL  DECIMAL (10,2), @EXP_VAL  DECIMAL (10,2)
		IF @YEAR = (YEAR(GETDATE())) RETURN 0;
		SET @BASE_VAL = (SELECT SUM(P.Price) / (	SELECT SUM(P.Price)
													FROM CUSTOMERS AS C JOIN PLANS AS P ON C.PlanName = P.Name
													WHERE YEAR (C.JoinDate) =  @YEAR
												)
						FROM CUSTOMERS AS C JOIN PLANS AS P ON C.PlanName = P.Name
						WHERE YEAR (C.JoinDate) >= @YEAR AND YEAR (C.JoinDate) < YEAR(GETDATE())) ;
		SET @EXP_VAL = (YEAR(GETDATE()) - @YEAR);
		SELECT @GrowthPercentage = (POWER (@BASE_VAL, 1/@EXP_VAL))-1			 	
		RETURN @GrowthPercentage * 100
END

SELECT Growth2021 = CAST(FLOOR (dbo.GrowthPercentageFromYear (2021))AS VARCHAR) + '%'

