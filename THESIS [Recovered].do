

**********************
******IDE THESIS******
**********************

set more off 
clear all
cd "C:\Users\HP\Downloads"
*mum characteristics
use "in_yc_householdmemberlevel.dta", clear
keep if relate == 1
codebook memsex
keep if memsex == 2
duplicates report childid
sort childid
by childid: keep if _n == 1
save "mumlevelR3.dta", replace

use "in_yc_householdmemberlevel.dta", clear
keep if relate == 1
keep if memsex == 1
sort childid
by childid: keep if _n == 1
save "dadlevelR3.dta", replace 

**ROUND 3 DATA


use "in_yc_stblhhsec8childactivity.dta", clear
* List duplicates based on child id
duplicates report CHILDID
duplicates list CHILDID
* Sort by child_id, and other variables if you want a specific order preserved
sort CHILDID
* Drop duplicates, keeping the first
by CHILDID: gen dup = cond(_N==1, 0, _n)
drop if dup > 1
drop dup
save "in_yc_stblhhsec8childactivity.dta", replace 

use in_yc_childlevel.dta, clear
merge 1:1 CHILDID using "in_yc_stblhhsec8childactivity.dta"
rename _merge merge1
rename CHILDID childid 
merge 1:1 childid using "in_yc_householdlevel.dta"
rename _merge merge2
merge 1:1 childid using "mumlevelR3.dta"
rename _merge merge3
rename id idmum
rename neg1day mumnrega1day
rename ineg1w mumnrega1w
merge 1:1 childid using "dadlevelR3.dta"

*child characteristics
rename CDINT dint
rename chsex sex 
*Fmeale shows up as 2
rename ENRSCHR3 curpresc
*hastsrt?
rename SCHOOLR3 HRSPRESC

*GRADE PROGRESSION?



append using "inchildlevel5yrold.dta"
* Creating Panel ID
gen age_group = .
replace age_group = 5 if agechild >= 54 & agechild <= 74
replace age_group = 12 if agechild >= 133 & agechild <= 157
missing (age_group)
egen panel_id = group(childid age_group)


gen year = 2007 
save "2007childleveldata.dta"















***************************
******DID ANALYSIS*********
***************************


*********Round 1***********

*Older Cohort
*Mother's Characteristics 
/*Working
Education
*/
use "insubsec2householdroster8.dta", clear
keep if relate == 1
keep if sex == 2
duplicates report childid
sort childid
by childid: keep if _n == 1
save "mumdata8.dta", replace

*Father's Characteristics 
/*Age
Education
*/
use "insubsec2householdroster8.dta", clear
keep if relate == 1
keep if sex == 1
duplicates report childid
sort childid
by childid: keep if _n == 1
save "daddata8.dta", replace

*Household Characteristics 
/*HH Size
Wealth Index
*/

use "inchildlevel8yrold.dta", clear 
*Child Characteristics 
/*
Sex
Age
Caste

Height for Age 
Weight for Age 
BMI for Age 
*/
merge 1:1 childid using "mumdata8.dta"
rename _merge merge1
rename age mumage 
rename grading mumeduc
rename support mumwork
merge 1:1 childid using "daddata8.dta"
keep childid sex typesite agechild chldeth bmi zwfa zhfa zbfa hhsize wi mumage mumeduc mumwork age grading support region
save "R18yearold.dta", replace 


*Younger cohort 
*Mother's Characteristics
use "insubsec2householdroster1.dta", clear
keep if relate == 1
keep if sex == 2
duplicates report childid
sort childid
by childid: keep if _n == 1
save "mumdata1.dta", replace

*Father's Characteristics
use "insubsec2householdroster1.dta", clear
keep if relate == 1
keep if sex == 1
duplicates report childid
sort childid
by childid: keep if _n == 1
save "daddata1.dta", replace

*Child Characteristics & merging the data 
use "inchildlevel1yrold.dta", clear 
merge 1:1 childid using "mumdata1.dta"
rename _merge merge1
rename age mumage 
rename grading mumeduc
rename support mumwork
merge 1:1 childid using "daddata1.dta"
keep childid sex typesite agechild chldeth bmi zwfa zhfa zbfa hhsize wi mumage mumeduc mumwork age grading support region
save "R11yearold.dta", replace 

