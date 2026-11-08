-- 1 Overall payment-difficulty rate
CREATE VIEW PORTFOLIO_RATE AS SELECT ROUND((SUM(TARGET = 1) / COUNT(*)) * 100) AS rate
FROM application;
SELECT * 
FROM PORTFOLIO_RATE;

-- 2.	Rate by NAME_CONTRACT_TYPE
select NAME_CONTRACT_TYPE,ROUND(AVG(TARGET)*100,2) AS DEFAULT_RATE from application group by NAME_CONTRACT_TYPE;

-- 3. Average income, credit amount and annuity for TARGET = 1 vs TARGET = 0.

SELECT TARGET,ROUND(AVG(AMT_INCOME_TOTAL)) AS INCOME ,ROUND(AVG(AMT_CREDIT)) AS TOTAL_LOAN ,ROUND(AVG(AMT_ANNUITY)) MONTHLY_EMI FROM application GROUP BY TARGET;

-- 4.Loan-amount buckets (under 100K, 100K to 300K, 300K to 600K, 600K+) with count and rate per bucket.

SELECT 
    CASE 
        WHEN AMT_CREDIT < 1000000 THEN '0-1M'
        WHEN AMT_CREDIT < 2000000 THEN '1M-2M'
        WHEN AMT_CREDIT < 3000000 THEN '2M-3M'
        WHEN AMT_CREDIT < 4000000 THEN '3M-4M'
        WHEN AMT_CREDIT < 5000000 THEN '4M-5M'
        WHEN AMT_CREDIT < 6000000 THEN '5M-6M'
        WHEN AMT_CREDIT < 7000000 THEN '6M-7M'
        ELSE '7M'
    END AS LOAN_AMT_BUCKET,
    ROUND(AVG(TARGET) * 100, 2) AS DEFAULT_RATE
FROM application
GROUP BY LOAN_AMT_BUCKET ORDER BY DEFAULT_RATE DESC;

-- 5.	Rate by age_band.

SELECT 
    CASE 
        WHEN AGE_YEARS < 10 THEN '0-10'
        WHEN AGE_YEARS < 20 THEN '10-20'
        WHEN AGE_YEARS < 30 THEN '20-30'
        WHEN AGE_YEARS < 40 THEN '30-40'
        WHEN AGE_YEARS < 50 THEN '40-50'
        WHEN AGE_YEARS < 60 THEN '50-60'
        WHEN AGE_YEARS < 70 THEN '60-70'
        ELSE '70+'
    END AS AGE_BUCKET,

    ROUND(AVG(TARGET) * 100, 2) AS DEFAULT_RATE

FROM application

GROUP BY AGE_BUCKET ORDER BY DEFAULT_RATE DESC;

-- 6.	Rate by income_band

SELECT
    INCOME_BAND,
    COUNT(*) AS CUSTOMERS,
    ROUND(AVG(TARGET) * 100, 2) AS DEFAULT_RATE
FROM (
    SELECT
        TARGET,
        NTILE(5) OVER (
            ORDER BY AMT_INCOME_TOTAL
        ) AS INCOME_BAND
    FROM application
) t
GROUP BY INCOME_BAND
ORDER BY INCOME_BAND;

-- 7.Top 10 occupations by rate (at least 1,000 applicants, using HAVING).

select OCCUPATION_TYPE,round(avg(target),2)*100  as default_rate from application group by  OCCUPATION_TYPE order by default_rate Desc limit 10;

-- 8. Rate by NAME_EDUCATION_TYPE and NAME_INCOME_TYPE.
select NAME_EDUCATION_TYPE,round(avg(AMT_INCOME_TOTAL)) INCOME ,round(avg(target),2)*100  as default_rate 
	from application
	group by  NAME_EDUCATION_TYPE
    order by default_rate Desc limit 10;
    
-- 9.	Rate by years-employed band, with null employment as its own group
SELECT
    YEARS_WORKED,
    COUNT(*) AS CUSTOMERS,
    ROUND(AVG(TARGET) * 100, 2) AS DEFAULT_RATE
FROM (
    SELECT
        TARGET,
        CASE
            WHEN YEARS_EMPLOYED IS NULL THEN 6
            ELSE NTILE(5) OVER (ORDER BY YEARS_EMPLOYED)
        END AS YEARS_WORKED
    FROM application
) T
GROUP BY YEARS_WORKED
ORDER BY YEARS_WORKED;

