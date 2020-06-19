clear all
set more off
cd "C:\Users\gebruiker\Dropbox\Research\Projects\4. Single Author\3. Presentations and Submissions\2020 JAR\Control Asymmetry Data and Analysis"
//cd "C:\Users\victor.vanpelt\Dropbox\Research\Projects\4. Single Author\3. Presentations and Submissions\2020 JAR\Control Asymmetry Data and Analysis"

//Import Data and save as dta file
forvalue x=1(1)9 {
	clear
	import excel using "1. Input\accounting`x'.xlsx", firstrow
	sleep 50
	save "2. Pipeline\accounting`x'.dta", replace
	clear
	import excel using "1. Input\bret`x'.xlsx", firstrow
	sleep 50
	save "2. Pipeline\bret`x'.dta", replace
	clear
	import excel using "1. Input\epq`x'.xlsx", firstrow
	sleep 50
	save "2. Pipeline\epq`x'.dta", replace
	clear
	import excel using "1. Input\payment_info`x'.xlsx", firstrow
	sleep 50
	save "2. Pipeline\payment_info`x'.dta", replace
}

//Merge
forvalue x=1(1)9 {
	clear
	use "2. Pipeline\accounting`x'.dta"
	merge m:1 participantcode sessioncode using "2. Pipeline\bret`x'.dta"
	drop _merge
	sleep 50
	merge m:1 participantcode sessioncode using "2. Pipeline\epq`x'.dta"
	drop _merge
	sleep 50
	merge m:1 participantcode sessioncode using "2. Pipeline\payment_info`x'.dta"
	drop _merge
	save "2. Pipeline\session`x'.dta", replace
}	

//Make one dta file for all sessions
clear all
use "2. Pipeline\session1.dta"
forvalue x=2(1)9 {
	append using "2. Pipeline\session`x'.dta", force
}

//Save merged raw dataset in pipeline folder
save "3. Output\full raw dataset.dta", replace
export excel using "3. Output\full raw dataset.xlsx", replace firstrow(var)


//Drop pointless variables
drop participant_is_bot participantlabel participant_index_in_pages 
drop participant_max_page_index participant_current_app_name 
drop participant_round_number participant_current_page_name 
drop participantvisited participantmturk_worker_id participantmturk_assignment_id participantip_address
drop playertn playeraccept_conditions playerInstr1a playerInstr1b playerInstr1c ///
playeraccept_payoff playerInstr2aa playerInstr2ab playerInstr2ba playerInstr2bb playerInstr2bc ///
playerFakeslider2 playerInstr3a playerInstr3b playerInstr3c playerInstr3d ///
playerFakeslider playerhistoryc playerhistoryr


// generate and replace variables
gen Principal=(playerid_in_group==1)
gen Agent=(playerid_in_group==2)
rename subsessionround_number Period
rename groupr control
rename playerid_in_group id
replace grouphistoryc1=0 if grouphistoryc1==.
replace grouphistoryc2=0 if grouphistoryc2==.
replace grouphistoryr1=0 if grouphistoryr1==.
replace grouphistoryr2=0 if grouphistoryr2==.
gen choice_history=(id==1 & grouphistoryc1==1 | id==2 & grouphistoryc2==1)
gen result_history=(id==1 & grouphistoryr1==1 | id==2 & grouphistoryr2==1)
gen history=(grouphistoryr1+grouphistoryc1)/2 if id==1
replace history=(grouphistoryc2+grouphistoryr2)/2 if id==2
sum history if id==1
sum history if id==2
//
sum groupshockround if Principal==1 & Period==1
histogram groupshockround if Principal==1 & Period==1
sum control if Principal==1 & Period==1 & groupshockround<6
sum control if Principal==1 & Period==1 & groupshockround>=6
//
gen four_shock=(groupshockround==4)
gen five_shock=(groupshockround==5)
gen six_shock=(groupshockround==6)
gen seven_shock=(groupshockround==7)
gen eight_shock=(groupshockround==8)
gen nine_shock=(groupshockround==9)
gen ten_shock=(groupshockround==10)
gen late_shock=(groupshockround>=7)
gen late_shock2=(groupshockround>=8)
//
gen Post_four=(groupshockround==4 & Period>=groupshockround)
gen Post_five=(groupshockround==5 & Period>=groupshockround)
gen Post_six=(groupshockround==6 & Period>=groupshockround)
gen Post_seven=(groupshockround==7 & Period>=groupshockround)
gen Post_eight=(groupshockround==8 & Period>=groupshockround)
gen Post_nine=(groupshockround==9 & Period>=groupshockround)
gen Post_ten=(groupshockround==10 & Period>=groupshockround)

//Generate important variables
gen Post=(Period>=groupshockround)
gen eh=(groupe_g==9)
gen el=(groupe_g==1)

// Generate Visual variables
gen LH = (groupe_g==1 & Period<groupshockround | groupe_g==9 & Period>=groupshockround)
replace LH = 0 if (groupe_g==9 & Period<groupshockround | groupe_g==1 & Period>=groupshockround)
sort LH Period participantid_in_session
by LH Period: egen mean_control=mean(control) 
gen HL=(LH==0)
//
egen idn=group(participantcode)
xtset idn Period
tsset idn Period
egen Session=group(sessioncode)
//
sum Session

gen trustworthy = (grouppayoff1-5)/10
replace trustworthy = 1 if control==1
gen response = trustworthy
replace trustworthy = . if control==1
sum trustworthy response if Principal==1
sum trustworthy response if Agent==1
//
gen self_interest = (grouppayoff2-5)/10
replace self_interest = . if control==1
sum trustworthy self_interest if Principal==1

gen shocktiming=(groupshockround-4)/6
sum shocktiming

//Incorporate history table variables //
label variable choice_history "History"
//
sum choice_history if Principal==1 & Period<groupshockround & LH==1
sum choice_history if Principal==1 & Period<groupshockround & LH==0
//
sktest choice_history if Principal==1 & Period<groupshockround
sum choice_history if Principal==1 & Period<groupshockround

// mean history pre
sort id participantcode Period

