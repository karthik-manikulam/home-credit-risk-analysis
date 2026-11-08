# Home Credit Default Risk Analysis

End-to-end credit risk analysis on the Kaggle **Home Credit Default Risk** dataset, using **MySQL** for analysis, **Python (Jupyter)** for cleaning and modelling, and **Power BI** for the dashboard.

## Business problem

Home Credit lends to people with little or no credit history. Approving someone who later cannot repay costs money, and rejecting someone who would have repaid loses a good customer. This project answers: **who is most likely to have payment difficulties, and what should the lender do about it?**

`TARGET = 1` means the client had payment difficulties on the loan; `TARGET = 0` means everything else.

## Headline numbers

| Metric | Value |
|---|---|
| Total loans | 307,511 |
| Payment-difficulty cases | 24,825 |
| Overall rate | 8.07% |

## Business questions

1. **Portfolio and baseline risk:** how big is the book, and how do loan types and loan sizes differ?
2. **Applicant profiles:** how do age, income, occupation, education and family situation change risk?
3. **Affordability:** at what credit-to-income and annuity-to-income level does risk jump?
4. **Past credit behaviour:** do prior bureau loans, overdue credit and previous refusals predict difficulty?
5. **Risk concentration and policy:** how much of the risk sits in a small segment, and what is the cost of rejecting it?

## Workflow

1. Define business questions
2. Load `application_train`, `bureau` and `previous_application` into MySQL
3. Understand and clean the data in Jupyter (null checks, `DAYS_EMPLOYED = 365243` placeholder, flag columns)
4. Answer the business questions with SQL (CTEs, window functions, aggregation of `bureau` and `previous_application` to one row per `SK_ID_CURR`)
5. Build the dashboard in Power BI
6. Build a default-risk model in Jupyter (in progress)

## Tech stack

MySQL, Python (pandas, numpy, matplotlib, seaborn, scikit-learn), Jupyter, Power BI

## Repository structure

```
home-credit-risk/
├── README.md
├── .gitignore
├── data/
│   └── README.md          # how to download the data from Kaggle (CSVs not committed)
├── notebooks/
│   ├── 01_data_cleaning.ipynb
│   └── 02_modelling.ipynb
├── sql/
│   ├── 01_portfolio_overview.sql
│   ├── 02_applicant_profiles.sql
│   ├── 03_affordability.sql
│   ├── 04_credit_history.sql
│   └── 05_risk_concentration.sql
├── dashboard/
│   ├── home_credit_dashboard.pbix
│   └── screenshots/
└── docs/
```

## Key findings

_Add one line per finding, for example: "Default rate rises from X% to Y% once annuity exceeds 30% of income."_

-
-
-

## Dashboard

_Add screenshots from `dashboard/screenshots/`._

## Data

The dataset is not included in this repository. Download it from Kaggle: **Home Credit Default Risk** (`application_train.csv`, `bureau.csv`, `previous_application.csv`) and place the files in `data/`.

## Author

Karthik