-- 10.	Rate by gender, family status and number of children.

SELECT
    CODE_GENDER,
    NAME_FAMILY_STATUS,
    CNT_CHILDREN,
    COUNT(*) AS CUSTOMERS,
    ROUND(AVG(TARGET) * 100, 2) AS DEFAULT_RATE
FROM application
GROUP BY
    CODE_GENDER,
    NAME_FAMILY_STATUS,
    CNT_CHILDREN
    having CUSTOMERS>1000
ORDER BY
	 DEFAULT_RATE desc,
    CODE_GENDER,
    NAME_FAMILY_STATUS,
    CNT_CHILDREN
 ;
-- 11.	Do car or realty owners do better? Compare FLAG_OWN_CAR and FLAG_OWN_REALTY, then combine both.

SELECT
    FLAG_OWN_REALTY,
    COUNT(*) AS CUSTOMERS,
    ROUND(AVG(TARGET) * 100, 2) AS DEFAULT_RATE
FROM application
GROUP BY FLAG_OWN_REALTY
ORDER BY DEFAULT_RATE;

-- 12.	Rate by credit_income_ratio band (<1, 1 to 2, 2 to 3, 3 to 5, 5+).
select case
		when CREDIT_INCOME_RATIO<1 then "0-1"
		when CREDIT_INCOME_RATIO<2 then "1-2"
        when CREDIT_INCOME_RATIO<3 then "2-3"
        when CREDIT_INCOME_RATIO<4 then "3-4"
        when CREDIT_INCOME_RATIO<5 then "4-5"
        when CREDIT_INCOME_RATIO>5 then "5+"
        ELSE "UNKOWN"
        end as CREDIT_INCOME_BUCKET
        , round(avg(TARGET),2)* 100 AS DEFULAT_RATE
        FROM application 
        group by CREDIT_INCOME_BUCKET;
        
-- 13.	Rate by annuity_income_ratio band (<10%, 10 to 20%, 20 to 30%, 30%+).
SELECT 
    CASE 
        WHEN ANNUITY_INCOME_RATIO < 0.10 THEN '0-10%'
        WHEN ANNUITY_INCOME_RATIO < 0.20 THEN '10-20%'
        WHEN ANNUITY_INCOME_RATIO < 0.30 THEN '20-30%'
        WHEN ANNUITY_INCOME_RATIO < 0.40 THEN '30-40%'
        WHEN ANNUITY_INCOME_RATIO < 0.50 THEN '40-50%'
        WHEN  ANNUITY_INCOME_RATIO< 0.60 THEN '50-60%'
        WHEN AGE_YEARS < 0.70 THEN '60-70%'
        ELSE '70+%'
    END AS ANNUITY_INCOME_BUCKET,

    ROUND(AVG(TARGET) * 100, 2) AS DEFAULT_RATE

FROM application

GROUP BY ANNUITY_INCOME_BUCKET ORDER BY DEFAULT_RATE DESC;

-- 13.	Rate by annuity_income_ratio band (<10%, 10 to 20%, 20 to 30%, 30%+).
SELECT 
    CASE 
        WHEN ANNUITY_INCOME_RATIO < 0.10 THEN '0-10%'
        WHEN ANNUITY_INCOME_RATIO < 0.20 THEN '10-20%'
        WHEN ANNUITY_INCOME_RATIO < 0.30 THEN '20-30%'
        WHEN ANNUITY_INCOME_RATIO < 0.40 THEN '30-40%'
        WHEN ANNUITY_INCOME_RATIO < 0.50 THEN '40-50%'
        WHEN  ANNUITY_INCOME_RATIO< 0.60 THEN '50-60%'
        WHEN AGE_YEARS < 0.70 THEN '60-70%'
        ELSE '70+%'
    END AS ANNUITY_INCOME_BUCKET,

    ROUND(AVG(TARGET) * 100, 2) AS DEFAULT_RATE

FROM application

GROUP BY ANNUITY_INCOME_BUCKET ORDER BY DEFAULT_RATE DESC;

-- 15.	Among high credit-to-income applicants with a strong EXT_SOURCE_2, is risk still high?