by id participantcode: egen mean_history_pre = mean(choice_history) if Post==0
by id participantcode: replace mean_history_pre=mean_history_pre[_n-1] if mean_history_pre>=.
//
by id participantcode: egen mean_history_pre_r = mean(result_history) if Post==0
by id participantcode: replace mean_history_pre_r=mean_history_pre_r[_n-1] if mean_history_pre_r>=.
//
by id participantcode: egen mean_history_pre_t = mean(history) if Post==0
by id participantcode: replace mean_history_pre_t=mean_history_pre_t[_n-1] if mean_history_pre_t>=.
//
gen focus_rounds = (Period==groupshockround | Period==groupshockround+1 | Period==groupshockround+2)
sort id participantcode focus_rounds
by id participantcode focus_rounds: egen mean_history_focus = mean(history)
sort id participantcode Period
by id participantcode: replace mean_history_focus=mean_history_focus[_n-1] if participantcode==participantcode[_n-1] & focus_rounds[_n-1]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n-2] if participantcode==participantcode[_n-2] & focus_rounds[_n-2]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n-3] if participantcode==participantcode[_n-3] & focus_rounds[_n-3]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n-4] if participantcode==participantcode[_n-4] & focus_rounds[_n-4]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n-5] if participantcode==participantcode[_n-5] & focus_rounds[_n-5]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n-6] if participantcode==participantcode[_n-6] & focus_rounds[_n-6]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n-7] if participantcode==participantcode[_n-7] & focus_rounds[_n-7]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n-8] if participantcode==participantcode[_n-8] & focus_rounds[_n-8]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n-9] if participantcode==participantcode[_n-9] & focus_rounds[_n-9]==1
//
by id participantcode: replace mean_history_focus=mean_history_focus[_n+1] if participantcode==participantcode[_n+1] & focus_rounds[_n+1]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n+2] if participantcode==participantcode[_n+2] & focus_rounds[_n+2]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n+3] if participantcode==participantcode[_n+3] & focus_rounds[_n+3]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n+4] if participantcode==participantcode[_n+4] & focus_rounds[_n+4]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n+5] if participantcode==participantcode[_n+5] & focus_rounds[_n+5]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n+6] if participantcode==participantcode[_n+6] & focus_rounds[_n+6]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n+7] if participantcode==participantcode[_n+7] & focus_rounds[_n+7]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n+8] if participantcode==participantcode[_n+8] & focus_rounds[_n+8]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n+9] if participantcode==participantcode[_n+9] & focus_rounds[_n+9]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n+10] if participantcode==participantcode[_n+10] & focus_rounds[_n+10]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n+11] if participantcode==participantcode[_n+11] & focus_rounds[_n+11]==1
by id participantcode: replace mean_history_focus=mean_history_focus[_n+12] if participantcode==participantcode[_n+12] & focus_rounds[_n+12]==1
replace mean_history_focus=. if Agent==1
//
sum mean_history_focus if Principal==1 & Period==1

//POST HISTORY
// Choice
by id participantcode: egen mean_history_post = mean(choice_history) if Post==1
by id participantcode: replace mean_history_post=mean_history_post[_n+1] if mean_history_post>=.
by id participantcode: replace mean_history_post=mean_history_post[_n+2] if mean_history_post>=.
by id participantcode: replace mean_history_post=mean_history_post[_n+3] if mean_history_post>=.
by id participantcode: replace mean_history_post=mean_history_post[_n+4] if mean_history_post>=.
by id participantcode: replace mean_history_post=mean_history_post[_n+5] if mean_history_post>=.
by id participantcode: replace mean_history_post=mean_history_post[_n+6] if mean_history_post>=.
by id participantcode: replace mean_history_post=mean_history_post[_n+7] if mean_history_post>=.
by id participantcode: replace mean_history_post=mean_history_post[_n+8] if mean_history_post>=.
by id participantcode: replace mean_history_post=mean_history_post[_n+9] if mean_history_post>=.
// Result
by id participantcode: egen mean_history_post_r = mean(result_history) if Post==1
by id participantcode: replace mean_history_post_r=mean_history_post_r[_n+1] if mean_history_post_r>=.
by id participantcode: replace mean_history_post_r=mean_history_post_r[_n+2] if mean_history_post_r>=.
by id participantcode: replace mean_history_post_r=mean_history_post_r[_n+3] if mean_history_post_r>=.
by id participantcode: replace mean_history_post_r=mean_history_post_r[_n+4] if mean_history_post_r>=.
by id participantcode: replace mean_history_post_r=mean_history_post_r[_n+5] if mean_history_post_r>=.
by id participantcode: replace mean_history_post_r=mean_history_post_r[_n+6] if mean_history_post_r>=.
by id participantcode: replace mean_history_post_r=mean_history_post_r[_n+7] if mean_history_post_r>=.
by id participantcode: replace mean_history_post_r=mean_history_post_r[_n+8] if mean_history_post_r>=.
by id participantcode: replace mean_history_post_r=mean_history_post_r[_n+9] if mean_history_post_r>=.
// Total
by id participantcode: egen mean_history_post_t = mean(history) if Post==1
by id participantcode: replace mean_history_post_t=mean_history_post_t[_n+1] if mean_history_post_t>=.
by id participantcode: replace mean_history_post_t=mean_history_post_t[_n+2] if mean_history_post_t>=.
by id participantcode: replace mean_history_post_t=mean_history_post_t[_n+3] if mean_history_post_t>=.
by id participantcode: replace mean_history_post_t=mean_history_post_t[_n+4] if mean_history_post_t>=.
by id participantcode: replace mean_history_post_t=mean_history_post_t[_n+5] if mean_history_post_t>=.
by id participantcode: replace mean_history_post_t=mean_history_post_t[_n+6] if mean_history_post_t>=.
by id participantcode: replace mean_history_post_t=mean_history_post_t[_n+7] if mean_history_post_t>=.
by id participantcode: replace mean_history_post_t=mean_history_post_t[_n+8] if mean_history_post_t>=.
by id participantcode: replace mean_history_post_t=mean_history_post_t[_n+9] if mean_history_post_t>=.


//mean_history_pre
sort id participantcode Period
by id participantcode: egen mean_history = mean(choice_history)
by id participantcode: egen mean_history_r = mean(result_history)
by id participantcode: egen mean_history_t = mean(history)

//Create measure for formed perceptions
sort id participantcode Period
by id participantcode: egen av_self_interest_pre = mean(self_interest) if Post==0
by id participantcode: replace av_self_interest_pre=av_self_interest_pre[_n-1] if av_self_interest_pre>=.
replace av_self_interest_pre=. if Agent==1
//
sort id participantcode Period
by id participantcode: egen av_self_interest = mean(self_interest)
by id participantcode: replace av_self_interest=av_self_interest[_n-1] if av_self_interest>=.
replace av_self_interest=. if Agent==1

//
gen Period1=(Period==1)
gen Period2=(Period==2)
gen Period3=(Period==3)
gen Period4=(Period==4)
gen Period5=(Period==5)
gen Period6=(Period==6)
gen Period7=(Period==7)
gen Period8=(Period==8)
gen Period9=(Period==9)
gen Period10=(Period==10)
gen Period11=(Period==11)
gen Period12=(Period==12)
xtset idn Period
gen Post_LH = Post * LH
gen LH_late_shock = LH * late_shock
gen Post_late_shock = Post * late_shock
gen Post_LH_late_shock = Post * LH * late_shock
gen Post_el = Post * el
gen Post_eh = Post * eh

// EPQ STuff
// Total
alpha playergrf1 playergrf2 playergrf3 playergrf4 playergrf5 playergrf6 playergrf7 playergrf8 playergrf9 playergrf10 playergrf11 playergrf12 playergrf13 playergrf14 playergrf15 playergrf16 playergrf17 playergrf18 if Principal==1, item 

alpha playergrf1 playergrf2 playergrf3 playergrf4 playergrf5 playergrf6 playergrf7 playergrf8 playergrf9 playergrf10 playergrf11 playergrf12 playergrf13 playergrf14 playergrf15 playergrf16 playergrf17 if Principal==1, item 

