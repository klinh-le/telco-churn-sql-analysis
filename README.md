# Telco Customer Churn Analysis (SQL)

A SQL-based analysis of customer churn for a telecom company, identifying which customers are most likely to leave and how much monthly revenue is at risk as a result.

## Project Overview

This project analyzes a real-world telecom customer dataset to understand churn: who is leaving, why, and how much it's costing the business. Using PostgreSQL, I explored churn patterns across customer tenure, contract type, and service add-ons, then quantified the revenue impact. The goal was to move beyond a single churn rate and identify specific, actionable patterns a retention team could act on.

## Business Problem

A telecom company's VP of Customer Success wants to reduce customer churn but doesn't know where to focus retention efforts. Should the team target new customers, month-to-month subscribers, or customers without certain add-on services? This analysis answers that question by breaking churn down into segments the business can actually act on.

## Objectives

- Measure the company's overall churn rate as a baseline
- Determine whether newer customers churn at a different rate than long-tenured ones
- Compare churn rates across contract types (month-to-month, one year, two year)
- Identify whether internet service type and add-on services (tech support, online security) are linked to churn
- Quantify the monthly revenue at risk from churned customers, broken down by contract type

## Dataset

- **Source:** [Telco Customer Churn dataset on Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn) (`WA_Fn-UseC_-Telco-Customer-Churn.csv`)
- **Size:** 7,043 rows, 21 columns
- **Contents:** One row per customer, including demographics (gender, senior citizen status, partner/dependents), account info (tenure, contract type, payment method), services subscribed (phone, internet, streaming, tech support, etc.), monthly and total charges, and whether the customer churned

**Data quality note:** 11 customers had a blank `total_charges` value. All 11 had a `tenure` of 0, meaning they were brand-new customers who hadn't been billed yet. These blanks were converted to `NULL` rather than 0, since 0 would misleadingly suggest they were charged and paid nothing.

## Tools Used

- PostgreSQL
- pgAdmin
- Git / GitHub

## Methodology

1. Designed a `customers` table matching the dataset's structure, plus a `tenure_buckets` reference table (0–6, 7–12, 13–24, 25+ months) to practice joining on a range condition instead of hardcoding tenure groups with `CASE`.
2. Imported the CSV using `\copy`, then cleaned the 11 blank `total_charges` values into proper `NULL`s.
3. Answered 5 business questions using progressively more advanced SQL: conditional aggregation, a range-based `JOIN`, `CTE`s combined with `UNION ALL`, and a window function.

This project builds on the retail sales project by introducing JOINs, CTEs, and window functions for the first time.

## Analysis & Key Findings

### 1. Overall Churn Rate
[`sql/01_overall_churn_rate.sql`](sql/01_overall_churn_rate.sql)

Of 7,043 customers, 1,869 have churned — an overall churn rate of **26.54%**. This is the baseline every other finding below is measured against.

### 2. Churn by Tenure Bucket
[`sql/02_churn_by_tenure_bucket.sql`](sql/02_churn_by_tenure_bucket.sql)

Churn drops sharply the longer a customer stays:

| Tenure | Churn Rate |
|---|---|
| 0–6 months | 52.94% |
| 7–12 months | 35.89% |
| 13–24 months | 28.71% |
| 25+ months | 14.04% |

Customers in their first 6 months churn at nearly 4x the rate of customers past the 2-year mark. This points to an "onboarding cliff" — something in the first few months is failing to hook new customers, whether that's price shock, a rocky setup experience, or simply not seeing enough value yet.

### 3. Churn by Contract Type
[`sql/03_churn_by_contract_type.sql`](sql/03_churn_by_contract_type.sql)

| Contract | Churn Rate |
|---|---|
| Month-to-month | 42.71% |
| One year | 11.27% |
| Two year | 2.83% |

Contract length is one of the strongest churn predictors in the dataset. Month-to-month customers churn at more than 15x the rate of two-year customers. This makes sense: a month-to-month contract has no switching cost, while a multi-year contract does.

### 4. Churn by Internet Service & Add-On Services
[`sql/04_churn_by_internet_and_addons.sql`](sql/04_churn_by_internet_and_addons.sql)

**Internet service type:**

| Service | Churn Rate |
|---|---|
| No internet service | 7.40% |
| DSL | 18.96% |
| Fiber optic | 41.89% |

**Add-on services (Online Security / Tech Support):**

| Has add-on? | Churn Rate |
|---|---|
| No internet service | 7.40% |
| Yes | ~15% |
| No | ~42% |

Fiber optic customers churn far more than DSL customers, despite fiber typically being the "better" product — this is likely a price or reliability issue worth investigating further. Separately, customers without tech support or online security churn at roughly 3x the rate of those with it, suggesting these add-ons genuinely help retention (or that customers who skip them are already less engaged).

### 5. Revenue at Risk by Contract Type
[`sql/05_revenue_at_risk_by_contract.sql`](sql/05_revenue_at_risk_by_contract.sql)

| Contract | Monthly Revenue at Risk | % of Total |
|---|---|---|
| Month-to-month | $120,847.10 | 86.86% |
| One year | $14,118.45 | 10.15% |
| Two year | $4,165.30 | 2.99% |

Month-to-month customers account for 86.86% of all monthly revenue currently at risk from churn. Combined with Finding 3, this makes month-to-month customers the clear top priority: they churn the most *and* they represent the vast majority of revenue actually at stake.

## Business Recommendations

1. **Prioritize month-to-month customers for retention efforts.** They drive both the highest churn rate (42.71%) and 86.86% of revenue at risk — this is where retention spend will have the biggest impact.
2. **Build a stronger first-6-month onboarding experience.** With churn at 52.94% in this window, even a modest improvement here would meaningfully lower overall churn given how many customers fall into this bucket.
3. **Offer incentives to move month-to-month customers onto one- or two-year contracts** (e.g., a discount or bundled add-on), since contract length is the single strongest churn predictor found.
4. **Investigate why Fiber optic churn is so much higher than DSL.** Since fiber is usually a premium product, this gap likely points to a pricing, reliability, or customer-service issue specific to that service.
5. **Promote or bundle Online Security and Tech Support** with new sign-ups, since customers with these add-ons churn at about a third of the rate of those without them.

## Limitations

- This analysis shows correlation, not causation. For example, we don't know *why* fiber customers churn more — it could be price, reliability, competition, or something else the dataset doesn't capture.
- The dataset is a single snapshot, not a true time series. We can group customers by tenure, but we can't track an individual customer's behavior changing over time the way a real cohort analysis would.
- No pricing or competitor data is included, which limits how confidently we can explain the fiber optic churn pattern.

## Future Improvements

- Bring in customer support ticket data to see if fiber optic customers report more issues.
- Build a proper cohort analysis if historical (multi-snapshot) data becomes available, tracking churn by signup month over time.
- Test a logistic regression model (in a future Python project) to rank which factors predict churn most strongly when considered together, rather than one at a time.

## Project Structure

```
telco-churn-sql-analysis/
├── README.md
├── sql/
│   ├── 01_overall_churn_rate.sql
│   ├── 02_churn_by_tenure_bucket.sql
│   ├── 03_churn_by_contract_type.sql
│   ├── 04_churn_by_internet_and_addons.sql
│   └── 05_revenue_at_risk_by_contract.sql
├── data/
└── images/
```