*** Sarah McNitt
*** Carmines, Huckfeldt, and McCurley (1995) replication
*** requires: nes acs manage.do, nes acs 0816.dta
*** output: .jpg, .gph, .tex
*** last updated: 4/11/22

cd "/Users/sarahmcnitt/Desktop/thesis"
do "nes acs manage.do"
use "nes acs 0816.dta", clear

*** Logit Models
** US
logit voted faminc educ pid3 wholecomp i.year if race==1
estat classification
eststo USvote
margins, at(year=(2008(4)2016) wholecomp = (0 25) pid3=1) atmeans 
marginsplot, title("Turnout") xtitle("") ytitle("Turnout Probability") graphregion(fcolor(white) ilcolor(white) lcolor(white)) legend(order(1 "0% Black" 2 "25% Black"))
graph save "Graph" "usvote.gph"
 
logit party faminc educ pid3 wholecomp i.year if race==1
estat classification
eststo USparty
margins, at(year=(2008(4)2016) wholecomp = (0 25) pid3=1) atmeans 
marginsplot, title("Two-party Vote") xtitle("") ytitle("Probability Democratic") graphregion(fcolor(white) ilcolor(white) lcolor(white)) legend(off)
graph save "Graph" "usparty.gph"

grc1leg usvote.gph usparty.gph, graphregion(fcolor(white) ilcolor(white) lcolor(white)) legendfrom(usvote.gph)

** Political South
logit voted faminc educ pid3 wholecomp i.year if race==1 & region==1
estat classification
eststo Svote
margins, at(year=(2008(4)2016) wholecomp = (0 25) pid3=1) atmeans 
marginsplot, title("South Turnout") xtitle("") ytitle("Turnout Probability") graphregion(fcolor(white) ilcolor(white) lcolor(white)) legend(order(1 "0% Black" 2 "25% Black"))
graph save "Graph" "southvote.gph" 

logit party faminc educ pid3 wholecomp i.year if race==1 & region==1
estat classification
eststo Sparty
margins, at(year=(2008(4)2016) wholecomp = (0 25) pid3=1) atmeans 
marginsplot, title("South Two-party Vote") xtitle("") ytitle("Probability Democratic") graphregion(fcolor(white) ilcolor(white) lcolor(white)) legend(off)
graph save "Graph" "southparty.gph"

** Political Nonsouth
logit voted faminc educ pid3 wholecomp i.year if race==1 & region==2
estat classification
eststo NSvote
margins, at(year=(2008(4)2016) wholecomp = (0 25) pid3=1) atmeans 
marginsplot, title("Non-South Turnout") xtitle("") ytitle("Turnout Probability") graphregion(fcolor(white) ilcolor(white) lcolor(white)) legend(order(1 "0% Black" 2 "25% Black"))
graph save "Graph" "nonvote.gph"

logit party faminc educ pid3 wholecomp i.year if race==1 & region==2
estat classification
eststo NSparty
esttab using rep3table.tex, b(2) se wide drop("2008.year") nostar
margins, at(year=(2008(4)2016) wholecomp = (0 25) pid3=1) atmeans 
marginsplot, title("Non-South Two-party Vote") xtitle("") ytitle("Probability Democratic") graphregion(fcolor(white) ilcolor(white) lcolor(white)) legend(off)
graph save "Graph" "nonparty.gph"

* net install grc1leg,from(http://www.stata.com/users/vwiggins/)
grc1leg usvote.gph southvote.gph nonvote.gph usparty.gph southparty.gph nonparty.gph, graphregion(fcolor(white) ilcolor(white) lcolor(white)) legendfrom(usvote.gph)
graph export "/Users/sarahmcnitt/Desktop/thesis writing/margins.png", as(png) name("Graph")
