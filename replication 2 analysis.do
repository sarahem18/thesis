*** Sarah McNitt
*** analysis for Sallach (1972) replication
*** requires: NES 2000 Data File and nes2000_manage.do
*** output: correlation and regression tables
*** last updated: 1/26/22

cd "/Users/sarahmcnitt/Desktop/replication 2"
do "nes2000_manage.do"

corr voting age sex member ses efficacy infoexc_ind
corr participation age sex member ses efficacy infoexc_ind

pcorr voting age sex member ses efficacy infoexc_ind
pcorr participation age sex member ses efficacy infoexc_ind

** 2000 only
reg voting age sex member ses efficacy infoexc_ind
eststo vote
reg participation age sex member ses efficacy infoexc_ind
eststo activity
esttab using nes2000.tex, b(3) wide replace

*reg voting age sex member ses efficacy infoexc_ind, beta
*reg participation age sex member ses efficacy infoexc_ind, beta

*reg voting age sex member
*reg participation age sex member

*reg voting age sex ses
*reg participation age sex ses

*reg voting age sex efficacy
*reg participation age sex efficacy

*reg voting age sex infoexc_ind
*reg participation age sex infoexc_ind



