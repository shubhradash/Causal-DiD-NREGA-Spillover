*******************************
******Robustness Checks********
*******************************

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