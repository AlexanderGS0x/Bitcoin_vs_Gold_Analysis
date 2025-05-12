# Bitcoin vs. Gold: Safe Haven Showdown (2015-2025)
A data analysis project comparing Bitcoin and gold as safe haven assets over a 10-year period. Includes data fetching (Python), cleaning (Google Sheets), processing (BigQuery), analysis (R), and visualization (Tableau).

## Files
- `Bitcoin_vs_Gold_Data_Fetch_10Years.ipynb`: Python notebook for data fetching.
- `bitcoin_vs_gold_raw_10years.csv`: Raw data.
- `bitcoin_vs_gold_processed_10years.csv`: Processed data.
- `bitcoin_vs_gold_analyzed_10years.csv`: Analyzed data.
- `analyze_data_10years.R`: R script for analysis.
- `bitcoin_vs_gold_report_10years.Rmd`: R Markdown file for the report.
- `bitcoin_vs_gold_report_10years.html`: Knitted HTML report.
- [Tableau Dashboard](https://public.tableau.com/app/profile/alexander.gallagher/viz/Bitcoinvs_GoldSafeHavenAnalysis2015-2025/BitcoinvsGoldDashboard)

## BigQuery Processing
Example SQL queries used in BigQuery:
```sql
SELECT
  Date,
  Bitcoin_Price,
  Gold_Price,
  (Bitcoin_Price / LAG(Bitcoin_Price) OVER (ORDER BY Date) - 1) * 100 AS Bitcoin_Weekly_Return,
  (Gold_Price / LAG(Gold_Price) OVER (ORDER BY Date) - 1) * 100 AS Gold_Weekly_Return
FROM `bitcoin-vs-gold-project-10y.safe_haven_data.raw_data`
ORDER BY Date;

CREATE OR REPLACE TABLE `bitcoin-vs-gold-project-10y.safe_haven_data.processed_data_sorted` AS
SELECT
  Date,
  Bitcoin_Price,
  Gold_Price,
  (Bitcoin_Price / LAG(Bitcoin_Price) OVER (ORDER BY Date) - 1) * 100 AS Bitcoin_Weekly_Return,
  (Gold_Price / LAG(Gold_Price) OVER (ORDER BY Date) - 1) * 100 AS Gold_Weekly_Return
FROM `bitcoin-vs-gold-project-10y.safe_haven_data.raw_data`
ORDER BY Date;

SELECT * FROM safe_haven_data.processed_data_sorted
