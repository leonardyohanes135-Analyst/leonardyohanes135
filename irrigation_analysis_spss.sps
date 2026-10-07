* ============================================================
* Adoption of Modern Irrigation Technologies — SPSS Syntax
* Author  : Leonard Yohanes Mathayo
* Tool    : IBM SPSS Statistics 27
* Dataset : irrigation_survey_data.csv
* ============================================================.

* ── 1. IMPORT DATA ────────────────────────────────────────────.
GET DATA
  /TYPE=TXT
  /FILE="irrigation_survey_data.csv"
  /ENCODING='UTF8'
  /DELCASE=LINE
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /VARIABLES=
  respondent_id F8.0
  gender A10
  age F8.0
  age_group A10
  region A20
  education A30
  occupation A30
  farm_size_acres F8.2
  years_farming F8.0
  aware_modern_irrigation A5
  adopted_technology A5
  irrigation_type A20
  main_barrier A30
  access_extension A5
  access_credit A5
  crop_yield_before_kg F10.0
  crop_yield_after_kg F10.0
  income_before_tzs F12.0
  income_after_tzs F12.0
  production_improved A10
  affordability_perception A20
  satisfaction_score F8.0.
CACHE.
EXECUTE.

* ── 2. VALUE LABELS ───────────────────────────────────────────.
VALUE LABELS satisfaction_score
  1 'Very Dissatisfied'
  2 'Dissatisfied'
  3 'Neutral'
  4 'Satisfied'
  5 'Very Satisfied'.
EXECUTE.

* ── 3. DESCRIPTIVE STATISTICS ─────────────────────────────────.
FREQUENCIES VARIABLES=gender age_group education occupation
    irrigation_type main_barrier adopted_technology
    production_improved affordability_perception
  /ORDER=ANALYSIS.

DESCRIPTIVES VARIABLES=age farm_size_acres years_farming
    crop_yield_before_kg crop_yield_after_kg
    income_before_tzs income_after_tzs satisfaction_score
  /STATISTICS=MEAN STDDEV MIN MAX.

* ── 4. RECODE TO NUMERIC ──────────────────────────────────────.
RECODE gender ('Male'=1)('Female'=0) INTO gender_num.
RECODE adopted_technology ('Yes'=1)('No'=0) INTO adopted_num.
RECODE production_improved ('Yes'=1)('Not Sure'=0)('No'=0) INTO prod_num.
RECODE access_extension ('Yes'=1)('No'=0) INTO ext_num.
RECODE access_credit ('Yes'=1)('No'=0) INTO credit_num.

RECODE education
  ('No Formal'=0)('Primary'=1)('Secondary'=2)('College/University'=3)
  INTO educ_num.

EXECUTE.

* ── 5. CROSS-TABULATIONS WITH CHI-SQUARE ─────────────────────.
CROSSTABS
  /TABLES=irrigation_type BY gender
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ
  /CELLS=COUNT ROW
  /COUNT ROUND CELL.

CROSSTABS
  /TABLES=adopted_technology BY education
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ
  /CELLS=COUNT ROW
  /COUNT ROUND CELL.

CROSSTABS
  /TABLES=production_improved BY adopted_technology
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ
  /CELLS=COUNT ROW COL
  /COUNT ROUND CELL.

* ── 6. PAIRED T-TEST: Yield and Income Before vs After ────────.
T-TEST PAIRS=crop_yield_before_kg crop_yield_after_kg
  /CRITERIA=CI(.9500).

T-TEST PAIRS=income_before_tzs income_after_tzs
  /CRITERIA=CI(.9500).

* ── 7. INDEPENDENT T-TEST: Production Improvement by Gender ───.
T-TEST GROUPS=gender_num(0 1)
  /MISSING=ANALYSIS
  /VARIABLES=prod_num
  /CRITERIA=CI(.95).

* ── 8. ONE-WAY ANOVA: Yield by Education ─────────────────────.
ONEWAY crop_yield_after_kg BY educ_num
  /STATISTICS DESCRIPTIVES
  /MISSING ANALYSIS
  /POSTHOC=TUKEY ALPHA(0.05).

* ── 9. LOGISTIC REGRESSION: Predictors of Adoption ───────────.
LOGISTIC REGRESSION VARIABLES adopted_num
  /METHOD=ENTER gender_num educ_num age ext_num credit_num farm_size_acres
  /PRINT=GOODFIT CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(.5).

* ── 10. CHARTS ────────────────────────────────────────────────.
GRAPH
  /BAR(SIMPLE)=COUNT BY irrigation_type
  /TITLE='Types of Irrigation Technologies Used'.

GRAPH
  /BAR(SIMPLE)=COUNT BY main_barrier
  /TITLE='Main Barriers to Adoption'.

GRAPH
  /HISTOGRAM=crop_yield_before_kg
  /TITLE='Crop Yield Before Adoption'.

GRAPH
  /HISTOGRAM=crop_yield_after_kg
  /TITLE='Crop Yield After Adoption'.

GRAPH
  /SCATTERPLOT(BIVAR)=crop_yield_before_kg WITH crop_yield_after_kg
  /TITLE='Yield Before vs After Adoption'.