append using "R18yearold.dta"
gen year = 2002 
save "Round1clean.dta", replace

*********Round 2***********

*Older Cohort
use "insubhouseholdmember12.dta", clear
keep if relate == 1
keep if memsex == 2
duplicates report childid
sort childid
by childid: keep if _n == 1
save "mumdata12.dta", replace

use "insubhouseholdmember12.dta", clear
keep if relate == 1
keep if memsex == 1
duplicates report childid
sort childid
by childid: keep if _n == 1
save "daddata12.dta", replace

use "inchildlevel12yrold.dta", clear 
merge 1:1 childid using "mumdata12.dta"
rename _merge merge1
rename age mumage 
rename grade mumeduc
rename act1 mumworkcategory
merge 1:1 childid using "daddata12.dta"
keep childid sex typesite agechild chldeth bmi zwfa zhfa zbfa hhsize wi mumage mumeduc mumworkcategory age grade act1 commid 
rename grade grading 
gen year = 2007
save "R212yearold.dta", replace 

*Younger Cohort 
use "insubhouseholdmember5.dta", clear
keep if relate == 1
keep if memsex == 2
duplicates report childid
sort childid
by childid: keep if _n == 1
save "mumdata5.dta", replace

use "insubhouseholdmember5.dta", clear
keep if relate == 1
keep if memsex == 1
duplicates report childid
sort childid
by childid: keep if _n == 1
save "daddata5.dta", replace

use "inchildlevel5yrold.dta", clear 
merge 1:1 childid using "mumdata5.dta"
rename _merge merge1
rename age mumage 
rename grade mumeduc
rename act1 mumworkcategory
merge 1:1 childid using "daddata5.dta"
keep childid sex typesite agechild chldeth bmi zwfa zhfa zbfa hhsize wi mumage mumeduc mumworkcategory age grade act1 commid 
rename grade grading 
gen year = 2007
save "R25yearold.dta", replace 

append using "R212yearold.dta"
save "Round2clean.dta", replace

***********Round 3**************
*Older Cohort
use "in_oc_childlevel.dta", clear 
rename CHILDID childid
merge 1:1 childid using "in_oc_householdlevel"
keep childid chsex typesite agechild bmi zwfa zhfa zbfa hhsize wi 
gen year = 2010
*To match caste, mumeduc, dadaeduc 
save "R316yearold.dta", replace 

*Younger Cohort 
use "in_yc_childlevel.dta", clear 
rename CHILDID childid
merge 1:1 childid using "in_yc_householdlevel"
keep childid chsex typesite agechild bmi zwfa zhfa zbfa hhsize wi 
gen year = 2010
*To match caste, mumeduc, dadaeduc 
save "R39yearold.dta", replace 

append using "R316yearold.dta"
save "Round3clean.dta", replace

use "Round3clean.dta", clear
rename chsex sex 

*Making final Panel 
append using "Round1clean.dta"
append using "Round2clean.dta"
encode childid, gen(CHILDID)
xtset CHILDID year 


*Keeping only rural observations 
keep if typesite == 2 
by childid, sort: gen n_obs = _N
drop if n_obs < 3
rename age dadage 
gen age = (agechild)/12
rename grading fathereduc
by childid: replace chldeth = chldeth[2002] if year == 2010 & missing(chldeth)
sort childid year
by childid: replace chldeth = chldeth[1] if year == 2010 & missing(chldeth)
by childid: replace mumeduc = mumeduc[2] if year == 2010 & missing(mumeduc)
by childid: replace fathereduc = fathereduc[2] if year == 2010 & missing(fathereduc)
by childid: replace region = region[1] if year == 2007 & missing(region)
by childid: replace region = region[1] if year == 2010 & missing(region)
by childid: replace commid = commid[2] if year == 2002 & missing(commid)
by childid: replace commid = commid[2] if year == 2010 & missing(commid)

gen districtid = 0
* Assign district IDs based on community ID ranges
replace district = 1 if inrange(commid, "IN001", "IN026")
replace district = 2 if inrange(commid, "IN028", "IN034")
replace district = 5 if inrange(commid, "IN035", "IN049")
replace district = 2 if inrange(commid, "IN061", "IN080")
replace district = 3 if inrange(commid, "IN050", "IN060")
replace district = 4 if inrange(commid, "IN081", "IN088")
replace district = 1 if inrange(commid, "IN097", "IN102")
replace district = 1 if commid == "IN092"
replace district = 6 if commid == "IN093"
replace district = 2 if commid == "IN094"
replace district = 4 if commid == "IN096"
replace district = 6 if commid == "IN027"

