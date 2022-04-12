*** Sarah McNitt
*** NES and ACS management
*** requires: anes_timeseries_cdf_stata_20211118.dta, ACS0519.dta
*** output: .dta
*** last updated: 4/11/22

cd "/Users/sarahmcnitt/Desktop/thesis"

use "anes_timeseries_cdf_stata_20211118.dta", clear

*** only keeping 2008-2016 elections as ACS is only available for 2005-2019
*rename VCF0004 year
recode year 2008 2012 2016=1 *=0, gen(presyear)
drop if presyear==0
rename VCF0901a fips

merge m:m fips year using "ACS0519.dta"
save "nes acs 0816.dta", replace

keep year VCF0105b VCF0114 VCF0140 VCF0113 VCF0301 VCF0702 VCF0704a fips VCF0707 total black_est

lab var total "ACS Total Population Estimate"
lab var black_est "ACS Black Population Estimate"

*** race
** 1 = White 2 = Black 3 = Hispanic 4 = Other or multiple races, non-hispanic
tab VCF0105b
recode VCF0105b 9=., gen(race)

*** family income, percentiles adjusted for inflation
tab VCF0114
recode VCF0114 0=., gen(faminc_pctl)

*** education
** 1 = no HS diploma 2 = HS diploma 3 = some college 4 = BA+
tab VCF0140
recode VCF0140 1/2=1 3/4=2 5=3 6=4 *=., gen(educ)

*** Political South/Non-South
** 1 = South 2 = Non-South
rename VCF0113 region

*** Party identification
** 0 = Democrat (leaners, weak, and strong), 1  = Independent, 2 = Republican (leaners, weak, and strong)
tab VCF0301
recode VCF0301 1/3=0 4=1 5/7=2 *=., gen(pid3)

*** Black population composition 
gen comp = (black_est/total)*100
** composition rounded to nearest decimal and whole number
gen roundcomp = round(comp, 0.1)
gen wholecomp = round(comp, 1)

*** Voting Behavior
** Vote, 0 = did not vote, 1 = voted
tab VCF0702
recode VCF0702 1=0 2=1 *=., gen(voted)

** Vote Choice, 0 = Republican, 1 = Democrat
tab VCF0704a
recode VCF0704a 2=0 1=1 *=., gen(party)

save "nes acs 0816.dta", replace