SELECT MAX(CREDIT_INCOME_RATIO) AS P75_CUTOFF
FROM (
    SELECT
        CREDIT_INCOME_RATIO,
        NTILE(4) OVER (ORDER BY CREDIT_INCOME_RATIO) AS quartile
    FROM application
    WHERE CREDIT_INCOME_RATIO IS NOT NULL
) t
WHERE quartile = 3;
select max(EXT_SOURCE_2) as p75_cuttoff
from (select EXT_SOURCE_2 ,ntile(4) over(order by EXT_SOURCE_2) as quartile from application where EXT_SOURCE_2 is not null ) t
where quartile=3;
select case when CREDIT_INCOME_RATIO >5.16 and EXT_SOURCE_2>0.66 then 'high C/I ratio '
			when CREDIT_INCOME_RATIO>5.16 then "hight Credit value"
            when EXT_SOURCE_2>0.66 then "high exit_source"
            else "less C_I  ratio"
            end as CI_RATIO, COUNT(*) AS APPLICANTS,
            ROUND(AVG(TARGET)*100,2) AS DEFAULT_RATE
            FROM application 
            WHERE CREDIT_INCOME_RATIO IS NOT NULL
			AND EXT_SOURCE_2 IS NOT NULL
            group by  CI_RATIO ORDER BY DEFAULT_RATE DESC;

-- 16.	Rate by number of prior bureau loans (0, 1 to 2, 3 to 5, 6+).-- 16.	Rate by number of prior bureau loans (0, 1 to 2, 3 to 5, 6+).
WITH PRIOR_BUREAU AS (SELECT A.SK_ID_CURR,COUNT(B.SK_ID_BUREAU) AS TOTAL_BUREAU,
					  MAX(A.TARGET) TARGET FROM application A 
                      left join bureau B 
                      ON A.SK_ID_CURR=B.SK_ID_CURR  GROUP BY A.SK_ID_CURR)
SELECT CASE WHEN TOTAL_BUREAU <5 THEN "0-5 BUREAU"
				 WHEN TOTAL_BUREAU <10 THEN "5-10 BUREAU"
                 WHEN TOTAL_BUREAU <15 THEN "10-15 BUREAU"
                 WHEN TOTAL_BUREAU <20 THEN "15-20 BUREAU"
                 WHEN TOTAL_BUREAU <25 THEN "20-25 BUREAU"
                 ELSE "25+ BUREAU" 
                 END AS PRIOR_LOAN,
                 ROUND(AVG(TARGET)*100,2) AS DEFAULT_RATE 			
                 FROM PRIOR_BUREAU
                 GROUP BY PRIOR_LOAN 
                 ORDER BY DEFAULT_RATE DESC;
-- 17.	Rate with any overdue bureau credit 
WITH PRIOR_BUREAU AS (SELECT A.SK_ID_CURR,MAX(A.TARGET) AS TARGET,
					  MAX(B.is_overdue) IS_DUE FROM application A 
                      left join bureau B 
                      ON A.SK_ID_CURR=B.SK_ID_CURR  WHERE  B.is_overdue is not null GROUP BY A.SK_ID_CURR  )
select IS_DUE,ROUND(AVG(TARGET)*100,2)  AS DEFAULT_RATE FROM PRIOR_BUREAU GROUP BY IS_DUE ORDER BY IS_DUE DESC;

-- 19.	Rate by number of previous refusals (0, 1, 2, 3+), using NAME_CONTRACT_STATUS = 'Refused'
WITH PRIOR_BUREAU AS (SELECT A.SK_ID_CURR,MAX(p.is_refused) AS REFUSAL,
					  MAX(A.TARGET) TARGET FROM application A 
                      left join previous p
                      ON A.SK_ID_CURR=p.SK_ID_CURR  WHERE p.is_refused is not null GROUP BY A.SK_ID_CURR )
 select REFUSAL,COUNT(SK_ID_CURR) TOTAL_APPLICANTS,ROUND(AVG(TARGET)*100,2) AS DEFAULT_RATE from PRIOR_BUREAU group by REFUSAL;
 
 -- 20.	First-time borrowers (no previous applications) vs repeat customers.
SELECT  CASE
        WHEN P.SK_ID_CURR IS NULL THEN 'First-time borrower'
        ELSE 'Repeat customer'
    END AS CUSTOMER_TYPE,
    COUNT(*) AS APPLICANTS,
    ROUND(AVG(a.TARGET) * 100, 2) AS DEFAULT_RATE 
    FROM application A left join (SELECT distinct SK_ID_CURR FROM  previous) P on A.SK_ID_CURR=P.SK_ID_CURR group by CUSTOMER_TYPE;

