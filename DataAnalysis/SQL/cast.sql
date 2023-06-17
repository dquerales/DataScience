-- cast() 
SELECT 1 - 2;
SELECT CAST(1-2 AS UNSIGNED); -- error
SELECT CAST(1-2 AS SIGNED);

-- convert()
SELECT CONVERT('2013-06-19 14:47:08', DATE) AS date1,
       CONVERT('13-06-19 14:47:08', DATE) AS date2,
       CONVERT('20130619', DATE) AS date3,
       CONVERT('130619', DATE) AS date4;

SELECT CONVERT('14:47:08', TIME) AS time1,
       CONVERT('144708', TIME) AS time2;
       
SELECT CONVERT('11.1', DECIMAL(4,2)) AS dec1;
