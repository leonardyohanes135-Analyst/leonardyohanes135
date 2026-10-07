/* ============================================================
   Adoption of Modern Irrigation Technologies — STATA Analysis
   Author  : Leonard Yohanes Mathayo
   Tool    : STATA 17
   Dataset : irrigation_survey_data.csv (200 respondents)
   Study   : Dodoma Region, Tanzania
   ============================================================ */

clear all
set more off
capture log close
log using "irrigation_analysis_log.txt", replace text

* ── 1. IMPORT DATA ────────────────────────────────────────────
import delimited "irrigation_survey_data.csv", clear varnames(1)
describe
summarize

* ── 2. ENCODE CATEGORICAL VARIABLES ──────────────────────────
encode gender,               gen(gender_num)
encode education,            gen(educ_num)
encode occupation,           gen(occup_num)
encode irrigation_type,      gen(irrig_num)
encode main_barrier,         gen(barrier_num)
encode production_improved,  gen(prod_num)
encode adopted_technology,   gen(adopted_num)
encode access_extension,     gen(ext_num)
encode access_credit,        gen(credit_num)

* Binary: adopted = 1/0
gen adopted_bin = (adopted_technology == "Yes")
gen prod_bin    = (production_improved == "Yes")
gen ext_bin     = (access_extension == "Yes")
gen credit_bin  = (access_credit == "Yes")
gen gender_bin  = (gender == "Male")

* Education ordinal
gen educ_ord = 0 if education == "No Formal"
replace educ_ord = 1 if education == "Primary"
replace educ_ord = 2 if education == "Secondary"
replace educ_ord = 3 if education == "College/University"

* ── 3. DESCRIPTIVE STATISTICS ─────────────────────────────────
tab gender
tab education
tab occupation
tab irrigation_type
tab main_barrier
tab production_improved
tab adopted_technology
tab affordability_perception

tabstat age farm_size_acres years_farming crop_yield_before_kg ///
        crop_yield_after_kg income_before_tzs income_after_tzs, ///
        stats(n mean sd min max) columns(statistics)

* ── 4. CROSS-TABULATIONS ──────────────────────────────────────
tab irrigation_type gender,        row chi2
tab adopted_technology education,  row chi2
tab main_barrier gender,           row chi2
tab production_improved adopted_technology, row chi2 col

* ── 5. T-TESTS ────────────────────────────────────────────────
* Yield before vs after (paired)
ttest crop_yield_after_kg == crop_yield_before_kg

* Income before vs after (paired)
ttest income_after_tzs == income_before_tzs

* Production improvement by gender
ttest prod_bin, by(gender_bin)

* Access to credit by education
ttest credit_bin, by(gender_bin)

* ── 6. LOGISTIC REGRESSION ────────────────────────────────────
* Model 1: Predictors of adoption
logit adopted_bin gender_bin educ_ord age ext_bin credit_bin farm_size_acres, or
estimates store model_adopt

* Model 2: Predictors of production improvement
logit prod_bin gender_bin educ_ord age adopted_bin ext_bin credit_bin, or
estimates store model_prod

* Marginal effects
margins, dydx(*) post
estimates store margins_prod

* Model fit
estat gof
estat classification

* ── 7. LINEAR REGRESSION: Yield after ────────────────────────
regress crop_yield_after_kg gender_bin educ_ord age adopted_bin ///
        ext_bin credit_bin farm_size_acres crop_yield_before_kg
vif

* ── 8. VISUALIZATIONS ────────────────────────────────────────
* Bar: Irrigation type
graph bar (count), over(irrigation_type, sort(1) descending) ///
    title("Irrigation Technologies Used") ///
    ytitle("Number of Farmers") blabel(bar) ///
    bar(1, color(navy))
graph export "fig1_irrigation_types.png", replace

* Bar: Main barriers
graph bar (count), over(main_barrier, sort(1) descending) ///
    title("Main Barriers to Adoption") ///
    ytitle("Number of Respondents") blabel(bar) ///
    bar(1, color(dknavy))
graph export "fig2_barriers.png", replace

* Histogram: Yield improvement
twoway (histogram crop_yield_before_kg, color(blue%40) width(100)) ///
       (histogram crop_yield_after_kg,  color(gold%40) width(100)), ///
    legend(label(1 "Before Adoption") label(2 "After Adoption")) ///
    title("Crop Yield Distribution Before vs After") ///
    xtitle("Yield (kg)") ytitle("Density")
graph export "fig3_yield_distribution.png", replace

* Scatter: Yield before vs after
scatter crop_yield_after_kg crop_yield_before_kg, ///
    msymbol(circle_hollow) mcolor(navy) ///
    title("Crop Yield: Before vs After Adoption") ///
    xtitle("Yield Before (kg)") ytitle("Yield After (kg)") ///
    || lfit crop_yield_after_kg crop_yield_before_kg, lcolor(red)
graph export "fig4_yield_scatter.png", replace

log close
