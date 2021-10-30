*** Sarah McNitt
*** Huckfeldt, Mendez, and Osborn (2004) replication
*** requires: data management files
*** output: 8 tables
*** StataIC 16, macOS
*** last updated: 10/27/21

do "/Users/sarahmcnitt/Desktop/thesis/UCD_manage.do"
do "/Users/sarahmcnitt/Desktop/thesis/UGA_manage.do"
do "/Users/sarahmcnitt/Desktop/thesis/NUC_manage.do"
do "/Users/sarahmcnitt/Desktop/thesis/FSU_manage.do"
do "/Users/sarahmcnitt/Desktop/thesis/merge management.do"

use "/Users/sarahmcnitt/Desktop/thesis/2016 merge SN.dta"

** Table 1
tab clint_total Rvote, nof col
tab trump_total Rvote, nof col
tab clint_total trump_total, nof cell

** Table 2 
tab Rvote disc_total if all_match==1
table Rvote named_match, c(mean dy_match_prop count dy_match_prop) format(%9.2f)

** Table 3 - negative binomial regression, moving forward without doing dislikes for either candidate
nbreg trump_likes educ age new_pid newsppr newstv clint_total trump_total pol_know, difficult
eststo
nbreg clint_likes educ age new_pid newsppr newstv clint_total trump_total pol_know, difficult
eststo
esttab using table3.tex, b(2)

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

esttab using table5.tex, nostar wide compress

eststo clear

** Table 6
nbreg trump_likes educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know, difficult
table trump_total clint_total, c(mean trump_likes) format(%9.2f)
nbreg clint_likes educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know, difficult
table trump_total clint_total, c(mean clint_likes) format(%9.2f)

nbreg polar_trump educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know, difficult
table trump_total clint_total, c(mean polar_trump) format(%9.2f)
nbreg polar_clint educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know, difficult
table trump_total clint_total, c(mean polar_clint) format(%9.2f)

reg ambiv_trump educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know
table trump_total clint_total, c(mean ambiv_trump) format(%9.2f)
reg ambiv_clint educ age extremity newsppr newstv clint_total trump_total c.clint_total#c.trump_total pol_know
table trump_total clint_total, c(mean ambiv_clint) format(%9.2f)


** Table 7
* without the organizationl involvement variable, no appropriate proxy found
eststo clear
ologit interest extremity dem_dummy rep_dummy educ church newsppr newstv clint_total trump_total c.dem_dummy#c.clint_total c.dem_dummy#c.trump_total c.rep_dummy#c.clint_total c.rep_dummy#c.trump_total c.clint_total#c.trump_total
eststo interest

logit voted extremity dem_dummy rep_dummy educ church newsppr newstv clint_total trump_total c.dem_dummy#c.clint_total c.dem_dummy#c.trump_total c.rep_dummy#c.clint_total c.rep_dummy#c.trump_total c.clint_total#c.trump_total
eststo voted

esttab using table7.tex, nostar wide b(2)


** Table 8
ologit interest extremity dem_dummy rep_dummy educ church newsppr newstv clint_total trump_total c.dem_dummy#c.clint_total c.dem_dummy#c.trump_total c.rep_dummy#c.clint_total c.rep_dummy#c.trump_total c.clint_total#c.trump_total
predict pred_interest
table trump_total clint_total, c(mean pred_interest) format(%9.2f)

logit voted extremity dem_dummy rep_dummy educ church newsppr newstv clint_total trump_total c.dem_dummy#c.clint_total c.dem_dummy#c.trump_total c.rep_dummy#c.clint_total c.rep_dummy#c.trump_total c.clint_total#c.trump_total
predict pred_voted 
table trump_total clint_total, c(mean pred_voted) format(%9.2f)


