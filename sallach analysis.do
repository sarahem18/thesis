*** Sarah McNitt
*** Sallach, Babchuk, and Booth (1972) replication
*** requires: 2000 anes final.dta, nes2000_manage.do
*** output: .tex, .png
*** last updated: 4/11/22

cd "/Users/sarahmcnitt/Desktop/thesis"
do "nes2000_manage.do"
use "2000 anes final.dta"

** gauging correlations
corr voting age sex member ses efficacy infoexc_ind
corr participation age sex member ses efficacy infoexc_ind

pcorr voting age sex member ses efficacy infoexc_ind
pcorr participation age sex member ses efficacy infoexc_ind

** regression analysis, 2000
reg voting age sex member ses efficacy infoexc_ind, beta
eststo vote
reg participation age sex member ses efficacy infoexc_ind
eststo activity
esttab using nes2000.tex, b(3) wide

** marginal effects plots
** voting
reg voting age sex member ses efficacy infoexc_ind, beta
margins, at(member=(0 1 2)) atmeans
marginsplot, title("") xtitle("Number of memberships") graphregion(fcolor(white) ilcolor(white) lcolor(white))  yla(, format(%9.1f)) 
graph save "Graph" "memberv.gph"

margins, at(ses=(0(.25)1)) atmeans
marginsplot, title("") xtitle("Socioeconomic Index") graphregion(fcolor(white) ilcolor(white) lcolor(white))  yla(, format(%9.2f))
graph save "Graph" "sesv.gph"

margins, at(efficacy=(0 (.25)1)) atmeans
marginsplot, title("") xtitle("Perceived Political Powerlessness") graphregion(fcolor(white) ilcolor(white) lcolor(white))  yla(, format(%9.2f))
graph save "Graph" "efficacyv.gph"

margins, at(infoexc_ind=(0(.25)1)) atmeans
marginsplot, title("") xtitle("Information Exchange Index") graphregion(fcolor(white) ilcolor(white) lcolor(white))  yla(, format(%9.2f))
graph save "Graph" "infov.gph"

** participation
reg participation age sex member ses efficacy infoexc_ind, beta
margins, at(member=(0 1 2)) atmeans
marginsplot, title("") xtitle("Number of memberships") graphregion(fcolor(white) ilcolor(white) lcolor(white))
graph save "Graph" "memberp.gph"

margins, at(ses=(0(.25)1)) atmeans
marginsplot, title("") xtitle("Socioeconomic Index") graphregion(fcolor(white) ilcolor(white) lcolor(white))
graph save "Graph" "sesp.gph"

margins, at(efficacy=(0 (.25)1)) atmeans
marginsplot, title("") xtitle("Perceived Political Powerlessness") graphregion(fcolor(white) ilcolor(white) lcolor(white))
graph save "Graph" "efficacyp.gph"

margins, at(infoexc_ind=(0(.25)1)) atmeans
marginsplot, title("") xtitle("Information Exchange Index") graphregion(fcolor(white) ilcolor(white) lcolor(white))
graph save "Graph" "infop.gph"

grc1leg memberv.gph sesv.gph efficacyv.gph infov.gph, graphregion(fcolor(white) ilcolor(white) lcolor(white))  title("Predicted number of votes cast" "in the 2000 election") note("All other variables held at their means.")
graph export "/Users/sarahmcnitt/Desktop/working/voting_margins.png", as(png) name("Graph")

grc1leg memberp.gph sesp.gph efficacyp.gph infop.gph, graphregion(fcolor(white) ilcolor(white) lcolor(white))  title(Predicted political participation) note("All other variables held at their means.") 
graph export "/Users/sarahmcnitt/Desktop/working/participation_margins.png", as(png) name("Graph")
