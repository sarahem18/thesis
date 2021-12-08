*** Sarah McNitt
*** analysis for Sallach (1972) replication
*** requires: Cumulative ANES 1948-2020 Data File and ANES_manage
*** output: correlation and regression tables
*** last updated: 12/8/21

do "/Users/sarahmcnitt/Desktop/replication 2/ANES_manage.do"

use "/Users/sarahmcnitt/Desktop/replication 2/sallach ANES.dta"

corr voting age sex member ses efficacy infoexc_ind
corr pol_group age sex member ses efficacy infoexc_ind
corr participation age sex member ses efficacy infoexc_ind

pcorr voting age sex member ses efficacy infoexc_ind
pcorr pol_group age sex member ses efficacy infoexc_ind
pcorr participation age sex member ses efficacy infoexc_ind

** 1952-2020
reg voting age sex member ses efficacy infoexc_ind
reg pol_group age sex member ses efficacy infoexc_ind
reg participation age sex member ses efficacy infoexc_ind

** 2000 only
reg voting age sex member ses efficacy infoexc_ind if VCF0004==2000
reg participation age sex member ses efficacy infoexc_ind if VCF0004==2000