gen mandalid = 0
replace mandal= 6 if inrange(commid, "IN001", "IN017")
replace mandal= 7 if inrange(commid, "IN017", "IN023")
replace mandal= 3 if inrange(commid, "IN024", "IN026")
replace mandal= 2 if inrange(commid, "IN027", "IN032")
replace mandal= 1 if inrange(commid, "IN033", "IN034")
replace mandal= 11 if inrange(commid, "IN035", "IN040")
replace mandal= 12 if inrange(commid, "IN041", "IN042")
replace mandal= 13 if inrange(commid, "IN043", "IN046")
replace mandal= 10 if inrange(commid, "IN047", "IN049")
replace mandal= 8 if inrange(commid, "IN050", "IN054")
replace mandal= 9 if inrange(commid, "IN055", "IN060")
replace mandal= 17 if inrange(commid, "IN061", "IN065")
replace mandal= 18 if inrange(commid, "IN066", "IN070")
replace mandal= 16 if inrange(commid, "IN071", "IN075")
replace mandal= 19 if inrange(commid, "IN076", "IN080")
replace mandal= 15 if inrange(commid, "IN081", "IN085")
replace mandal= 14 if inrange(commid, "IN086", "IN088")
replace mandal= 20 if inrange(commid, "IN089", "IN091")
replace mandal= 3 if inrange(commid, "IN101", "IN102")
replace mandal = 6 if commid == "IN092"
replace mandal = 2 if commid == "IN093"
replace mandal = 1 if commid == "IN094"
replace mandal = 15 if commid == "IN096"
replace mandal = 7 if commid == "IN097"
replace mandal = 5 if commid == "IN099"

save "thesispaneldata.dta", replace



*******************************
***********Analysis************
*******************************

use "thesispaneldata.dta", clear
gen gender = 0
replace gender = 1 if sex == 1
label define genderlbl 0 "Female" 1 "Male"
label values gender genderlbl
tabulate gender

list if abs(zbfa) > 5
drop if abs(zbfa) > 5
drop if abs(zhfa) > 6

*Summary Statistics 
bysort year: summarize gender age chldeth zbfa zhfa hhsize wi mumeduc fathereduc
*Categorical summary statistics 

gen NREGA = (region == 22 | region == 23)
gen Round1 = (year == 2002)
gen Round2 = (year == 2007)
gen Round3 = (year == 2010)
gen NREGAxRound2 = NREGA * Round2
gen NREGAxRound3 = NREGA * Round3

 
* Install reghdfe if not already installed
ssc install ftools
ssc install reghdfe
* Set the panel data structure if time is relevant
xtset CHILDID year  // Specify the time variable if available
save "thesispaneldata.dta", replace 

************Clustering Error at district level***************
*Short & Medium Term effects clustering error by district zhfa
xtreg zhfa NREGA Round2 NREGAxRound2 Round3 NREGAxRound3 gender age chldeth hhsize wi fathereduc mumeduc, fe vce(cluster districtid) 
outreg2 using mytable1.doc, replace word  

*Short & Medium Term effects clustering error by district zbfa
xtreg zbfa NREGA Round2 NREGAxRound2 Round3 NREGAxRound3 gender age chldeth hhsize wi fathereduc mumeduc, fe vce(cluster districtid)  
outreg2 using mytable1.doc, append word 

*Medium Term effects clustering error by district zwfa
xtreg zwfa NREGA Round3 NREGAxRound3 gender age chldeth hhsize wi fathereduc mumeduc,     fe vce(cluster districtid)
outreg2 using mytable1.doc, append word

************Clustering Error at mandal level***************
*Short & Medium Term effects clustering error by mandal
xtreg zhfa NREGA Round2 NREGAxRound2 Round3 NREGAxRound3 gender age chldeth hhsize wi fathereduc mumeduc, fe vce(cluster mandalid)  
outreg2 using mytable2.doc, replace word

