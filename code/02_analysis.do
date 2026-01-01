
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