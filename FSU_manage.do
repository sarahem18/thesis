*** Sarah McNitt
*** FSU 2016 CCES Module data management
*** requires: CCES16_FSU_OUTPUT_Feb2017.dta
*** output: .dta
*** last updated: 4/4/2022

cd "/Users/sarahmcnitt/Desktop/thesis"
use "CCES16_FSU_OUTPUT_Feb2017.dta"

* dropping common content and name generator battery
drop FSU33* FSU34* FSU35* FSU4* timing*

*respondent vote choice, 1 = Trump, 0 = Clinton, 2 = Other
recode CC16_410a 1=1 2=0 3/5 8=2 *=., gen(Rvote)

* reorder discussants to prepare to drop 4th discussant from sample
recode FSU322 .=0 *=1, gen(disc1)
recode FSU323 .=0 *=1, gen(disc2)
recode FSU324 .=0 *=1, gen(disc3)
recode FSU325 .=0 *=1, gen(disc4)

gen disc_total_orig = disc1 + disc2 + disc3 + disc4

gen disc_combo=.
replace disc_combo = 1 if disc1==1 & disc2==1 & disc3==1 & disc4==1
replace disc_combo = 2 if disc1==1 & disc2==1 & disc3==1 & disc4==0
replace disc_combo = 3 if disc1==1 & disc2==1 & disc3==0 & disc4==0
replace disc_combo = 4 if disc1==1 & disc2==0 & disc3==0 & disc4==0
replace disc_combo = 5 if disc1==0 & disc2==1 & disc3==1 & disc4==1
replace disc_combo = 6 if disc1==0 & disc2==0 & disc3==1 & disc4==1
replace disc_combo = 7 if disc1==0 & disc2==1 & disc3==0 & disc4==0
replace disc_combo = 8 if disc1==0 & disc2==0 & disc3==1 & disc4==0
replace disc_combo = 9 if disc1==0 & disc2==0 & disc3==0 & disc4==1
replace disc_combo = 10 if disc1==0 & disc2==1 & disc3==0 & disc4==1
replace disc_combo = 11 if disc1==1 & disc2==0 & disc3==0 & disc4==1
replace disc_combo = 12 if disc1==1 & disc2==0 & disc3==1 & disc4==0
replace disc_combo = 13 if disc1==1 & disc2==1 & disc3==0 & disc4==1

label define exist_label 1 "1.1234" 2 "2.123" 3 "3.12" 4 "4.1" 5 "5.234" 6 "6.34" 7 "7.2" 8 "8.3" 9 "9.4" 10 "10.24" 11 "11.14" 12 "12.13" 13"13.124"
label values disc_combo exist_label

* reordering discussants
gen new_disc1 =.
replace new_disc1 = disc1 if disc_combo ==1 | disc_combo ==2 | disc_combo ==3 | disc_combo ==4 | disc_combo ==11 | disc_combo ==12 | disc_combo ==13
replace new_disc1 = disc2 if disc_combo ==5 | disc_combo ==7 | disc_combo ==10
replace new_disc1 = disc3 if disc_combo==6 | disc_combo==8
replace new_disc1 = disc4 if disc_combo==9
replace new_disc1 = 0 if new_disc1 == .

gen new_disc2 =.
replace new_disc2 = disc2 if disc_combo==1 | disc_combo==2 | disc_combo==3 | disc_combo ==13
replace new_disc2 = disc3 if disc_combo == 5 | disc_combo==12
replace new_disc2 = disc4 if disc_combo == 6 | disc_combo==11
replace new_disc2 = 0 if new_disc2 == .

gen new_disc3 = .
replace new_disc3 = disc3 if disc_combo == 1 | disc_combo == 2
replace new_disc3 = disc4 if disc_combo == 5 | disc_combo ==13
replace new_disc3 = 0 if new_disc3 == .

gen new_disc4 = .
replace new_disc4 = disc4 if disc_combo==1
replace new_disc4 = 0 if new_disc4 == .

gen disc_total = new_disc1 + new_disc2 + new_disc3

** matching vote choice to discussant in new order
* 1 = vote for Trump, 0 = vote for Clinton
gen vote_disc1 =.
replace vote_disc1 = FSU318 if disc_combo ==1 | disc_combo ==2 | disc_combo ==3 | disc_combo ==4 | disc_combo ==11 | disc_combo ==12 | disc_combo ==13
replace vote_disc1 = FSU319 if disc_combo ==5 | disc_combo ==7 | disc_combo ==10
replace vote_disc1 = FSU320 if disc_combo==6 | disc_combo==8
replace vote_disc1 = FSU321 if disc_combo==9

gen vote_disc2 =.
replace vote_disc2 = FSU319 if disc_combo==1 | disc_combo==2 | disc_combo==3 | disc_combo ==13
replace vote_disc2 = FSU320 if disc_combo == 5 | disc_combo==12
replace vote_disc2 = FSU321 if disc_combo == 6 | disc_combo==11

gen vote_disc3 = .
replace vote_disc3 = FSU320 if disc_combo == 1 | disc_combo == 2
replace vote_disc3 = FSU321 if disc_combo == 5 | disc_combo ==13

gen vote_disc4 = .
replace vote_disc4 = FSU321 if disc_combo==1

** adding source variable
gen dsource = 3
label define sources 1 "ucd" 2 "uga" 3 "fsu" 4 "nuc"
label values dsource sources
save "fsu ready to merge.dta", replace