xtreg zbfa NREGA Round2 NREGAxRound2 Round3 NREGAxRound3 gender age chldeth hhsize wi fathereduc mumeduc, fe vce(cluster mandalid)  
outreg2 using mytable2.doc, append word

xtreg zwfa NREGA Round3 NREGAxRound3 gender age chldeth hhsize wi fathereduc mumeduc,     fe vce(cluster mandalid)
outreg2 using mytable2.doc, append word 

*Differential effects by Gender 
****FEMALE****
keep if gender == 0
*Short & Medium Term effects clustering error by district zhfa
xtreg zhfa NREGA Round2 NREGAxRound2 Round3 NREGAxRound3 age chldeth hhsize wi fathereduc mumeduc, fe vce(cluster districtid) 
outreg2 using mytable3.doc, replace word  

*Short & Medium Term effects clustering error by district zbfa
xtreg zbfa NREGA Round2 NREGAxRound2 Round3 NREGAxRound3 age chldeth hhsize wi fathereduc mumeduc, fe vce(cluster districtid)  
outreg2 using mytable3.doc, append word 

*Medium Term effects clustering error by district zwfa
xtreg zwfa NREGA Round3 NREGAxRound3 age chldeth hhsize wi fathereduc mumeduc,     fe vce(cluster districtid)
outreg2 using mytable3.doc, append word

****MALE****
keep if gender == 1
*Short & Medium Term effects clustering error by district zhfa
xtreg zhfa NREGA Round2 NREGAxRound2 Round3 NREGAxRound3 age chldeth hhsize wi fathereduc mumeduc, fe vce(cluster districtid) 
outreg2 using mytable3.doc, append word  

*Short & Medium Term effects clustering error by district zbfa
xtreg zbfa NREGA Round2 NREGAxRound2 Round3 NREGAxRound3 age chldeth hhsize wi fathereduc mumeduc, fe vce(cluster districtid)  
outreg2 using mytable3.doc, append word 

*Medium Term effects clustering error by district zwfa
xtreg zwfa NREGA Round3 NREGAxRound3 age chldeth hhsize wi fathereduc mumeduc,     fe vce(cluster districtid)
outreg2 using mytable3.doc, append word

************Robustness Checks***************
use "thesispaneldata.dta", clear 
*Include Control, individual fixed effects, and pre-intervention control intercated with time 

