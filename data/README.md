Home Credit Default Risk: SQL Analysis and Power BI Dashboard

Which borrowers struggle to repay, and which signals show it first? This project analyses 307,511 granted loans from the Kaggle Home Credit Default Risk dataset with MySQL and presents the results in a three-page Power BI dashboard.

Overview page

Business question

A lender wants to know where payment difficulty is concentrated, so it can decide which applicants to review more closely. The analysis answers three questions:

How big is the problem, and which factors separate high-risk from low-risk borrowers?
Which applicant profiles (age, job tenure, education, occupation, income) carry the most risk?
Do affordability ratios and credit history (previous loans, previous refusals) add anything?
Key findings
Finding	Evidence
About 1 in 12 loans had payment difficulties	24,825 of 307,511 loans, 8.07%
Overdue bureau credit is the clearest warning	15.90% rate against 7.62% with a clean record, on only 1.1% of loans
Young applicants and short job tenure carry more risk	Ages 20 to 30: 11.5%, against 4.9% at 60 to 70. 1 to 4 years employed: 10.8%, against 3.2% at 30 to 50 years
Lower education and low-skill jobs run high	Lower secondary 10.9%, academic degree 1.8%. Low-skill laborers 17.2%
Applicants with 2 or more earlier refusals hold a quarter of the cases	17.5% of loans, about 25% of difficulty cases (rates of 12.6% and 10.2%)
A strong external score cuts the rate sharply	3.8% above a 0.66 score against 9.6% at or below it
Debt-burden ratios say little on their own	Credit ÷ income moves the rate 2.7 points, annuity ÷ income 1.5 points, against 8.3 for overdue bureau credit
Dashboard
Page	What it shows
Overview	Four KPI cards, a ranking of which factors separate risk most, where difficulty concentrates (share of loans against share of cases), and where to look first
Applicants	Rate by years employed, age, income level, occupation and education, with slicers for contract type, gender and family status
Credit history	Rate by credit ÷ income, annuity ÷ income, previous loans and previous refusals, with slicers for contract type, gender and age group

Design choices:

Every rate chart uses the same 0 to 18% axis, so bar lengths compare across charts.
Dark blue bars are above the 8.07% portfolio rate and light blue bars are at or below it. A dashed line marks the portfolio rate.
Slicers change the KPI cards and charts on their page. The portfolio rate stays fixed, so a selection is always compared with the whole portfolio.

Applicants page Credit history page

Tech stack
MySQL: business questions answered with GROUP BY, CASE, HAVING, window functions (NTILE, LAG), CTEs and LEFT JOINs across the application, bureau and previous_application tables
Python (pandas, Jupyter): data understanding and cleaning
Power BI: data model, DAX measures, slicers and report design
Data
Source: Home Credit Default Risk on Kaggle. Download the CSVs from Kaggle; they are not stored in this repository.
Tables used: application_train, bureau, previous_application
TARGET = 1 marks a loan with payment difficulties.
Repository structure
.
├── sql/              # SQL queries for the business questions
├── notebooks/        # Jupyter notebooks for cleaning
├── powerbi/          # Power BI report and theme
├── images/           # Dashboard screenshots (page1.png, page2.png, page3.png)
└── README.md

Adjust the folder names to match what you commit.

Method notes
The TARGET flag is a repayment flag, not an amount of money lost.
Rates in the dashboard are the share of loans with TARGET = 1 in each group.
Factor gaps on the Overview are the highest group rate minus the lowest, ignoring groups under 1,000 loans.
"Estimated cases" in the concentration chart are loans × rate. Segments overlap, so rows do not add up.
Limitations
The data covers granted loans only, so there is no approval rate and no analysis of rejected applicants.
The results are descriptive. They show where difficulty is concentrated, not what causes it.
The employment band of 0 to 1 year may include applicants with no recorded employment, such as pensioners.
Gender and family status describe the portfolio. They are not credit decision criteria.
Next steps
Build a default-prediction model in Jupyter on the cleaned data.
Add the bureau-based views (overdue credit, bureau loan count) as detail charts.
Author

Karthik · www.linkedin.com/in/
karthik-manikulam-608995320
