*** Sarah McNitt
*** Huckfeldt, Mendez, and Osborn (2004) replication
*** requires: 2016 cces merge final.dta, UCD_manage.do, UGA_manage.do, NUC_manage.do, FSU_manage.do, cces merge management.do
*** output: .tex, .png
*** last updated: 4/6/21

cd "/Users/sarahmcnitt/Desktop/thesis"

do "UCD_manage.do"
do "UGA_manage.do"
do "NUC_manage.do"
do "FSU_manage.do"
do "cces merge management.do"

use "2016 cces merge final.dta", clear

** Table 1
tab clint_total Rvote if disc_total>0, nof col
tab trump_total Rvote if disc_total>0, nof col
tab clint_total trump_total if disc_total>0, nof ce

** Table 2 
tab Rvote disc_total if all_match==1, ce
table (Rvote) (named_match), statistic(count named_match) statistic(perc named_match)

** Tables 3 and 4 - omits dislikes for either candidate
reg trump_likes educ age new_pid newsppr newstv clint_total trump_total pol_know
eststo
predict count_trump
table (trump_total) (clint_total), statistic(mean count_trump) nformat(%5.2f)

reg clint_likes educ age new_pid newsppr newstv clint_total trump_total pol_know
eststo
predict count_clint
table (trump_total) (clint_total), statistic(mean count_clint) nformat(%5.2f)

esttab using table3.tex, b(2) nostar wide r2
eststo clear

** Tables 5 and 6
* intensity
reg trump_likes educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know
eststo ti
predict pred_it
table (trump_total) (clint_total), statistic(mean pred_it) nformat(%5.2f)

reg clint_likes educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know
eststo ci
predict pred_ic
table (trump_total) (clint_total), statistic(mean pred_ic) nformat(%5.2f)

* polarization - identical results due to no dislikes vars
reg polar_trump educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know
eststo tp
predict pred_pt
table (trump_total) (clint_total), statistic(mean pred_pt) nformat(%5.2f)

reg polar_clint educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know
eststo cp
predict pred_pc

* ambivalence
reg ambiv_trump educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know
eststo ta
predict pred_at
table (trump_total) (clint_total), statistic(mean pred_at) nformat(%5.2f)

reg ambiv_clint educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know
eststo ca
predict pred_ac
table (trump_total) (clint_total), statistic(mean pred_ac) nformat(%5.2f)

esttab using table5.tex, b(2) nosta r2
eststo clear

** Tables 7 and 8 - omits the organizationl involvement var, no appropriate proxy found
* political interest
ologit interest extremity dem_dummy rep_dummy educ church newsppr newstv clint_total trump_total c.dem_dummy#c.clint_total c.dem_dummy#c.trump_total c.rep_dummy#c.clint_total c.rep_dummy#c.trump_total c.clint_total#c.trump_total
eststo interest
predict pred_interest
table (trump_total) (clint_total), statistic(mean pred_interest) nformat(%5.2f)

* turnout
logit voted extremity dem_dummy rep_dummy educ church newsppr newstv clint_total trump_total c.dem_dummy#c.clint_total c.dem_dummy#c.trump_total c.rep_dummy#c.clint_total c.rep_dummy#c.trump_total c.clint_total#c.trump_total
eststo voted
predict pred_voted 
table (trump_total) (clint_total), statistic(mean pred_voted) nformat(%5.2f)

esttab using table7.tex, b(2) nostar wide 
eststo clear