*Creating interaction terms for each pre-intervention variable with time dummies
foreach var in gender age chldeth hhsize wi fathereduc mumeduc {
    foreach t in Round1 Round2 Round3 { 
        gen `var'_x_`t' = `var' * `t'
    }
}

*Short & Medium Term effects clustering error by district zhfa
xtreg zhfa NREGA Round2 NREGAxRound2 Round3 NREGAxRound3 gender age chldeth hhsize wi fathereduc mumeduc i.year##c.gender i.year##c.age i.year##c.chldeth i.year##c.hhsize i.year##c.wi i.year##c.fathereduc i.year##c.mumeduc, fe vce(cluster districtid) 
outreg2 using mytable4.doc, replace word  

*Short & Medium Term effects clustering error by district zbfa
xtreg zbfa NREGA Round2 NREGAxRound2 Round3 NREGAxRound3 gender age chldeth hhsize wi fathereduc mumeduc i.year##c.gender i.year##c.age i.year##c.chldeth i.year##c.hhsize i.year##c.wi i.year##c.fathereduc i.year##c.mumeduc, fe vce(cluster districtid)  
outreg2 using mytable4.doc, append word 

*Medium Term effects clustering error by district zwfa
xtreg zwfa NREGA Round3 NREGAxRound3 gender age chldeth hhsize wi fathereduc mumeduc i.year##c.gender i.year##c.age i.year##c.chldeth i.year##c.hhsize i.year##c.wi i.year##c.fathereduc i.year##c.mumeduc, fe vce(cluster districtid)
outreg2 using mytable4.doc, append word

*Clustering by mandal
*Done

*Appendix 
*Differential effects by Age Cohorts 
gen age_cohort = " "
replace age_cohort = "Older Cohort" if year == 2002 & age < 9
replace age_cohort = "Younger Cohort" if year == 2002 & age < 2

replace age_cohort = "Older Cohort" if year == 2007 & age < 13
replace age_cohort = "Younger Cohort" if year == 2007 & age < 6

replace age_cohort = "Older Cohort" if year == 2010 & age < 16
replace age_cohort = "Younger Cohort" if year == 2010 & age < 9

save "thesispaneldata.dta", replace
* Creating an age cohort dummy variable (1 if older, 0 if younger)
gen agecohort = age_cohort == "Older Cohort"

keep if agecohort == 0

xtreg zhfa NREGA Round2 NREGAxRound2 Round3 NREGAxRound3 gender age chldeth hhsize wi fathereduc mumeduc, fe vce(cluster districtid) 
outreg2 using mytable5.doc, replace word  

*Short & Medium Term effects clustering error by district zbfa
xtreg zbfa NREGA Round2 NREGAxRound2 Round3 NREGAxRound3 gender age chldeth hhsize wi fathereduc mumeduc, fe vce(cluster districtid)  
outreg2 using mytable5.doc, append word 

*Medium Term effects clustering error by district zwfa
xtreg zwfa NREGA Round3 NREGAxRound3 gender age chldeth hhsize wi fathereduc mumeduc,     fe vce(cluster districtid)
outreg2 using mytable5.doc, append word

use "thesispaneldata.dta", clear
gen agecohort = age_cohort == "Older Cohort"
keep if agecohort == 1

xtreg zhfa NREGA Round2 NREGAxRound2 Round3 NREGAxRound3 gender age chldeth hhsize wi fathereduc mumeduc, fe vce(cluster districtid) 
outreg2 using mytable6.doc, replace word  

*Short & Medium Term effects clustering error by district zbfa
xtreg zbfa NREGA Round2 NREGAxRound2 Round3 NREGAxRound3 gender age chldeth hhsize wi fathereduc mumeduc, fe vce(cluster districtid)  
outreg2 using mytable6.doc, append word 

*Medium Term effects clustering error by district zwfa
xtreg zwfa NREGA Round3 NREGAxRound3 gender age chldeth hhsize wi fathereduc mumeduc,     fe vce(cluster districtid)
outreg2 using mytable6.doc, append word
  
use "thesispaneldata.dta", clear
twoway kdensity zhfa if year == 2002, lcolor(blue) lpattern(solid) lwidth(thick) ///
    legend(label(1 "Pre-Intervention (Round 1)")) ///
|| kdensity zhfa if year == 2010, lcolor(ltblue) lpattern(solid) lwidth(thick) ///
    legend(label(2 "Post-Intervention (Round 3)")) ///
xlabel(-3(1)3) ylabel(0(0.1)0.4) ///
title("Height-for-Age Z Scores Pre- and Post-Intervention") ///
legend(order(1 2))

twoway kdensity zwfa if year == 2002, lcolor(blue) lpattern(solid) lwidth(thick) ///
    legend(label(1 "Pre-Intervention (Round 1)")) ///
|| kdensity zhfa if year == 2010, lcolor(ltblue) lpattern(solid) lwidth(thick) ///
    legend(label(2 "Post-Intervention (Round 3)")) ///
xlabel(-3(1)3) ylabel(0(0.1)0.4) ///
title("Weight-for-Age Z Scores Pre- and Post-Intervention") ///
legend(order(1 2))

graph box zhfa if , over(gender) ///
title("Height-for-Age Z Scores by Gender in Year 2002") ///
ylabel(, angle(horizontal)) ///

graph box zhfa if year == 2002, over(gender) ///
title("Height-for-Age Z Scores by Gender in Year 2002") ///
ylabel(, angle(horizontal)) ///
ytitle("Height-for-Age Z Score") xtitle("Gender")

// Kernel Density Plot for both genders
twoway kdensity zhfa if gender == 0 & year == 2002, lcolor(blue) ///
       legend(label(1 "Male")) ///
    || kdensity zhfa if gender == 1 & year == 2002, lcolor(orange) ///
       legend(label(2 "Female")) ///
    title("Height-for-Age Z Scores Density by Gender in Year 2002")
ylabel(, angle(horizontal)) xlabel(-5(1)5)

// Create a box plot for a specific year, grouped by gender
graph box zhfa if year == 2002, over(gender) ///
title("Height-for-Age Z Scores by Gender in Year 2002") ///
ylabel(, angle(horizontal)) ///
ytitle("Height-for-Age Z Score") ///
box(1, lcolor(blue)) ///
box(2, lcolor(ltblue))








































































