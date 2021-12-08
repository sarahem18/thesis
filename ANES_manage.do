*** Sarah McNitt
*** ANES data management
*** requires: Cumulative ANES 1948-2020 Data File
*** output: variables for replication of Sallach 1972
*** last updated: 12/8/21

use "/Users/sarahmcnitt/Desktop/replication 2/anes_timeseries_cdf_stata_20211118/anes_timeseries_cdf_stata_20211118.dta",clear

drop if VCF0004==1948

*** Correlates
** voluntary group membership, church + union
* belong to a union? N = 66,927
* 0 = no, 1 = yes
recode VCF0127a 11 21 22 31=1 00 12 13 23 99=0 *=., gen(avg_union)
sum avg_union
recode VCF0127a 11 21 22 31=1 00 12 13 23 99=0 *=.0979845, gen(union)

* belong to a church? N = 
* 0 = no, 1 = yes regardless of how often R attends
recode VCF0130 1/4=1 0 5 7=0 *=., gen(avg_church70)
sum avg_church
recode VCF0130 1/4=1 0 5 7=0 *=.6721427, gen(church)

gen member = church + union

** socioeconomic status
* family income group N = 66,713
* 0 = 0-16 percentile, 1 = 17-33, 2 = 34-67, 3 = 68-95, 4 = 96-100
recode VCF0114 1=0 2=1 3=2 4=3 5=4 *=., gen(avg_faminc)
sum avg_faminc
recode VCF0114 1=0 2=1 3=2 4=3 5=4 *=1.860886, gen(faminc)

gen faminc_ind = faminc/4

* education, 7-catgeory  N = 67,562
* 0 = no diploma, 1 = HS, 2 = some college, 3 = BA, 4 = Masters+
recode VCF0140a 1/2=0 3/4=1 5=2 6=3 7=4 *=., gen(avg_educ)
sum avg_educ
recode VCF0140a 1/2=0 3/4=1 5=2 6=3 7=4 *=1.535283, gen(educ)

gen educ_ind = educ/4

gen ses = (educ_ind + faminc_ind)/2

** Perceived political powerlessness (external efficacy) index
* gov't cares what I think? N = 60,785
* 0 = gov't does care, 1 = gov't doesn't care
recode VCF0609 1=0 2=1 *=., gen(avg_gov_cares)
sum avg_gov_cares
recode VCF0609 1=0 2=1 *=.4242813, gen(gov_cares)

* I have say in what gov't does? N = 58,609
* 0 = I do have a say, 1 = I don't have a say
recode VCF0613 1=0 2=1 *=., gen(avg_gov_infl)
sum avg_gov_infl
recode VCF0613 1=0 2=1 *=.531581, gen(gov_infl)

* gov't seems too complicated? N = 41,918
* 0 = gov't isn't complicated, 1 = gov't is too complicated
recode VCF0614 1=0 2=1 *=., gen(avg_gov_complex)
sum avg_gov_complex
recode VCF0614 1=0 2=1 *=.2936895, gen(gov_complex)


* it matters whether I vote? N = 17,031
* 0 = my vote matters, 1 = my vote doesn't matter
recode VCF0615 1=0 2=1 *=., gen(avg_vote_matter)
sum avg_vote_matter
recode VCF0615 1=0 2=1 *=.8942519, gen(vote_matter)

* are local elections important? N = 13,713
* 0 = local elections are important, 1 = they are not important
recode VCF0618 1=1 2=0 *=., gen(avg_local_elec)
sum avg_local_elec
recode VCF0618 1=1 2=0 *=.1395612, gen(local_elec)


gen efficacy = (gov_cares + gov_infl + gov_complex + vote_matter + local_elec)/5
* N = 12,109

** Information exchange index
** political discussion
* frequency: how often do you discuss politics with family/friends? N = 11,974
* 0 = never, 1 = not often, 2 = 1/2x a week, 3 = 3/4x a week, 4 = every day
recode VCF0732 5=0 4=1 3=2 2=3 1=4 *=., gen(avg_poldisc_freq)
sum avg_poldisc_freq
recode VCF0732 5=0 4=1 3=2 2=3 1=4 *= 1.515741, gen(poldisc_freq)

gen poldisc_ind = poldisc_freq/4

* attempt to influence others during campaign? N = 66,423
* 0 = no, 1 = yes
recode VCF0717 2=1 1=0 *=., gen(avg_sway_others)
sum avg_sway_others
recode VCF0717 2=1 1=0 *=.3280945, gen(sway_others)