egen RegulFocus = rowmean(playergrf1 playergrf2 playergrf3 playergrf4 playergrf5 playergrf6 playergrf7 playergrf8 playergrf9 playergrf10 playergrf11 playergrf12 playergrf13 playergrf14 playergrf15 playergrf16 playergrf17 playergrf18)

//Prevention
alpha playergrf1 playergrf2 playergrf4 playergrf7 playergrf9 playergrf10 playergrf11 playergrf13 playergrf15 if Principal==1, item 

egen PrevFocus = rowmean(playergrf1 playergrf2 playergrf4 playergrf7 playergrf9 playergrf10 playergrf11 playergrf13 playergrf15)

//Promotion
alpha playergrf3 playergrf5 playergrf6 playergrf8 playergrf12 playergrf14 playergrf16 playergrf17 playergrf18 if Principal==1, item 

egen PromoFocus = rowmean(playergrf3 playergrf5 playergrf6 playergrf8 playergrf12 playergrf14 playergrf16 playergrf17 playergrf18)

//PNFS
alpha playerpnfs1 playerpnfs2 playerpnfs3 playerpnfs4 playerpnfs5 playerpnfs6 playerpnfs7 playerpnfs8 playerpnfs9 playerpnfs10 playerpnfs11, item

alpha playerpnfs1 playerpnfs2 playerpnfs3 playerpnfs4 playerpnfs6 playerpnfs7 playerpnfs8 playerpnfs9 playerpnfs10 playerpnfs11, item reverse(playerpnfs10 playerpnfs2)
replace playerpnfs10=playerpnfs10*-1+8
replace playerpnfs2=playerpnfs2*-1+8
alpha playerpnfs1 playerpnfs2 playerpnfs3 playerpnfs4 playerpnfs6 playerpnfs7 playerpnfs8 playerpnfs9 playerpnfs10 playerpnfs11, item

egen PNFS = rowmean(playerpnfs1 playerpnfs2 playerpnfs3 playerpnfs4 playerpnfs6 playerpnfs7 playerpnfs8 playerpnfs9 playerpnfs10 playerpnfs11)


//
alpha playerpnfs1 playerpnfs2 playerpnfs3 playerpnfs4 playerpnfs5 playerpnfs6 playerpnfs7 playerpnfs8 playerpnfs9 playerpnfs10 playerpnfs11, item

egen PNFS2 = rowmean(playerpnfs1 playerpnfs2 playerpnfs3 playerpnfs4 playerpnfs5 playerpnfs6 playerpnfs7 playerpnfs8 playerpnfs9 playerpnfs10 playerpnfs11)
sum PNFS if Principal==1 & Period==1

//NFS
alpha playerpnfs3 playerpnfs4 playerpnfs6 playerpnfs9, item

egen NFS = rowmean(playerpnfs3 playerpnfs4 playerpnfs5 playerpnfs9)

//RTS
alpha playerpnfs1 playerpnfs2 playerpnfs6 playerpnfs7 playerpnfs8 playerpnfs9 playerpnfs10 playerpnfs11, item

egen RTS = rowmean(playerpnfs1 playerpnfs2 playerpnfs3 playerpnfs4 playerpnfs6 playerpnfs7 playerpnfs8 playerpnfs9 playerpnfs10 playerpnfs11)

//playertrust Measurement
replace playertrust2=-1*playertrust2+8
replace playertrust4=-1*playertrust4+8
replace playertrust5=-1*playertrust5+8
replace playertrust7=-1*playertrust7+8
replace playertrust9=-1*playertrust9+8
replace playertrust10=-1*playertrust10+8
replace playertrust11=-1*playertrust11+8
alpha playertrust*, item
factor playertrust*, pcf mineigen(1) blanks(0.3)
egen playertrust=rmean(playertrust*)
label variable playertrust "mean of playertrust1-playertrust11"

//playerbig5
replace playerbig6=-1*(playerbig6-8)
replace playerbig2=-1*(playerbig2-8)
replace playerbig8=-1*(playerbig8-8)
replace playerbig4=-1*(playerbig4-8)
replace playerbig10=-1*(playerbig10-8)
egen Extraversion=rmean(playerbig1 playerbig6)
egen Agreeableness=rmean(playerbig2 playerbig7)
egen Conscientiousness=rmean(playerbig3 playerbig8)
egen EmoStability=rmean(playerbig4 playerbig9)
egen OpennessExp=rmean(playerbig5 playerbig10)

/* Understandability */
// Under1 Good question to identify principal
sum idn if playerund1==1 & Principal==1 & Period==12
gen NoUnd=(playerund1!=1 & Principal==1)
//
sum idn if playerund1==2 & Agent==1 & Period==12
sum idn if playerund1!=2 & Agent==1 & Period==12
replace NoUnd=1 if playerund1!=2 & Agent==1
// Majority principals understood task

// Under3 good question to see who recalls which player they were.
sum idn if playerund3==1 & Agent==1 & Period==12
sum idn if playerund3!=1 & Agent==1 & Period==12
// All agents understood their player role!

//One principal doesn't remember being player 1.
sum idn if playerund3==2 & Principal==1 & Period==12
replace NoUnd=1 if playerund3!=2 & Principal==1

/*
//THIS CONTROL QUESTION IS ILL-CONSTRUCTED for Agents BECAUSE SOMETIMES AGENTS COULD NOT CHOOSE if the principal exercised full control!
sum idn if playerund4==1 & Agent==1 & Period==12
sum idn if playerund4!=1 & Agent==1 & Period==12
*/
// 
sum idn if playerund4==2 & Principal==1 & Period==12
sum idn if playerund4!=2 & Principal==1 & Period==12
replace NoUnd=1 if playerund4!=2 & Principal==1

//Effects of the sample selection
sum idn if Agent==1 & Period==12
sum idn if Principal==1 & Period==12

sum idn if Principal==1 & Period==12 & NoUnd==0
sum idn if Agent==1 & Period==12 & NoUnd==0

sum idn if Principal==1 & NoUnd==0
sum idn if Agent==1 & NoUnd==0
sum idn if Principal==1 & NoUnd==0 & control<1

//
alpha playercons* if Principal==1 & Period==12, item

alpha playercons2-playercons4 if Principal==1 & Period==12, item
egen consider = rowmean(playercons2 playercons3 playercons4)

sum playercons1 if Principal==1 & LH==1 & Post==0
sum playercons1 if Principal==1 & LH==1 & Post==1
sum playercons1 if Principal==1 & LH==0 & Post==0
sum playercons1 if Principal==1 & LH==0 & Post==1

