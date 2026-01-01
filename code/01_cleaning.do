***************************
******Cleaning*********
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