gen disc_ind = (poldisc_ind + sway_others)/2

** media exposure
* # of days read a newspaper in last week? N = 22,580
* 0-7, coded as such
recode VCF9033 8/9=., gen(avg_newsp_freq)
sum avg_newsp_freq
recode VCF9033 1=1 2=2 3=3 4=4 5=5 6=6 7=7 *=3.661038, gen(newsp_freq)

gen newsfreq_ind = newsp_freq/7

* # of days watched TV in last week? N = 22,580
* 0-7, coded as such
recode VCF9035 8/9=., gen(avg_tv_freq)
sum avg_tv_freq
recode VCF9033 1=1 2=2 3=3 4=4 5=5 6=6 7=7 *=4.240946, gen(tv_freq)

gen tvfreq_ind = tv_freq/7

* watched TV programs about the campaign? N = 43,212
* 0 = no, 1 = yes
recode VCF0724 2=1 1=0 *=., gen(avg_tv_cam)
sum avg_tv_cam
recode VCF0724 2=1 1=0 *=.7786427, gen(tv_cam)


* read newspaper articles about the campaign? N = 37,827
* 0 = no, 1 = yes
recode VCF0727 2=1 1=0 *=., gen(avg_newsp_cam)
sum avg_newsp_cam
recode VCF0727 2=1 1=0 *=.6914817, gen(newsp_cam)


gen media_ind = (newsfreq_ind + tvfreq_ind + tv_cam + newsp_cam)/4

* add sub-indices to create info exchange index
gen infoexc_ind = (disc_ind + media_ind)/2

*** Political activity
** Political group membership 
* belong to political club or organization N = 16,110
* 0 = no, 1 = yes
recode VCF0743 1=1 5=0 *=., gen(avg_pol_group)
sum avg_pol_group
recode VCF0743 1=1 5=0 *=.0343855, gen(pol_group)

** Political participation index
* attended any rally or political meetings during campaign? N = 63,682
* 0 = no, 1 = yes
recode VCF0718 2=1 1=0 *=., gen(avg_rally_cam)
sum avg_rally_cam
recode VCF0718 2=1 1=0 *=.0711824, gen(rally_cam)

* work for the candidate or party during the campaign? N = 63,682
* 0 = no, 1 = yes
recode VCF0719 2=1 1=0 *=., gen(avg_work_cam)
sum avg_work_cam
recode VCF0719 2=1 1=0 *=.0399883, gen(work_cam)

* donate money to party or candidate during campaign? N = 63,466
* 0 = no, 1 = yes
recode VCF0721 2=1 1=0 *=., gen(avg_donate_cam)
sum avg_donate_cam
recode VCF0721 2=1 1=0 *=.1167965, gen(donate_cam)

* written a letter to a public official? N = 8,081
* 0 = no, 1 = yes
recode VCF0722 2=1 1=0 *=., gen(avg_contact_rep)
sum avg_contact_rep
recode VCF0722 2=1 1=0 *=.2396106, gen(contact_rep)

gen participation = (rally_cam + work_cam + donate_cam + contact_rep)/4

** Voting behavior
* vote in national elections = vote for president N = 67,085 
* 0 = no, 1 = yes
recode VCF0704 1/2=1 0=0 *=., gen(avg_pres_vote)
sum avg_pres_vote
recode VCF0704 1/2=1 0=0 *= .6619367, gen(pres_vote)

* vote for Congressman N = 66,423
* 0 = no, 1 = yes
recode VCF0707 1/2=1 0=0 *=., gen(avg_cong_vote)
sum avg_cong_vote
recode VCF0707 1/2=1 0=0 *=.547461, gen(cong_vote)

* vote for Senator N = 65,126
* 0 = no, 1 = yes
recode VCF0708 1/2=1 0=0 *=., gen(avg_sen_vote)
sum avg_sen_vote
recode VCF0708 1/2=1 0=0 *=.3794184, gen(sen_vote)

gen voting = pres_vote + cong_vote + sen_vote

*** Controls
* age N = 66,423 (not asked in 1948)
* drop 1948
recode VCF0101 0=., gen(age)

* sex (dropping other category (n=11)) N = 68,224
* 0 = male, 1 = female
recode VCF0104 0 3=. 2=1 1=0, gen(sex)

save "/Users/sarahmcnitt/Desktop/replication 2/sallach ANES.dta"
