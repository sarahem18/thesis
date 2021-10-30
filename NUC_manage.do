*** Sarah McNitt
*** NU and CU 2016 CCES Module data management
*** requires: CCES16_NUC_OUTPUT_Feb2017.dta
*** output: data appropriate for merge and analysis a la Huckfeldt 2004

use "/Users/sarahmcnitt/Desktop/replication 1/cub_16/CCES16_NUC_OUTPUT_Feb2017.dta"

* dropping all but common content and name generator battery
drop NUC3J* NUC37* NUC38* NUC39* NUC4J* NUC400* NUC47* 

** cleaning and creating variables for table 1
recode CC16_410a 1=1 2=0 3/5 8=2 *=., gen(Rvote)
* 0 = Trump, 1 = Clinton, 2=Other

recode NUC3A13 2=1 *=0, gen(trump_disc1)
recode NUC3A14 2=1 *=0, gen(trump_disc2)
recode NUC3A15 2=1 *=0, gen(trump_disc3)

recode NUC3A13 1=1 *=0, gen(clint_disc1)
recode NUC3A14 1=1 *=0, gen(clint_disc2)
recode NUC3A15 1=1 *=0, gen(clint_disc3)

gen trump_total = trump_disc1 + trump_disc2 + trump_disc3
gen clint_total = clint_disc2 + clint_disc2 + clint_disc3

save "/Users/sarahmcnitt/Desktop/working/nuc working.dta", replace


** variables for table 2
recode NUC3A16 .=0 *=1, gen(disc1)
recode NUC3A17 .=0 *=1, gen(disc2)
recode NUC3A18 .=0 *=1, gen(disc3)

gen disc_total = disc1 + disc2 + disc3

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


gen new_disc1 =.
replace new_disc1 = disc1 if disc_combo ==1 | disc_combo ==2 | disc_combo ==3 | disc_combo ==5
replace new_disc1 = disc2 if disc_combo ==4 | disc_combo ==6
replace new_disc1 = disc3 if disc_combo==7

gen new_disc2 =.
replace new_disc2 = disc2 if disc_combo==1 | disc_combo==2
replace new_disc2 = disc3 if disc_combo == 4 | disc_combo==5

gen new_disc3=.
replace new_disc3 = disc3 if disc_combo==1

gen named_1=.
replace named_1 = 1 if new_disc1==1
replace named_1 = 0 if new_disc1==.

gen named_2=.
replace named_2 = 1 if new_disc2==1
replace named_2 = 0 if new_disc2==.

gen named_3=.
replace named_3 = 1 if new_disc3==1
replace named_3 = 0 if new_disc3==.

save "/Users/sarahmcnitt/Desktop/working/nuc working.dta", replace

* % of NWs with all discussants perceived to match vote choice of Respondent, come back to this
* when Rvote = Trump, discA-C must also = Trump to be assigned a 1 and same with Clinton
* 1 = all match, 0 = all discussants do not match Rvote
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


* dyads with perceived discussant = Rvote
gen dy_match_trump = 0
replace dy_match_trump = 1 if trump_disc1 == 1 & Rvote==1
replace dy_match_trump = dy_match_trump+1 if trump_disc2 == 1 & Rvote==1
replace dy_match_trump = dy_match_trump+1 if trump_disc3 == 1 & Rvote==1

gen dy_match_clint = 0
replace dy_match_clint = 1 if clint_disc1 ==1 & Rvote==0
replace dy_match_clint = dy_match_clint+1 if clint_disc2 ==1 & Rvote==0
replace dy_match_clint = dy_match_clint+1 if clint_disc3 ==1 & Rvote==0

gen dy_match = 0
replace dy_match=1 if dy_match_trump==1 | dy_match_clint==1

* order in which matching vote discussant is named
gen disc1_match=.
replace disc1_match=1 if named_1==1 & dy_match==1
replace disc1_match=0 if disc1_match==.

gen disc2_match=.
replace disc2_match=1 if named_2==1 & dy_match==1
replace disc2_match=0 if disc2_match==.

gen disc3_match=.
replace disc3_match=1 if named_3==1 & dy_match==1
replace disc3_match=0 if disc3_match==.

gen named_match = .
replace named_match = 1 if disc1_match==1
replace named_match = 2 if disc2_match==1
replace named_match = 3 if disc3_match==1

gen dy_match_prop = .
replace dy_match_prop = (dy_match_trump/3)*100 if Rvote==1
replace dy_match_prop = (dy_match_clint/3)*100 if Rvote==0

save "/Users/sarahmcnitt/Desktop/working/nuc working.dta", replace

** adding source variable
gen dsource = 4
label define sources 1 "ucd" 2 "uga" 3 "fsu" 4 "nuc"
label values dsource sources
save "/Users/sarahmcnitt/Desktop/working/nuc working.dta", replace




