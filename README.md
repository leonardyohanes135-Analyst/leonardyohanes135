<div align="center">
  
   # 📊 Leonard Yohanes Mathayo
   
   ### Data Analyst Portfolio

*Mathematics & Statistics | University of Dar es Salaam*
*Dar es Salaam, Tanzania 🇹🇿*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat&logo=linkedin)](https://www.linkedin.com/in/leonard-yohanes-939320318/)
[![Email](https://img.shields.io/badge/Email-Contact-EA4335?style=flat&logo=gmail)](mailto:leonard@email.com)
![Tools](https://img.shields.io/badge/Tools-SPSS%20|%20STATA%20|%20Power%20BI%20|%20Excel%20|%20Python%20|%20SQL-1B4F8A?style=flat)
</div>

---

## 👋 About Me

I am a **Mathematics and Statistics graduate** from the University of Dar es Salaam (UDSM), passionate about turning raw data into decisions that improve lives. My work sits at the intersection of **statistical analysis, data visualization, and humanitarian development** — with a focus on East African contexts.

Beyond the classroom, I served as **External & Alumni Relations Manager at DUSA** (Dar es Salaam University Statisticians Association) and as **LCVP Business Development at AIESEC in UDSM** - roles that sharpened my ability to translate data insights into stakeholder action.

> *"Data is not just numbers — it is the voice of communities waiting to be heard."*

---

## 🛠️ Tools & Skills

| Tool | Proficiency | Use Case |
|---|---|---|
| **SPSS** | ⭐⭐⭐⭐⭐ | Survey analysis, chi-square, logistic regression |
| **STATA** | ⭐⭐⭐⭐⭐ | Econometrics, panel data, do-files |
| **Power BI** | ⭐⭐⭐⭐☆ | Interactive dashboards, DAX, business intelligence |
| **Excel** | ⭐⭐⭐⭐⭐ | Pivot tables, VLOOKUP, dashboard design |
| **Python** | ⭐⭐⭐⭐☆ | pandas, matplotlib, seaborn, scipy |
| **SQL** | ⭐⭐⭐⭐☆ | Data querying, aggregation, business queries |

---

## 📁 Portfolio Projects

---

### 🌾 Project 1 — Irrigation Technology Adoption Analysis
**Tools:** SPSS · STATA

> Examining the adoption of modern irrigation technologies and their influence on agricultural production among smallholder farmers in Dodoma Region, Tanzania.

| Item | Detail |
|---|---|
| **Dataset** | 200 survey respondents, Dodoma Region |
| **Key Variables** | Gender, education, farm size, irrigation type, crop yield, income |
| **Methods** | Descriptive statistics, chi-square, paired t-test, logistic regression |
| **Key Finding** | Adopters showed 75% higher crop yield and 83% higher income post-adoption |

**Files:**
```
📂 spss/
   ├── irrigation_survey_data.csv       ← Survey dataset (200 rows)
   └── irrigation_analysis_spss.sps     ← Full SPSS syntax

📂 stata/
   ├── irrigation_survey_data.csv       ← Same dataset
   └── irrigation_analysis.do           ← Complete STATA do-file
```

**Skills Demonstrated:**
- Variable encoding and data cleaning
- Frequency analysis and cross-tabulations
- Paired and independent samples t-tests
- Binary logistic regression with odds ratios
- Chart export and APA reporting

---

### 🛒 Project 2 — E-Commerce Sales Intelligence Dashboard
**Tools:** Power BI · Excel · Python · SQL

> A full-cycle business intelligence project analyzing 500 sales transactions across Tanzania (2023–2024), uncovering revenue drivers, customer behaviour, and channel performance.

| Item | Detail |
|---|---|
| **Dataset** | 500 orders, 7 cities, 5 product categories, 2 years |
| **Key Metrics** | Revenue trends, return rates, delivery performance, customer ratings |
| **Methods** | Aggregation, trend analysis, segmentation, ANOVA, correlation |
| **Key Finding** | Mobile Money accounts for 50% of transactions; Express delivery drives highest ratings |

**Files:**
```
📂 powerbi/
   ├── ecommerce_sales_data.csv         ← Sales dataset
   └── powerbi_dax_measures.md          ← All DAX measures + dashboard blueprint

📂 excel/
   ├── ecommerce_sales_data.csv         ← Sales dataset
   ├── hr_workforce_data.csv            ← HR dataset
   └── excel_analysis_guide.md          ← Formulas, pivot tables, dashboard layout

📂 python/
   ├── ecommerce_sales_data.csv         ← Sales dataset
   └── ecommerce_analysis.py            ← Full Python analysis script

📂 sql/
   ├── ecommerce_sales_data.csv         ← Sales dataset
   └── ecommerce_queries.sql            ← 12 business intelligence queries
```

**Skills Demonstrated (by tool):**

**Power BI** — DAX measures, time intelligence, YoY growth, KPI cards, slicers, data model relationships

**Excel** — SUMIF, COUNTIFS, AVERAGEIF, VLOOKUP, INDEX-MATCH, pivot tables, dynamic dashboards

**Python** — pandas data wrangling, matplotlib/seaborn visualization, scipy ANOVA, correlation matrix

**SQL** — GROUP BY aggregations, CASE WHEN segmentation, window functions, subqueries, ranking

---

## 📊 Sample Analyses

### STATA — Logistic Regression Output (Sample)
```
Logistic regression                             Number of obs = 200
                                                LR chi2(5)    = 28.43
                                                Prob > chi2   = 0.0000
                                                Pseudo R2     = 0.1821

─────────────────┬────────────────────────────────────────────────────
    adopted_bin  │    OR     Std. Err.    z     P>|z|   [95% CI]
─────────────────┼────────────────────────────────────────────────────
     gender_bin  │  1.842    0.612      1.83   0.067   0.958–3.540
       educ_ord  │  1.953    0.408      3.22   0.001   1.307–2.917  **
            age  │  0.987    0.018     -0.72   0.471   0.952–1.023
        ext_bin  │  2.841    0.921      3.27   0.001   1.499–5.386  **
     credit_bin  │  3.124    1.102      3.21   0.001   1.558–6.263  **
farm_size_acres  │  1.089    0.064      1.45   0.147   0.970–1.222
─────────────────┴────────────────────────────────────────────────────
** p < 0.01
```

### SQL — Revenue by Category (Sample Output)
```sql
category          | orders | units_sold | total_revenue    | revenue_share_pct
──────────────────┼────────┼────────────┼──────────────────┼──────────────────
Electronics       |   150  |    723     |  TZS 42,350,000  |   30.2%
Clothing          |   125  |    601     |  TZS 31,120,000  |   22.2%
Food & Beverage   |   100  |    498     |  TZS 24,870,000  |   17.7%
Home & Garden     |    75  |    322     |  TZS 21,440,000  |   15.3%
Health & Beauty   |    50  |    241     |  TZS 20,580,000  |   14.7%
```

### Python — Key Statistical Finding
```
── ANOVA: Customer Rating by Sales Channel ──
F-statistic : 3.2814
P-value     : 0.0214
Result      : Significant difference between channels (p < 0.05)

── Revenue Summary ──
Mean    :  TZS 280,500
Median  :  TZS 225,000
Std Dev :  TZS 198,300
Min     :   TZS 15,000
Max     : TZS 3,150,000
```

---

## 🌍 Context & Mission

Most of my analytical work is rooted in **East African development challenges**:
- Agricultural productivity and technology adoption
- Youth employment and workforce analytics
- Small business performance and e-commerce growth
- Humanitarian data for programme decision-making

I believe data analysis is most powerful when it is **accessible, contextual, and actionable** — especially in communities where evidence-based decisions can change lives.

---

## 📬 Let's Connect

I am open to **freelance data analysis projects**, **research collaborations**, and **entry-level data analyst roles** - especially in development, NGO, government, or tech sectors across Tanzania and East Africa.

| Platform | Link |
|---|---|
| LinkedIn | [Leonard Yohanes Mathayo](https://www.linkedin.com/in/leonard-yohanes-939320318/) |
| Email | leonardyohanes135@email.com |
| Location | Dar es Salaam, Tanzania 🇹🇿 |

---

<div align="center">

*Built with 📊 data, ☕ coffee, and a deep belief that statistics can change lives.*

</div>
