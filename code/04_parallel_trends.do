use "C:\Users\HP\AppData\Local\Temp\b2cdb24e-be3e-4725-befa-72adff15534b_ICPSR_22626-V12.zip.34b\ICPSR_22626\DS0001\22626-0001-Data.dt


keep if STATEID == 28

capture drop phase
gen phase = 0
replace phase = 1 if DISTID == 20
replace phase = 1 if DISTID == 22
replace phase = 1 if DISTID == 7
replace phase = 1 if DISTID == 3

replace phase = 2 if DISTID == 15
drop if phase == 0

* Step 1: Prepare your dataset
* Make sure you have a panel dataset with phases and outcome variables
label list URBAN
keep if URBAN == 0

* Step 1: Filter the dataset to include only phase 1 and phase 2 districts
keep if phase == 1 | phase == 2
rename RO5 Age 
keep if Age < 10

* Step 2: Calculate average height for each age group by phase
bysort phase Age: egen Average_Height = mean(AP2)
bysort phase Age: egen Average_Weight = mean(AP4)

* Step 3: Plot parallel trends graphs
	   
	   twoway (line Average_Height Age if phase == 1, lcolor(blue) lpattern(solid) lwidth(thick) ///
             legend(label(1 "Phase 1 Districts"))) ///
        (line Average_Height Age if phase == 2, lcolor(ltblue) lpattern(solid) lwidth(thick) ///
             legend(label(2 "Phase 3 District"))) ///
        , ///
        title("Parallel Trends in Average Height") ///
		ytitle("Height") ///
		xtitle("Age")
        ylabel(, format(%9.2f)) xlabel(, labsize(small))

	   twoway (line Average_Weight Age if phase == 1, lcolor(blue) lpattern(solid) lwidth(thick) ///
             legend(label(1 "Phase 1 Districts"))) ///
        (line Average_Weight Age if phase == 2, lcolor(ltblue) lpattern(solid) lwidth(thick) ///
             legend(label(2 "Phase 3 District"))) ///
        , ///
        title("Parallel Trends in Average Weight") ///
		ytitle("Weight") ///
		xtitle("Age")
        ylabel(, format(%9.2f)) xlabel(, labsize(small))

* Step 2: Generate group-specific means over phases
egen Height = mean(AP2) , by(phase)
egen Weight = mean(AP4) , by(phase)
*RO5 = 4/5 OR 11/12
keep if RO5 > 0 & RO5 <12


collapse (mean) AP2, by(Age)
collapse (mean) AP4, by(Age)

twoway (line height age, lcolor(blue) lpattern(solid)), ///
       title("Mean Height by Age for Rural Andhra Pradesh (2005)") ///
       xtitle("Age") ytitle("Mean Height")




* Step 3: Plot parallel trends graph
	   
	   scatter Age Height if phase == 1, msymbol(circle) mcolor(blue) ///
    || scatter Age Height if phase == 2, msymbol(square) mcolor(green) ///
    , xlabel(Age) ylabel("Average Height") ///
    legend(label(1 "Phase 1") label(2 "Phase 2")) ///
    title("Parallel Trends: Average Height by Age for Phase 1 and Phase 2 Districts")