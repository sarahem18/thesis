*** Sarah McNitt
*** 2000 ANES data management
*** requires: anes2000TS.dta
*** output: .dta
*** last updated: 4/11/22

cd "/Users/sarahmcnitt/Desktop/thesis"
use "anes2000TS.dta"

*** Correlates
** voluntary group membership, church + voluntary group
* belong to a union?
* 0 = no, 1 = yes
recode V001494 1=1 5=0 *=., gen(avg_org)
sum avg_org
recode V001494 1=1 5=0 *=.414791, gen(org)

* belong to a church? 
* 0 = no, 1 = yes regardless of how often R attends
recode V000877 1=1 5=0 *=., gen(avg_church)
sum avg_church
recode V000877 1=1 5=0 *=.6962096, gen(church)

gen member = church + org

** socioeconomic status
* family income group
* <$15k - >$200k
recode V000993 1/3=0 4=1 5=2 6=3 7=4 8=5 9=6 10=7 11=8 12=9 13=10 14=11 15=12 16/22=13 *=., gen(avg_faminc)
sum avg_faminc
recode V000993 1/3=0 4=1 5=2 6=3 7=4 8=5 9=6 10=7 11=8 12=9 13=10 14=11 15=12 16/22=13 *=4.47037, gen(faminc)

gen faminc_ind = faminc/13

* education, 7-catgeory
* 0 = no diploma, 1 = HS, 2 = some college, 3 = BA, 4 = Masters+
recode V000913 1/2=0 3/4=1 5=2 6=3 7=4 *=., gen(avg_educ)
sum avg_educ
recode V000913 1/2=0 3/4=1 5=2 6=3 7=4 *=1.712778, gen(educ)

gen educ_ind = educ/4

gen ses = (educ_ind + faminc_ind)/2

** Perceived political powerlessness (external efficacy) index
* gov't cares what I think?
* 0 = gov't does care, 1 = gov't doesn't care
recode V001527 1/2=1 4/5=0 *=., gen(avg_gov_cares)
sum avg_gov_cares
recode V001527 1/2=1 4/5=0 *=.6141618, gen(gov_cares)

* I have say in what gov't does? 
* 0 = I do have a say, 1 = I don't have a say
recode V001528 1/2=1 4/5=0 *=., gen(avg_gov_infl)
sum avg_gov_infl
recode V001528 1/2=1 4/5=0 *=.427766, gen(gov_infl)

* gov't seems too complicated? 
* 0 = gov't isn't complicated, 1 = gov't is too complicated
recode V001529 1/2=1 4/5=0 *=., gen(avg_gov_complex)
sum avg_gov_complex
recode V001529 1/2=1 4/5=0 *=.6192788, gen(gov_complex)

* it matters whether I vote?
* 0 = my vote matters, 1 = my vote doesn't matter
recode V001520 4/5=1 1/2=0 *=., gen(avg_vote_matter)
sum avg_vote_matter
recode V001520 4/5=1 1/2=0 *=.8840792, gen(vote_matter)

* are local elections important? NOT IN 2000 NES, below code done w NES 1948-2020
* 0 = local elections are important, 1 = they are not important
* recode VCF0618 1=1 2=0 *=., gen(avg_local_elec)
* sum avg_local_elec
* recode VCF0618 1=1 2=0 *=.1395612, gen(local_elec)


gen efficacy = (gov_cares + gov_infl + gov_complex + vote_matter)/4


** Information exchange index
** political discussion
* frequency: how often do you discuss politics with family/friends?
* 0 = never, 1 = not often, 2 = 1/2x a week, 3 = 3/4x a week, 4 = every day
recode V001205 0=0 1/2=1 3/4=2 5/6=3 7=4 *=., gen(avg_poldisc_freq)
sum avg_poldisc_freq
recode V001205 0=0 1/2=1 3/4=2 5/6=3 7=4 *=2.066704, gen(poldisc_freq)

gen poldisc_ind = poldisc_freq/4

* attempt to influence others during campaign?
* 0 = no, 1 = yes
recode V001225 1=1 5=0 *=., gen(avg_sway_others)
sum avg_sway_others
recode V001225 1=1 5=0 *=.3511254, gen(sway_others)

gen disc_ind = (poldisc_ind + sway_others)/2

