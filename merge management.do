*** Sarah McNitt
*** output: merged CCES common content and module dataset
*** last updated: 11/5/2021

* merge modules on V101, won't technically merge, basically appends without needing identical data structure
use "/Users/sarahmcnitt/Desktop/working/ucd working.dta", clear
* N = 1000
merge 1:1 V101 using "/Users/sarahmcnitt/Desktop/working/uga working.dta"
save "/Users/sarahmcnitt/Desktop/working/ucd and uga merge.dta", replace
* N = 2000

use "/Users/sarahmcnitt/Desktop/working/ucd and uga merge.dta", clear
rename _merge _m1
merge 1:1 V101 using "/Users/sarahmcnitt/Desktop/working/fsu working.dta"
save "/Users/sarahmcnitt/Desktop/working/ucd uga fsu merge.dta", replace
* N = 3000

use "/Users/sarahmcnitt/Desktop/working/ucd uga fsu merge.dta", clear
rename _merge _m2
merge 1:1 V101 using "/Users/sarahmcnitt/Desktop/working/nuc working.dta"
save "/Users/sarahmcnitt/Desktop/working/2016 merge CCES.dta", replace
* N = 4000

** newly created variables for analysis
* total number of discussants for each candidate
foreach x in 1 2 3 {
	recode vote_disc`x' 1=0 2=1 *=0, gen(trump_disc`x')
	recode vote_disc`x' 1=1 2=0 *=0, gen(clint_disc`x')
}

gen trump_total = trump_disc1 + trump_disc2 + trump_disc3
gen clint_total = clint_disc1 + clint_disc2 + clint_disc3

* all respondents have the same presidential preference as respondent
gen all_match_trump =.
replace all_match_trump = 1 if trump_disc1 == 1 & trump_disc2 == 1 & trump_disc3 == 1 & Rvote==1 & disc_total==3
replace all_match_trump = 1 if trump_disc1 == 1 & trump_disc2 == 1 & Rvote==1 & disc_total==2
replace all_match_trump = 1 if trump_disc1 == 1 & Rvote==1 & disc_total==1
replace all_match_trump = 0 if all_match_trump == .

gen all_match_clint = .
replace all_match_clint = 1 if clint_disc1 == 1 & clint_disc2 == 1 & clint_disc3 == 1 & Rvote==0 & disc_total==3
replace all_match_clint = 1 if clint_disc1 == 1 & clint_disc2 == 1 & Rvote==0 & disc_total==2 
replace all_match_clint = 1 if clint_disc1 == 1 & Rvote==0 & disc_total==1
replace all_match_clint = 0 if all_match_clint==.

gen all_match=0
replace all_match = 1 if all_match_clint == 1 | all_match_trump==1

* COME BACK TO THIS
* number of dyads that share presidential preference, Rvote: 0 = clinton, 1 = trump
gen dy_match_trump = 0
replace dy_match_trump = 1 if trump_disc1 == 1 & Rvote==1
replace dy_match_trump = dy_match_trump+1 if trump_disc2 == 1 & Rvote==1
replace dy_match_trump = dy_match_trump+1 if trump_disc3 == 1 & Rvote==1

gen dy_match_clint = 0
replace dy_match_clint = 1 if clint_disc1 == 1 & Rvote==0
replace dy_match_clint = dy_match_clint+1 if clint_disc2 == 1 & Rvote==0
replace dy_match_clint = dy_match_clint+1 if clint_disc3 == 1 & Rvote==0

gen dy_match = 0
replace dy_match = dy_match_trump if Rvote==1
replace dy_match = dy_match_clint if Rvote==0

* order in which discussant is named, only for those who match Rvote
gen disc1_match=.
replace disc1_match=1 if new_disc1==1 & dy_match==1
replace disc1_match=0 if disc1_match==.

gen disc2_match=.
replace disc2_match=1 if new_disc2==1 & dy_match==1
replace disc2_match=0 if disc2_match==.

gen disc3_match=.
replace disc3_match=1 if new_disc3==1 & dy_match==1
replace disc3_match=0 if disc3_match==. 

gen named_match = .
replace named_match = 1 if disc1_match==1
replace named_match = 2 if disc2_match==1
replace named_match = 3 if disc3_match==1

** common content variables
* demos
gen age=2016-birthyr
* no management for educ
* scale from 0-6 with 0 = Strong Democrat
recode pid7 1=0 2=1 3=2 4=3 5=4 6=5 7=6 *=., gen(new_pid)

** controls (exclduing organizational involvement)
* dichotomous partisanship variables
recode CC16_360 2=1 *=0, gen(dem_dummy)
recode CC16_360 3=1 *=0, gen(rep_dummy)

* partisan extremity
recode pid7 1 7=3 2 6=2 3 5=1 4=0 8=., gen(extremity)

* political knowledge
recode CC16_321a 1=1 *=0, gen(pk1)
recode CC16_321b 1=1 *=0, gen(pk2)
gen pol_know = pk1 + pk2

* read newspaper and watch national news, doesn't measure frequency
recode CC16_300_3 2=0, gen(newsppr)
recode CC16_300b 1=0 2/3=1, gen(newstv)

* attends church
recode pew_churatd 7=., gen(church)

* likes and dislikes about Trump and Clinton, the policies on which to match are chosen by what the candidate's party has deemed a priority
* policy match with Trump or Clinton
* Trump's position = 1, Clinton's = 0
recode CC16_337_3 3=1 *=0, gen(tax_stance)
recode CC16_331_7 1=1 2=0, gen(imm_stance)
recode CC16_351I 1=1 2=0, gen(aca_stance)
gen trump_likes =  tax_stance + imm_stance + aca_stance

* Clinton's postion = 1, Trump's = 0
recode CC16_330a 1=1 2=0, gen(gun_stance)
recode CC16_332a 1=1 2=0, gen(abort_stance)
recode CC16_333a 1=1 2=0, gen(epa_stance)
gen clint_likes = gun_stance + abort_stance + epa_stance

* polarization
gen polar_trump = abs(trump_likes-clint_likes)
gen polar_clint = abs(clint_likes-trump_likes)
* intensity = likes, bc i don't have proxy for dislikes, so intensity_candidate = cand_likes
* ambivalence = .5(intensity)-polarization
gen ambiv_trump = 0.5*(trump_likes)-polar_trump
gen ambiv_clint = 0.5*(clint_likes)-polar_clint

** regression dependent variables
* voted in 2016
recode CC16_401 5=1 *=0, gen(voted)
* political interest
recode newsint 7=., gen(interest)

save "/Users/sarahmcnitt/Desktop/working/2016 merge CCES.dta", replace
