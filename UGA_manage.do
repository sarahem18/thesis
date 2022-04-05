*** Sarah McNitt
*** UGA 2016 CCES Module data management
*** requires: CCES16_UGA_OUTPUT_Feb2017.dta
*** output: data appropriate for merge and analysis a la Huckfeldt 2004
*** last updated: 4/4/2022

use "/Users/sarahmcnitt/Desktop/replication 1/uga_2016/CCES16_UGA_OUTPUT_Feb2017.dta"
cd "/Users/sarahmcnitt/Desktop/thesis"

* dropping all but common content and name generator battery
drop UGA*
* name generator coded as UCD
rename UCD* UGA*

* respondent vote choice, 1 = Trump, 0 = Clinton, 2 = Other
recode CC16_410a 1=1 2=0 3/5 8=2 *=., gen(Rvote)

* does discussant 1, 2, and 3 exist?
recode UGA401_1 .=0 *=1, gen(disc1)
recode UGA401_2 .=0 *=1, gen(disc2)
recode UGA401_3 .=0 *=1, gen(disc3)

gen disc_total_orig = disc1 + disc2 + disc3

* combinations of which discussants exist, necessary to reorder
gen disc_combo=.
replace disc_combo = 1 if disc1==1 & disc2==1 & disc3==1
replace disc_combo = 2 if disc1==1 & disc2==1 & disc3==0
replace disc_combo = 3 if disc1==1 & disc2==0 & disc3==0
replace disc_combo = 4 if disc1==0 & disc2==1 & disc3==1
replace disc_combo = 5 if disc1==1 & disc2==0 & disc3==1
replace disc_combo = 6 if disc1==0 & disc2==1 & disc3==0
replace disc_combo = 7 if disc1==0 & disc2==0 & disc3==1

label define exist_label 1 "1.123" 2 "2.12" 3 "3.1" 4 "4.23" 5 "5.13" 6 "6.2" 7 "7.3"
label values disc_combo exist_label

* reordering discussants
gen new_disc1 =.
replace new_disc1 = disc1 if disc_combo==1 | disc_combo==2 | disc_combo==3 | disc_combo==5
replace new_disc1 = disc2 if disc_combo==4 | disc_combo==6
replace new_disc1 = disc3 if disc_combo==7
replace new_disc1 = 0 if new_disc1==.

gen new_disc2 =.
replace new_disc2 = disc2 if disc_combo==1 | disc_combo==2
replace new_disc2 = disc3 if disc_combo==4 | disc_combo==5
replace new_disc2=0 if new_disc2 ==.

gen new_disc3=.
replace new_disc3 = disc3 if disc_combo==1
replace new_disc3 = 0 if new_disc3==.

gen disc_total = new_disc1 + new_disc2 + new_disc3

* reordering vote choice of discussants to match new discussants
gen vote_disc1 =.
replace vote_disc1 = UGA405A if disc_combo==1 | disc_combo==2 | disc_combo==3 | disc_combo==5
replace vote_disc1 = UGA405B if disc_combo==4 | disc_combo==6
replace vote_disc1 = UGA405C if disc_combo==7
replace vote_disc1 = 0 if vote_disc1 == .

gen vote_disc2 =.
replace vote_disc2 = UGA405B if disc_combo==1 | disc_combo==2
replace vote_disc2 = UGA405C if disc_combo==4 | disc_combo==5
replace vote_disc2 = 0 if vote_disc2 == .

gen vote_disc3=.
replace vote_disc3 = UGA405C if disc_combo==1
replace vote_disc3 = 0 if vote_disc3 == .

* source indicator
gen dsource = 2
label define sources 1 "ucd" 2 "uga" 3 "fsu" 4 "nuc"
label values dsource sources
save "uga ready for merge.dta", replace