** media exposure
* # of days read a newspaper in last week?
* 0-7, coded as such, no missing
sum V000335
recode V000335 0=0 1=1 2=2 3=3 4=4 5=5 6=6 7=7 *=3.436635, gen(newsp_freq)

gen newsfreq_ind = newsp_freq/7

* # of days watched TV in last week?
* 0-7, coded as such
recode V000329 8=., gen(avg_tv_freq)
sum avg_tv_freq
recode V000329 0=0 1=1 2=2 3=3 4=4 5=5 6=6 7=7 *=3.293792, gen(tv_freq)

gen tvfreq_ind = tv_freq/7

* watched TV programs about the campaign?
* 0 = no, 1 = yes
recode V000338 1=1 5=0 *=., gen(avg_tv_cam)
sum avg_tv_cam
recode V000338 1=1 5=0 *=.7633038, gen(tv_cam)

* read newspaper articles about the campaign?
* 0 = no, 1 = yes
recode V000336 1=1 5=0 *=., gen(avg_newsp_cam)
sum avg_newsp_cam
recode V000336 1=1 5=0 *=.5904335, gen(newsp_cam)


gen media_ind = (newsfreq_ind + tvfreq_ind + tv_cam + newsp_cam)/4

* add sub-indices to create info exchange index
gen infoexc_ind = (disc_ind + media_ind)/2

*** Political activity
** Political group membership NOT IN 2000 NES, below code done w NES 1948-2020
* belong to political club or organization
* 0 = no, 1 = yes
* recode VCF0743 1=1 5=0 *=., gen(avg_pol_group)
* sum avg_pol_group
* recode VCF0743 1=1 5=0 *=.0343855, gen(pol_group)

** Political participation index
* attended any rally or political meetings during campaign?
* 0 = no, 1 = yes
recode V001227 1=1 5=0 *=., gen(avg_rally_cam)
sum avg_rally_cam
recode V001227 1=1 5=0 *=.0546624, gen(rally_cam)

* work for the candidate or party during the campaign?
* 0 = no, 1 = yes
recode V001228 1=1 5=0 *=., gen(avg_work_cam)
sum avg_work_cam
recode V001228 1=1 5=0 *=.0276527, gen(work_cam)

* donate money to party or candidate during campaign?
* 0 = no, 1 = yes
recode V001229 1=1 5=0 *=., gen(avg_donate_cam)
sum avg_donate_cam
recode V001229 1=1 5=0 *=.0663232, gen(donate_cam)

* written a letter to a public official?
* 0 = no, 1 = yes
recode V001492 1=1 5=0 *=., gen(avg_contact_rep)
sum avg_contact_rep
recode V001492 1=1 5=0 *=.2066967, gen(contact_rep)

gen participation = (rally_cam + work_cam + donate_cam + contact_rep)/4

** Voting behavior
* vote for president
* 0 = no, 1 = yes

recode V001248 1=1 5=0 *=., gen(avg_pres_vote)
sum avg_pres_vote
recode V001248 1=1 5=0 *=.9966159, gen(pres_vote)

* vote for Congressman
* 0 = no, 1 = yes
recode V001254 1=1 5 8=0 *=., gen(avg_cong1_vote)
sum avg_cong1_vote
recode V001254 1=1 5 8=0 *=.8424779, gen(cong1_vote)

recode V001258 1=1 5=0 *=., gen(avg_cong2_vote)
sum avg_cong2_vote
recode V001258 1=1 5=0 *=.6666667, gen(cong2_vote)

gen cong_vote = 0
replace cong_vote = 1 if cong1_vote!=0 | cong2_vote!=0

* vote for Senator
* 0 = no, 1 = yes
recode V001266 1=1 5 8=0 *=., gen(avg_sen1_vote)
sum avg_sen1_vote
recode V001266 1=1 5 8=0 *=.9032634, gen(sen1_vote)

recode V001270 1=1 5 8=0 *=., gen(avg_sen2_vote)
sum avg_sen2_vote
recode V001270 1=1 5 8=0 *=.8, gen(sen2_vote)

gen sen_vote = 0
replace sen_vote = 1 if sen1_vote!=0 | sen2_vote!=0

gen voting = pres_vote + cong_vote + sen_vote

*** Controls
* age
recode V000907 0 9998 9999=., gen(birthyr)

gen age = 2000-birthyr

* sex (dropping other category (n=11)) 
* 0 = male, 1 = female
rename V001029 sex

save "2000 anes final.dta", replace