xtreg control Post##LH##c.playercons1 shocktiming i.Period if Principal==1, vce(robust)
lincom 1.Post--(1.Post+1.Post#1.LH)


sum consider if Principal==1 & LH==1 & Post==0
sum consider if Principal==1 & LH==1 & Post==1
sum consider if Principal==1 & LH==0 & Post==0
sum consider if Principal==1 & LH==0 & Post==1

pwcorr mean_history_pre consider playercons1 playerenjoy3 RegulFocus PromoFocus PrevFocus PNFS OpennessExp Conscientiousness EmoStability Agreeableness Extraversion if Principal==1 & Period==12

sum consider playercons1 playerenjoy3


replace consider=(consider-1)/6
replace playercons1=(playercons1-1)/6
replace playerenjoy3=(playerenjoy3-8)
replace playerenjoy3=playerenjoy3*-1
replace playerenjoy3=(playerenjoy3-1)/6

//
gen UpwardShock=(Post==1 & LH==1)
gen DownwardShock=(Post==1 & HL==1)

//drop excluded epq scales
drop playersvo* playersdo*

/* Other method */

//Create Control average
sort id participantcode Period
by id participantcode: egen control_pre = mean(control) if Post==0
by id participantcode: replace control_pre=control_pre[_n-1] if control_pre>=.
replace control_pre=. if Agent==1
sort id participantcode Period
by id participantcode: egen control_post = mean(control) if Post==1
by id participantcode: replace control_post=control_post[_n+1] if control_post>=. & Principal==1
by id participantcode: replace control_post=control_post[_n+2] if control_post>=. & Principal==1
by id participantcode: replace control_post=control_post[_n+3] if control_post>=. & Principal==1
by id participantcode: replace control_post=control_post[_n+4] if control_post>=. & Principal==1
by id participantcode: replace control_post=control_post[_n+5] if control_post>=. & Principal==1
by id participantcode: replace control_post=control_post[_n+6] if control_post>=. & Principal==1
by id participantcode: replace control_post=control_post[_n+7] if control_post>=. & Principal==1
by id participantcode: replace control_post=control_post[_n+8] if control_post>=. & Principal==1
by id participantcode: replace control_post=control_post[_n+9] if control_post>=. & Principal==1
replace control_post=. if Agent==1

//Create Response average first three and last three periods
sort id participantcode Period
by id participantcode: egen trust_pre = mean(trustworthy) if Period<=3
by id participantcode: replace trust_pre=trust_pre[_n-1] if trust_pre>=.
replace trust_pre=. if Principal==1
sort id participantcode Period
by id participantcode: egen trust_post = mean(trustworthy) if Period>=10
by id participantcode: replace trust_post=trust_post[_n+1] if trust_post>=. & Agent==1
by id participantcode: replace trust_post=trust_post[_n+2] if trust_post>=. & Agent==1
by id participantcode: replace trust_post=trust_post[_n+3] if trust_post>=. & Agent==1
by id participantcode: replace trust_post=trust_post[_n+4] if trust_post>=. & Agent==1
by id participantcode: replace trust_post=trust_post[_n+5] if trust_post>=. & Agent==1
by id participantcode: replace trust_post=trust_post[_n+6] if trust_post>=. & Agent==1
by id participantcode: replace trust_post=trust_post[_n+7] if trust_post>=. & Agent==1
by id participantcode: replace trust_post=trust_post[_n+8] if trust_post>=. & Agent==1
by id participantcode: replace trust_post=trust_post[_n+9] if trust_post>=. & Agent==1
replace trust_post=. if Principal==1
gen trust_change=(trust_post-trust_pre)

//Crease Response average for principals ex-ante and ex-post
sort id participantcode Period
by id participantcode: egen response_pre2 = mean(response) if Post==0
by id participantcode: replace response_pre2=response_pre2[_n-1] if response_pre2>=.
replace response_pre2=. if Agent==1
sort id participantcode Period
by id participantcode: egen response_post2 = mean(response) if Post==1
by id participantcode: replace response_post2=response_post2[_n+1] if response_post2>=. & Principal==1
by id participantcode: replace response_post2=response_post2[_n+2] if response_post2>=. & Principal==1
by id participantcode: replace response_post2=response_post2[_n+3] if response_post2>=. & Principal==1
by id participantcode: replace response_post2=response_post2[_n+4] if response_post2>=. & Principal==1
by id participantcode: replace response_post2=response_post2[_n+5] if response_post2>=. & Principal==1
by id participantcode: replace response_post2=response_post2[_n+6] if response_post2>=. & Principal==1
by id participantcode: replace response_post2=response_post2[_n+7] if response_post2>=. & Principal==1
by id participantcode: replace response_post2=response_post2[_n+8] if response_post2>=. & Principal==1
by id participantcode: replace response_post2=response_post2[_n+9] if response_post2>=. & Principal==1
replace response_post2=. if Agent==1

//Crease Trust average for principals ex-ante and ex-post
sort id participantcode Period
by id participantcode: egen trust_pre2 = mean(trustworthy) if Post==0
by id participantcode: replace trust_pre2=trust_pre2[_n-1] if trust_pre2>=.
replace trust_pre2=. if Agent==1
sort id participantcode Period
by id participantcode: egen trust_post2 = mean(trustworthy) if Post==1
by id participantcode: replace trust_post2=trust_post2[_n+1] if trust_post2>=. & Principal==1
by id participantcode: replace trust_post2=trust_post2[_n+2] if trust_post2>=. & Principal==1
by id participantcode: replace trust_post2=trust_post2[_n+3] if trust_post2>=. & Principal==1
by id participantcode: replace trust_post2=trust_post2[_n+4] if trust_post2>=. & Principal==1
by id participantcode: replace trust_post2=trust_post2[_n+5] if trust_post2>=. & Principal==1
by id participantcode: replace trust_post2=trust_post2[_n+6] if trust_post2>=. & Principal==1
by id participantcode: replace trust_post2=trust_post2[_n+7] if trust_post2>=. & Principal==1
by id participantcode: replace trust_post2=trust_post2[_n+8] if trust_post2>=. & Principal==1
by id participantcode: replace trust_post2=trust_post2[_n+9] if trust_post2>=. & Principal==1
replace trust_post2=. if Agent==1

//Create Control median
sort id participantcode Period
by id participantcode: egen control_pre2 = median(control) if Post==0
by id participantcode: replace control_pre2=control_pre2[_n-1] if control_pre2>=.
replace control_pre2=. if Agent==1
sort id participantcode Period
by id participantcode: egen control_post2 = median(control) if Post==1
by id participantcode: replace control_post2=control_post2[_n+1] if control_post2>=. & Principal==1
by id participantcode: replace control_post2=control_post2[_n+2] if control_post2>=. & Principal==1
by id participantcode: replace control_post2=control_post2[_n+3] if control_post2>=. & Principal==1
by id participantcode: replace control_post2=control_post2[_n+4] if control_post2>=. & Principal==1
by id participantcode: replace control_post2=control_post2[_n+5] if control_post2>=. & Principal==1
by id participantcode: replace control_post2=control_post2[_n+6] if control_post2>=. & Principal==1
by id participantcode: replace control_post2=control_post2[_n+7] if control_post2>=. & Principal==1
by id participantcode: replace control_post2=control_post2[_n+8] if control_post2>=. & Principal==1
by id participantcode: replace control_post2=control_post2[_n+9] if control_post2>=. & Principal==1
replace control_post2=. if Agent==1

//Create Control Change
gen control_change=(control_post-control_pre)
gen control_change2=(control_post2-control_pre2)
gen abs_control_change=abs(control_change)
gen abs_control_change2=abs(control_change2)
//Alternative
gen one_control_change=control_change if HL==1
replace one_control_change=-1*control_change if LH==1


/* Descriptives and Visuals */

//Participant information
sum playergender playerage playernationality playerstudies playerworkexperience playerdegree playerenglish if Period==1
// Gender (64.6% Male)
sum idn if playergender==1 & Period==1
sum idn if playergender==2 & Period==1
sum idn if playergender==3 & Period==1
// Work Experience (94.4%)
sum idn if playerworkexp>1 & Period==1
// Nationality (Dutch or European 91.6 percent)
sum idn if playernationality!=3 & Period==1

//
sum mean_history_pre if Principal==1 & Period==1, d
gen high_history_pre=(mean_history_pre>r(p50)) if Principal==1
sum high_history_pre if Principal==1 & Period==1

/* check if everything works */
//disable for real
sum participantpayoff if Period==12
gen totalpayoff=participantpayoff
gen totaleur=totalpayoff*0.06
sum totaleur if Period==12
// check pay
/*
gen totalpayoff=participantpayoff
gen totaleur=totalpayoff*0.06
sum totaleur
egen ptotaleur=sum(totaleur) if Period==12
sum ptotaleur
*/

gen dum_control = (control==1)
tabulate dum_control groupe_g if Period<groupshockround & Principal==1, chi2 
tabulate dum_control groupe_g if Period>=groupshockround & Principal==1, chi2 

// Principals
sum control if Principal==1, d

gen diff_payoff=abs(grouppayoff_p1-grouppayoff_p2)
sum diff_payoff if Principal==1 & LH==1
//
gen tot_payoff=grouppayoff_p1+grouppayoff_p2


// Create average payoffs
sort id participantcode Period
by id participantcode: egen payoff_p1 = mean(grouppayoff_p1)
by id participantcode: egen payoff_p2 = mean(grouppayoff_p2)
by id participantcode: egen av_tot_payoff = mean(tot_payoff)

//Create Contribution Average
sort id participantcode Period
by id participantcode: egen av_control = mean(control)
by id participantcode: egen av_trust = mean(trustworthy)
by id participantcode: gen av_diff_payoff = payoff_p1-payoff_p2


//Create payoff diff 1
sort id participantcode Period
by id participantcode: egen payoff_p1_pre = mean(grouppayoff_p1) if Post==0
by id participantcode: replace payoff_p1_pre=payoff_p1_pre[_n-1] if payoff_p1_pre>=.
replace payoff_p1_pre=. if Agent==1
sort id participantcode Period
by id participantcode: egen payoff_p1_post = mean(grouppayoff_p1) if Post==1
by id participantcode: replace payoff_p1_post=payoff_p1_post[_n+1] if payoff_p1_post>=. & Principal==1
by id participantcode: replace payoff_p1_post=payoff_p1_post[_n+2] if payoff_p1_post>=. & Principal==1
by id participantcode: replace payoff_p1_post=payoff_p1_post[_n+3] if payoff_p1_post>=. & Principal==1
by id participantcode: replace payoff_p1_post=payoff_p1_post[_n+4] if payoff_p1_post>=. & Principal==1
by id participantcode: replace payoff_p1_post=payoff_p1_post[_n+5] if payoff_p1_post>=. & Principal==1
by id participantcode: replace payoff_p1_post=payoff_p1_post[_n+6] if payoff_p1_post>=. & Principal==1
by id participantcode: replace payoff_p1_post=payoff_p1_post[_n+7] if payoff_p1_post>=. & Principal==1
by id participantcode: replace payoff_p1_post=payoff_p1_post[_n+8] if payoff_p1_post>=. & Principal==1
by id participantcode: replace payoff_p1_post=payoff_p1_post[_n+9] if payoff_p1_post>=. & Principal==1
replace payoff_p1_post=. if Agent==1


gen abs_payoff_p1_diff = abs(payoff_p1_post-payoff_p1_pre)
gen payoff_p1_diff = payoff_p1_post-payoff_p1_pre

//Create payoff diff 2
sort id participantcode Period
by id participantcode: egen payoff_p2_pre = mean(grouppayoff_p2) if Post==0
by id participantcode: replace payoff_p2_pre=payoff_p2_pre[_n-1] if payoff_p2_pre>=.
replace payoff_p2_pre=. if Agent==1
sort id participantcode Period
by id participantcode: egen payoff_p2_post = mean(grouppayoff_p2) if Post==1
by id participantcode: replace payoff_p2_post=payoff_p2_post[_n+1] if payoff_p2_post>=. & Principal==1
by id participantcode: replace payoff_p2_post=payoff_p2_post[_n+2] if payoff_p2_post>=. & Principal==1
by id participantcode: replace payoff_p2_post=payoff_p2_post[_n+3] if payoff_p2_post>=. & Principal==1
by id participantcode: replace payoff_p2_post=payoff_p2_post[_n+4] if payoff_p2_post>=. & Principal==1
by id participantcode: replace payoff_p2_post=payoff_p2_post[_n+5] if payoff_p2_post>=. & Principal==1
by id participantcode: replace payoff_p2_post=payoff_p2_post[_n+6] if payoff_p2_post>=. & Principal==1
by id participantcode: replace payoff_p2_post=payoff_p2_post[_n+7] if payoff_p2_post>=. & Principal==1
by id participantcode: replace payoff_p2_post=payoff_p2_post[_n+8] if payoff_p2_post>=. & Principal==1
by id participantcode: replace payoff_p2_post=payoff_p2_post[_n+9] if payoff_p2_post>=. & Principal==1
replace payoff_p2_post=. if Agent==1


gen abs_payoff_p2_diff = abs(payoff_p2_post-payoff_p2_pre)
gen payoff_p2_diff = payoff_p2_post-payoff_p2_pre

//Create Control average
sort id participantcode Period
by id participantcode: egen payoff_t_pre = mean(tot_payoff) if Post==0
by id participantcode: replace payoff_t_pre=payoff_t_pre[_n-1] if payoff_p1_pre>=.
replace payoff_t_pre=. if Agent==1
sort id participantcode Period
by id participantcode: egen payoff_t_post = mean(tot_payoff) if Post==1
by id participantcode: replace payoff_t_post=payoff_t_post[_n+1] if payoff_t_post>=. & Principal==1
by id participantcode: replace payoff_t_post=payoff_t_post[_n+2] if payoff_t_post>=. & Principal==1
by id participantcode: replace payoff_t_post=payoff_t_post[_n+3] if payoff_t_post>=. & Principal==1
by id participantcode: replace payoff_t_post=payoff_t_post[_n+4] if payoff_t_post>=. & Principal==1
by id participantcode: replace payoff_t_post=payoff_t_post[_n+5] if payoff_t_post>=. & Principal==1
by id participantcode: replace payoff_t_post=payoff_t_post[_n+6] if payoff_t_post>=. & Principal==1
by id participantcode: replace payoff_t_post=payoff_t_post[_n+7] if payoff_t_post>=. & Principal==1
by id participantcode: replace payoff_t_post=payoff_t_post[_n+8] if payoff_t_post>=. & Principal==1
by id participantcode: replace payoff_t_post=payoff_t_post[_n+9] if payoff_t_post>=. & Principal==1
replace payoff_t_post=. if Agent==1



gen abs_payoff_t_diff = abs(payoff_t_post-payoff_t_pre)
gen payoff_t_diff = payoff_t_post-payoff_t_pre


sum payoff_p1_diff if Period==1 & Principal==1
sum payoff_p1_diff if Period==1 & Principal==1

//labels for tables
label variable av_control "Control"
label variable av_trust "Agent Contribution"
label variable av_diff_payoff "Payoff Difference"
label variable abs_control_change "Absolute Control Adjustment"
label variable Post "Post-change"
label variable LH "Low-to-High Coefficient"
label variable Post_LH "Post-change $\times$ Low-to-High Coefficient"
label variable payoff_p1 "Payoff Principal"
label variable payoff_p2 "Payoff Agent"
label variable av_tot_payoff "Total Payoff"

///Other labels
label variable control "Control"
label variable choice_history "History"
label variable groupshockround "Shock Period"
label variable playerpayoff "Payoff"
label variable trustworthy "Agent Contribution"
label variable grouppayoff_p1 "Payoff Principal"
label variable grouppayoff_p2 "Payoff Agent"
label variable mean_history "History Inspection"
label variable PNFS "PNS"
label variable diff_payoff "Payoff Difference"
label variable tot_payoff "Total Payoffs"
label variable trust_change "Change in Average Agent Contribution"
label variable response_pre2 "Agent Social Behavior (Pre-change)"
/// LH
eststo: estpost sum control trustworthy grouppayoff_p1 grouppayoff_p2 tot_payoff diff_payoff if groupe_g==1 & Period<groupshockround & Principal==1 & NoUnd==0
eststo: estpost sum control trustworthy grouppayoff_p1 grouppayoff_p2 tot_payoff diff_payoff if groupe_g==9 & Period>=groupshockround & Principal==1 & NoUnd==0
/// HL
eststo: estpost sum control trustworthy grouppayoff_p1 grouppayoff_p2 tot_payoff diff_payoff if groupe_g==9 & Period<groupshockround & Principal==1 & NoUnd==0
eststo: estpost sum control trustworthy grouppayoff_p1 grouppayoff_p2 tot_payoff diff_payoff if groupe_g==1 & Period>=groupshockround & Principal==1 & NoUnd==0

//esttab est1 est2 using "C:\Users\gebruiker\Dropbox\Apps\ShareLaTeX\Single Author\paper\Latex\table2.tex", ///
esttab est1 est2 using "3. Output\table2.tex", ///
noobs replace f label booktabs nonum gaps plain ///
cells("mean(fmt(3) label(Mean)) sd(fmt(3) label(S.d.)) min(fmt(3) label(Min)) max(fmt(3) label(Max)) count(fmt(0) label(N))") ///
mtitles("Pre-change (Low Control Costs)" "Post-change (High Control Costs)")

//esttab est3 est4 using "C:\Users\gebruiker\Dropbox\Apps\ShareLaTeX\Single Author\paper\Latex\table3.tex", ///
esttab est3 est4 using "3. Output\table3.tex", ///
noobs replace f label booktabs nonum gaps plain ///
cells("mean(fmt(3) label(Mean)) sd(fmt(3) label(S.d.)) min(fmt(3) label(Min)) max(fmt(3) label(Max)) count(fmt(0) label(N))") ///
mtitles("Pre-change (High Control Costs)" "Post-change (Low Control Costs)")
eststo clear

pwcorr control trustworthy if Principal==1 & NoUnd==0, sig

/// tests
sktest control trustworthy grouppayoff_p1 grouppayoff_p2 tot_payoff diff_payoff if Principal==1 & NoUnd==0
ranksum control if Principal==1 & Period<groupshockround & NoUnd==0, by(LH)
ranksum control if Principal==1 & Period>=groupshockround & NoUnd==0, by(LH)
//
ranksum grouppayoff_p1 if Principal==1 & Period<groupshockround & NoUnd==0, by(LH)
ranksum grouppayoff_p1 if Principal==1 & Period>=groupshockround & NoUnd==0, by(LH)
//
ranksum grouppayoff_p2 if Principal==1 & Period<groupshockround & NoUnd==0, by(LH)
ranksum grouppayoff_p2 if Principal==1 & Period>=groupshockround & NoUnd==0, by(LH)
//
ranksum grouppayoff_p2 if Principal==1 & NoUnd==0, by(Post)
ranksum grouppayoff_p1 if Principal==1 & NoUnd==0, by(Post)
//
sum grouppayoff_p1 grouppayoff_p2 if Principal==1 & NoUnd==0 & Post==0
sum grouppayoff_p1 grouppayoff_p2 if Principal==1 & NoUnd==0 & Post==1

//
ranksum tot_payoff if Principal==1 & Period<groupshockround & NoUnd==0, by(LH)
ranksum tot_payoff if Principal==1 & Period>=groupshockround & NoUnd==0, by(LH)
//
ranksum diff_payoff if Principal==1 & Period<groupshockround & NoUnd==0, by(LH)
ranksum diff_payoff if Principal==1 & Period>=groupshockround & NoUnd==0, by(LH)
//
ranksum control if Principal==1 & LH==1 & NoUnd==0, by(Post)
ranksum control if Principal==1 & LH==0 & NoUnd==0, by(Post)

//
sum control if Principal==1 & Period<groupshockround & NoUnd==0
sum control if Principal==1 & Period>=groupshockround & NoUnd==0
ranksum control if Principal==1 & NoUnd==0, by(Post)
//
ranksum control if Principal==1 & NoUnd==0 & Post==0, by(groupe_g)
ranksum control if Principal==1 & NoUnd==0 & Post==1, by(groupe_g)
//
ranksum trustworthy if Principal==1 & NoUnd==0 & Post==0, by(groupe_g)
ranksum trustworthy if Principal==1 & NoUnd==0 & Post==1, by(groupe_g)

//Response letter test deviations
gen GroupT = (groupe_g==1 & Period<groupshockround)
replace GroupT = 2 if groupe_g==9 & Period>=groupshockround
replace GroupT = 3 if groupe_g==9 & Period<groupshockround
replace GroupT = 4 if groupe_g==1 & Period>=groupshockround
gen GroupT2 = (groupe_g==9 & Period<groupshockround)

robvar control if Principal==1 & NoUnd==0, by(GroupT)
robvar control if Principal==1 & NoUnd==0, by(GroupT2)

//Ttest for Agent Contribution larger than zero
sum id if trustworthy==0 & Principal==1 & NoUnd==0 & control<1
sum id if trustworthy>0 & Principal==1 & NoUnd==0 & control<1

//Hypothesis 1 and 2
eststo: regress control_change LH if Period==1 & Principal==1 & NoUnd==0, vce(robust)
lincom _cons+LH
estadd scalar estim_lh = r(estimate)
estadd scalar se_lh = r(se)
estadd scalar estim_p_lh = 2*ttail(r(df),abs(r(estimate)/r(se)))
lincom _cons
estadd scalar estim_hl = r(estimate)
estadd scalar se_hl = r(se)
estadd scalar estim_p_hl = 2*ttail(r(df),abs(r(estimate)/r(se)))
lincom _cons--(_cons+LH)
estadd scalar estim_a = r(estimate)
estadd scalar se_a = r(se)
estadd scalar estim_p_a = 2*ttail(r(df),abs(r(estimate)/r(se)))

//late versus early Changes
//
eststo: regress control_change LH if Period==1 & Principal==1 & groupshockround<=7 & NoUnd==0, vce(robust)
lincom _cons+LH
estadd scalar estim_lh = r(estimate)
estadd scalar se_lh = r(se)
estadd scalar estim_p_lh = 2*ttail(r(df),abs(r(estimate)/r(se)))
lincom _cons
estadd scalar estim_hl = r(estimate)
estadd scalar se_hl = r(se)
estadd scalar estim_p_hl = 2*ttail(r(df),abs(r(estimate)/r(se)))
lincom _cons--(_cons+LH)
estadd scalar estim_a = r(estimate)
estadd scalar se_a = r(se)
estadd scalar estim_p_a = 2*ttail(r(df),abs(r(estimate)/r(se)))

//
eststo: regress control_change LH if Period==1 & Principal==1 & groupshockround>7 & NoUnd==0, vce(robust)
lincom _cons+LH
estadd scalar estim_lh = r(estimate)
estadd scalar se_lh = r(se)
estadd scalar estim_p_lh = 2*ttail(r(df),abs(r(estimate)/r(se)))
lincom _cons
estadd scalar estim_hl = r(estimate)
estadd scalar se_hl = r(se)
estadd scalar estim_p_hl = 2*ttail(r(df),abs(r(estimate)/r(se)))
lincom _cons--(_cons+LH)
estadd scalar estim_a = r(estimate)
estadd scalar se_a = r(se)
estadd scalar estim_p_a = 2*ttail(r(df),abs(r(estimate)/r(se)))

//
//esttab using "C:\Users\gebruiker\Dropbox\Apps\ShareLaTeX\Single Author\paper\Latex\table4.tex", ///
esttab using "3. Output\table4.tex", ///
	replace f obslast label booktabs b(3) p(3) alignment(S S S) ///
	star(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) ///
	mtitles("\shortstack {All\\ Changes}" "\shortstack {Earlier\\ Changes}" "\shortstack {Later\\ Changes}" "\shortstack {High Need\\ for Structure}" "\shortstack {Low Need\\ for Structure}") ///
	cells("b(fmt(3)star)" "se(fmt(3)par)") compress ///
	stats(estim_hl estim_lh estim_a r2 df_m F N, fmt(3 3 3 3 0 3 0) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") ///
	labels(`"High-to-Low Change"' `"Low-to-High Change"' `"Asymmetry Coefficient"' `"R$^2$"' `"Model Degrees of Freedom"' `"F-statistic"' `"Observations"' ))
eststo clear

//Supplemental test 1: Compare coefficients
regress control_change LH if Period==1 & Principal==1 & groupshockround<=7 & NoUnd==0
est store early

regress control_change LH if Period==1 & Principal==1 & groupshockround>7 & NoUnd==0
est store late

suest early late

test [early_mean]_cons=[late_mean]_cons
test [early_mean]_cons--([early_mean]_cons+[early_mean]LH)=[late_mean]_cons--([late_mean]_cons+[late_mean]LH)
return li

//Check asymmetry in agents responses
eststo: regress trust_change LH if Period==1 & Agent==1 & NoUnd==0, vce(robust)
lincom _cons+LH
estadd scalar estim_lh = r(estimate)
estadd scalar se_lh = r(se)
estadd scalar estim_p_lh = 2*ttail(r(df),abs(r(estimate)/r(se)))
lincom _cons
estadd scalar estim_hl = r(estimate)
estadd scalar se_hl = r(se)
estadd scalar estim_p_hl = 2*ttail(r(df),abs(r(estimate)/r(se)))
lincom _cons--(_cons+LH)
estadd scalar estim_a = r(estimate)
estadd scalar se_a = r(se)
estadd scalar estim_p_a = 2*ttail(r(df),abs(r(estimate)/r(se)))

//esttab using "C:\Users\gebruiker\Dropbox\Apps\ShareLaTeX\Single Author\paper\Latex\table7.tex", ///
esttab using "3. Output\table7.tex", ///
	replace f obslast label booktabs b(3) p(3) alignment(S S S) ///
	star(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) ///
	mtitles("\shortstack {Change in Average\\ Agent Contribution}") ///
	cells("b(fmt(3)star)" "se(fmt(3)par)") compress ///
	stats(estim_hl estim_lh estim_a r2 df_m F N, fmt(3 3 3 3 0 3 0) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") ///
	labels(`"High-to-Low Change"' `"Low-to-High Change"' `"Asymmetry Coefficient"' `"R$^2$"' `"Model Degrees of Freedom"' `"F-statistic"' `"Observations"' ))
eststo clear

//TABLE 5

eststo: regress control_change c.response_pre2 if LH==1 & Period==1 & Principal==1 & NoUnd==0, vce(robust)
eststo: regress control_change c.response_pre2 if HL==1 & Period==1 & Principal==1 & NoUnd==0, vce(robust)
esttab using "3. Output\table5.tex", ///
	replace f obslast label booktabs b(3) p(3) alignment(S S S) ///
	star(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) ///
	mtitles("\shortstack {Control Costs\\ Increase}" "\shortstack {Control Costs\\ Decrease}") ///
	cells("b(fmt(3)star)" "se(fmt(3)par)") compress ///
	stats(r2 df_m F N, fmt(3 0 3 0) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") ///
	labels(`"R$^2$"' `"Model Degrees of Freedom"' `"F-statistic"' `"Observations"' ))
eststo clear

//Agent Contribution




// TABLE 6
eststo: regress payoff_p1_diff LH if Period==1 & Principal==1 & NoUnd==0, vce(robust)
lincom _cons+LH
estadd scalar estim_lh = r(estimate)
estadd scalar se_lh = r(se)
estadd scalar estim_p_lh = 2*ttail(r(df),abs(r(estimate)/r(se)))
lincom _cons
estadd scalar estim_hl = r(estimate)
estadd scalar se_hl = r(se)
estadd scalar estim_p_hl = 2*ttail(r(df),abs(r(estimate)/r(se)))
lincom _cons--(_cons+LH)
estadd scalar estim_a = r(estimate)
estadd scalar se_a = r(se)
estadd scalar estim_p_a = 2*ttail(r(df),abs(r(estimate)/r(se)))

eststo: regress payoff_p2_diff LH if Period==1 & Principal==1 & NoUnd==0, vce(robust)
lincom _cons+LH
estadd scalar estim_lh = r(estimate)
estadd scalar se_lh = r(se)
estadd scalar estim_p_lh = 2*ttail(r(df),abs(r(estimate)/r(se)))
lincom _cons
estadd scalar estim_hl = r(estimate)
estadd scalar se_hl = r(se)
estadd scalar estim_p_hl = 2*ttail(r(df),abs(r(estimate)/r(se)))
lincom _cons--(_cons+LH)
estadd scalar estim_a = r(estimate)
estadd scalar se_a = r(se)
estadd scalar estim_p_a = 2*ttail(r(df),abs(r(estimate)/r(se)))

eststo: regress payoff_t_diff LH if Period==1 & Principal==1 & NoUnd==0, vce(robust)
lincom _cons+LH
estadd scalar estim_lh = r(estimate)
estadd scalar se_lh = r(se)
estadd scalar estim_p_lh = 2*ttail(r(df),abs(r(estimate)/r(se)))
lincom _cons
estadd scalar estim_hl = r(estimate)
estadd scalar se_hl = r(se)
estadd scalar estim_p_hl = 2*ttail(r(df),abs(r(estimate)/r(se)))
lincom _cons--(_cons+LH)
estadd scalar estim_a = r(estimate)
estadd scalar se_a = r(se)
estadd scalar estim_p_a = 2*ttail(r(df),abs(r(estimate)/r(se)))

//esttab using "C:\Users\gebruiker\Dropbox\Apps\ShareLaTeX\Single Author\paper\Latex\table6.tex", ///
esttab using "3. Output\table6.tex", ///
	replace f obslast label booktabs b(3) p(3) alignment(S S S) ///
	star(* 0.10 ** 0.05 *** 0.01) eqlabels(none) collabels(none) ///
	mtitles("\shortstack {Principal\\ Payoff Change}" "\shortstack {Agent\\ Payoff Change}" "\shortstack {Total\\ Payoff Change}") ///
	cells("b(fmt(3)star)" "se(fmt(3)par)") compress ///
	stats(estim_hl estim_lh estim_a r2 df_m F N, fmt(3 3 3 3 0 3 0) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") ///
	labels(`"High-to-Low Change"' `"Low-to-High Change"' `"Asymmetry Coefficient"' `"R$^2$"' `"Model Degrees of Freedom"' `"F-statistic"' `"Observations"' ))
eststo clear

//
sum playercons2 playercons3 playercons4 if Period==1 & Principal==1 & NoUnd==0 
sktest playercons2 playercons3 playercons4 if Period==1 & Principal==1 & NoUnd==0 

sum playercons2 playercons3 playercons4 if Period==1 & Principal==1 & NoUnd==0 & LH==1
sum playercons2 playercons3 playercons4 if Period==1 & Principal==1 & NoUnd==0 & LH==0
ranksum playercons2 if Period==1 & Principal==1 & NoUnd==0, by(LH)
ranksum playercons3 if Period==1 & Principal==1 & NoUnd==0, by(LH)
ranksum playercons4 if Period==1 & Principal==1 & NoUnd==0, by(LH)

sum playercons2 playercons3 playercons4 if Period==1 & Principal==1 & NoUnd==0 & LH==1 & late_shock==0
sum playercons2 playercons3 playercons4 if Period==1 & Principal==1 & NoUnd==0 & LH==0 & late_shock==0
ranksum playercons2 if Period==1 & Principal==1 & NoUnd==0 & late_shock==0, by(LH)
ranksum playercons3 if Period==1 & Principal==1 & NoUnd==0 & late_shock==0, by(LH)
ranksum playercons4 if Period==1 & Principal==1 & NoUnd==0 & late_shock==0, by(LH)

sum playercons2 playercons3 playercons4 if Period==1 & Principal==1 & NoUnd==0 & LH==1 & late_shock==1
sum playercons2 playercons3 playercons4 if Period==1 & Principal==1 & NoUnd==0 & LH==0 & late_shock==1
ranksum playercons2 if Period==1 & Principal==1 & NoUnd==0 & late_shock==1, by(LH)
ranksum playercons3 if Period==1 & Principal==1 & NoUnd==0 & late_shock==1, by(LH)
ranksum playercons4 if Period==1 & Principal==1 & NoUnd==0 & late_shock==1, by(LH)
//alpha playercons2-playercons4 if Period==1 & Principal==1 & NoUnd==0, item

// 
keep if Principal==1 & NoUnd==0 | ///
Agent==1 & NoUnd==0

//Prepare for graphs
label variable control "Control"
label variable LH "Treatment"
tostring LH, replace
replace LH="Low-to-High" if LH=="1"
replace LH="High-to-Low" if LH=="0"
//Create variable to do information search figures
label variable mean_history_pre_t "Pre-change History Inspection"
label variable mean_history_post_t "Post-change History Inspection"
gen selection=(Period==groupshockround | Period==groupshockround-1)
gen mean_history_comp=mean_history_pre_t if selection==1 & Post==0
replace mean_history_comp=mean_history_post_t if selection==1 & Post==1
replace mean_history_comp=. if selection==0
label variable mean_history_comp "History Inspection Comp"

label variable choice_history "History Inspection"
sum choice_history if Principal==1 & NoUnd==0

label variable history "History Inspection Total"
sum choice_history if Principal==1 & NoUnd==0

label variable Post "Stage"
tostring Post, replace
replace Post="Post-change" if Post=="1"
replace Post="Pre-change" if Post=="0"
label variable response "Response"
label variable groupe_g "Control Costs"
tostring groupe_g, replace
replace groupe_g="High" if groupe_g=="9"
replace groupe_g="Low" if groupe_g=="1"
sum control if Principal==1, d
gen controlsplit=(control>=r(p50))
sum control controlsplit if Principal==1, d
label variable controlsplit "Control Dummy"
tostring controlsplit, replace
replace controlsplit="High" if controlsplit=="1"
replace controlsplit="Low" if controlsplit=="0"
label variable trustworthy "Agent Influence"
label variable av_control "Average Control 2"
sort Period LH participantcode
by Period LH: egen av2_control = mean(control)
by Period LH: egen me2_control = median(control)
label variable av2_control "Average Control"
label variable me2_control "Median Control"
label variable Period "Period"
//
drop shocktiming
gen shocktiming=(groupshockround>6)
label variable shocktiming "Timing of Changes"
tostring shocktiming, replace
replace shocktiming="Later Changes" if shocktiming=="1"
replace shocktiming="Earlier Changes" if shocktiming=="0"
//
gen controlpr = 0.84 if HL==1 & Period>=groupshockround
label variable controlpr "Control "
replace controlpr = 0.84 if HL==0 & Period<groupshockround
replace controlpr = 0.64 if HL==1 & Period<groupshockround
replace controlpr = 0.64 if HL==0 & Period>=groupshockround
//
gen shocktimemore=(groupshockround<7)
replace shocktimemore=2 if groupshockround>7
label variable shocktimemore "More Timing"
tostring shocktimemore, replace
replace shocktimemore="Later Changes" if shocktimemore=="2"
replace shocktimemore="Earlier Changes" if shocktimemore=="1"
//

//Save merged raw dataset in pipeline folder
save "3. Output\modified dataset.dta", replace
export excel using "3. Output\modified dataset.xlsx", replace firstrow(varl)
export delimited using "3. Output\modified dataset.csv", replace

exit, STATA clear
