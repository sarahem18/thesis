*** merge data management
*** requires: UC Davis, UGA, NUC, and FSU 2016 CCES Modules
*** output: merged dataset ready for replication analysis

do "/Users/sarahmcnitt/Desktop/thesis/UCD_manage.do"
do "/Users/sarahmcnitt/Desktop/thesis/UGA_manage.do"
do "/Users/sarahmcnitt/Desktop/thesis/NUC_manage.do"
do "/Users/sarahmcnitt/Desktop/thesis/FSU_manage.do"

** MERGING DATASETS ON CASE ID VARIABLE V101, won't technically merge, basically appends without needing identical data structure
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
save "/Users/sarahmcnitt/Desktop/thesis/2016 merge SN.dta", replace
* N = 4000


** common content variables
* demos
gen age=2016-birthyr
tab educ
tab educ, nol
* no management required

tab pid7
tab pid7, nol
recode pid7 1=0 2=1 3=2 4=3 5=4 6=5 7=6 *=., gen(new_pid)
* scale from 0-6 with 0 = Strong Democrat

recode pid7 1 7=3 2 6=2 3 5=1 4=0 8=., gen(extremity)

recode CC16_360 2=1 *=0, gen(dem_dummy)
recode CC16_360 3=1 *=0, gen(rep_dummy)

* political knowledge
recode CC16_321a 1=1 *=0, gen(pk1)
recode CC16_321b 1=1 *=0, gen(pk2)
gen pol_know = pk1 + pk2

* news: CC16_300_3 = read newspaper? CC16_300b = watch local or natl news
recode CC16_300_3 2=0, gen(newsppr)
recode CC16_300b 1=0 2/3=1, gen(newstv)


* likes and dislikes about Trump and Clinton 
* policy match with Trump or Clinton
* Trump's position = 1, Clinton's = 0, should I continue w a clint_likes var 
recode CC16_330a 1=0 2=1, gen(gun_stance)
recode CC16_331_7 1=1 2=0, gen(imm_stance)
recode CC16_332a 1=0 2=1, gen(abort_stance)
recode CC16_333a 1=0 2=1, gen(epa_stance)
recode CC16_351I 1=1 2=0, gen(aca_stance)
gen trump_likes = gun_stance + imm_stance + abort_stance + epa_stance + aca_stance
gen clint_likes = 5-trump_likes


* polarization
gen polar_trump = abs(trump_likes-clint_likes)
gen polar_clint = abs(clint_likes-trump_likes)
* intensity = likes, bc i don't have proxy for dislikes, so intensity_candidate = cand_likes
* ambivalence = .5(intensity)-polarization
gen ambiv_trump = 0.5*(trump_likes)-polar_trump
gen ambiv_clint = 0.5*(clint_likes)-polar_clint


* turnout and interest: table 7
* turnout is binary logit
* interest is ordered logit
recode CC16_401 5=1 *=0, gen(voted)
recode pew_churatd 7=., gen(church)
recode newsint 7=., gen(interest)

save "/Users/sarahmcnitt/Desktop/thesis/2016 merge SN.dta", replace
