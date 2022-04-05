*** Sarah McNitt
*** Huckfeldt, Mendez, and Osborn (2004) replication
*** requires: data management files
*** output: 8 tables
*** StataIC 16, macOS
*** last updated: 10/27/21

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

** Table 3 - negative binomial regression, moving forward without doing dislikes for either candidate
nbreg trump_likes educ age new_pid newsppr newstv clint_total trump_total pol_know, difficult
eststo
nbreg clint_likes educ age new_pid newsppr newstv clint_total trump_total pol_know, difficult
eststo
esttab using table3.tex, b(2) nostar wide
eststo clear

** Table 4
nbreg trump_likes educ age new_pid newsppr newstv clint_total trump_total pol_know, difficult
predict count_trump, n
table trump_total clint_total, c(mean count_trump) format(%9.2f)
nbreg clint_likes educ age new_pid newsppr newstv clint_total trump_total pol_know, difficult
predict count_clint, n
table trump_total clint_total, c(mean count_clint) format(%9.2f)


** Table 5
* intensity nbreg
nbreg trump_likes educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know, difficult
eststo ti
nbreg clint_likes educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know, difficult
eststo ci

* polarization, identical results bc no proxy for dislikes
nbreg polar_trump educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know, difficult
eststo tp
nbreg polar_clint educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know, difficult
eststo cp

* ambivalence
reg ambiv_trump educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know
eststo ta
reg ambiv_clint educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know
eststo ca
esttab using table5.tex, b(2) nostar
eststo clear

** Table 6
nbreg trump_likes educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know, difficult
predict pred_it
table trump_total clint_total, c(mean pred_it) format(%9.2f)
nbreg clint_likes educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know, difficult
predict pred_ic
table trump_total clint_total, c(mean pred_ic) format(%9.2f)

nbreg polar_trump educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know, difficult
predict pred_pt
table trump_total clint_total, c(mean pred_pt) format(%9.2f)
nbreg polar_clint educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know, difficult
predict pred_pc
table trump_total clint_total, c(mean pred_pc) format(%9.2f)

reg ambiv_trump educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know
predict pred_at
table trump_total clint_total, c(mean pred_at) format(%9.2f)
reg ambiv_clint educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know
predict pred_ac
table trump_total clint_total, c(mean pred_ac) format(%9.2f)


** Table 7
* without the organizationl involvement variable, no appropriate proxy found
ologit interest extremity dem_dummy rep_dummy educ church newsppr newstv clint_total trump_total c.dem_dummy#c.clint_total c.dem_dummy#c.trump_total c.rep_dummy#c.clint_total c.rep_dummy#c.trump_total c.clint_total#c.trump_total
eststo interest

logit voted extremity dem_dummy rep_dummy educ church newsppr newstv clint_total trump_total c.dem_dummy#c.clint_total c.dem_dummy#c.trump_total c.rep_dummy#c.clint_total c.rep_dummy#c.trump_total c.clint_total#c.trump_total
eststo voted

esttab using table7.tex, b(2) nostar wide 


** Table 8
ologit interest extremity dem_dummy rep_dummy educ church newsppr newstv clint_total trump_total c.dem_dummy#c.clint_total c.dem_dummy#c.trump_total c.rep_dummy#c.clint_total c.rep_dummy#c.trump_total c.clint_total#c.trump_total
predict pred_interest
table trump_total clint_total, c(mean pred_interest) format(%9.2f)

logit voted extremity dem_dummy rep_dummy educ church newsppr newstv clint_total trump_total c.dem_dummy#c.clint_total c.dem_dummy#c.trump_total c.rep_dummy#c.clint_total c.rep_dummy#c.trump_total c.clint_total#c.trump_total
predict pred_voted 
table trump_total clint_total, c(mean pred_voted) format(%9.2f)

