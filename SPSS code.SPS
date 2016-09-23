*******************************************************************************
Created by: Jill Budden
Client: Halliburton
Test: TMCB 5.3 (a shortened version of the TMCB 5.0)
Date: January 2008
Reference syntax: Denso, Lennox, Gaterade,  Westinghouse (LII)
Note: 
Weighting was based on validity and adverse impact tradeoffs (an excel spreadsheet in the client's Analysis folder illustrates these tradeoffs). 
The length of the test was cut in half because the client wanted a shorter test. 
Different TMCB scale lengths were compared looking at validity and adverse impact statistics. 
WRJ Situational Judgment, WSD Locus of Control, WSD Decision Making Style, WSD Work Quality are not included in the TMCB 5.3 
WSD Job Fit Team Member & WSD Adaptability are included in the TMCB 5.3, but not scored, in order to balance out the WSD Self-Efficacy items.

*******************************************************************************


************************************************Merging files************************************************************************


Match files file='Y:\CLIENTS\Halliburton\Operators Validation Study\Predictor\final_AMS_Master_TestPortal_1649_merged.sav'
	/file='Y:\CLIENTS\Halliburton\Operators Validation Study\Criteria\criterion_data.sav'
            /IN matched
	/BY cde_applicant_id.
EXECUTE.

***NOTE: 2 duplicate applicant IDs (177518 & 177515)***

*****************************************************************************************************************************************************************

RENAME VARIABLES (Q3915021 Q3915041 = gender bdate).


*Creating race variables for 7-x webtests tests.
*Creating Race Variables.
DO IF (Q3915011_3915061 = 3915061).
	compute cvb = 0.
END IF.
DO IF (Q3915011_3915031 = 3915031).
	compute cvb = 1.
END IF.
variable labels Q3915011_3915061 'Caucasian'.
variable labels Q3915011_3915031 'African American'.
variable labels cvb 'Caucasian versus African American'.
value labels cvb 0 'Caucasian' 1 'African American'.

DO IF (Q3915011_3915061 = 3915061).
	compute cvi = 0.
END IF.
DO IF (Q3915011_3915011 = 3915011).
	compute cvi = 1.
END IF.
variable labels Q3915011_3915011 'American Indian or Alaskan Native'.
variable labels cvi 'Caucasian versus American Indian or Alaskan Native'.
value labels cvi 0 'Caucasian' 1 'American Indian or Alaskan Native'.

DO IF (Q3915011_3915061 = 3915061).
	compute cvn = 0.
END IF.
DO IF (Q3915011_3915051 = 3915051).
	compute cvn = 1.
END IF.
variable labels Q3915011_3915051 'Native Hawaiian or Other Pacific Islander'.
variable labels cvn 'Caucasian versus Native Hawaiian or Other Pacific Islander'.
value labels cvn 0 'Caucasian' 1 'Native Hawaiian or Other Pacific Islander'.

DO IF (Q3915011_3915061 = 3915061).
	compute cva = 0.
END IF.
DO IF (Q3915011_3915021 = 3915021).
	compute cva = 1.
END IF.
variable labels Q3915011_3915021'Asian'.
variable labels cva 'Caucasian versus Asian'.
value labels cva 0 'Caucasian' 1 'Asian'.

DO IF (Q3915011_3915061 = 3915061).
	compute cvh = 0.
END IF.
DO IF (Q3915011_3915041 = 3915041).
	compute cvh = 1.
END IF.
variable labels Q3915011_3915041'Hispanic'.
variable labels cvh 'Caucasian versus Hispanic'.
value labels cvh 0 'Caucasian' 1 'Hispanic'.

DO IF (Q3915011_3915061 = 3915061).
	compute cvo = 0.
END IF.
DO IF (Q3915011_3915071 = 3915071).
	compute cvo = 1.
END IF.
variable labels Q3915011_3915071 'Other'.
variable labels cvo 'Caucasian versus Other Category'.
value labels cvo 0 'Caucasian' 1 'Other Category'.
exe .

/*This is iffy
DO IF (Q3915011_3915061 = 3915061).
	compute cvm = 0.
END IF.
DO IF (Q3915011_3915011 = 3915011 or Q3915011_3915021 = 3915021 or Q3915011_3915031 = 3915031 or Q3915011_3915041 = 3915041 or Q3915011_3915051 = 3915051 or Q3915011_3915071 = 3915071).
	compute cvm = 1.
END IF.
variable labels cvm 'Caucasian versus All Minorities'.
value labels cvm 0 'Caucasian' 1 'All Minorities'.
exe.

*Constructing a single race variable - there are some problems when a candidate chooses more than one minority.
DO IF (Q3915011_3915061 = 3915061).
	compute race = 1.
END IF.
DO IF (Q3915011_3915011 = 3915011).
	compute race = 2.
END IF.
DO IF (Q3915011_3915031 = 3915031).
	compute race = 3.
END IF.
DO IF (Q3915011_3915051 = 3915051).
	compute race = 4.
END IF.
DO IF (Q3915011_3915021 = 3915021).
	compute race = 5.
END IF.
DO IF (Q3915011_3915041 = 3915041).
	compute race = 6.
END IF.
DO IF (Q3915011_3915071 = 3915071).
	compute race = 7.
END IF.
variable label race 'Race (as a single categorical variable)'.
value labels race 1 'Caucasian' 2 'American Indian or Alaskan Native' 3 'African American'
4 'Native Hawaiian or Other Pacific Islander' 5 'Asian' 6 'Hispanic' 7 'Other Category'.
exe.

recode Q3915031 (3915311=1) (3915321=2) (3915331=3) (3915341=4) (3915351=5) (3915361=6) into education .
value labels education
 1 'Some high school'
 2 'High school diploma or equivalent'
 3 '2-year technical school or associate degree'
 4 '4-year college degree (e.g., BA or BS)'
 5 'Masters degree'
 6 'Doctorate' .
exe .
variable label education 'education'.
exe.

*Gender.
RECODE Gender (940=1) (945=2) (6602021=1) (6602011=2) (3915211=1) (3915221=2) (ELSE = SYSMIS).
value labels gender 1 'Male' 2 'Female'.

*Converting string bdate into date birthdate.
COMPUTE birthdate = numeric(bdate, ADATE10). 

FORMAT birthdate (ADATE10).
FORMAT dte_application_date (ADATE10).

*Creating a variable that holds todays date.
COMMENT $time is a numeric system variable that holds data and time.
compute currentdate = XDATE.DATE($TIME).

*formatting to american date.
format currentdate (ADATE11).

*Creating a variable that tells me how old each candidate is.
COMPUTE age = DATEDIFF(currentdate, birthdate, "year"). 

*Selecting only those who are aged 16 and older.
DO IF (age le 15).
	compute age = $SYSMIS.
END IF.

*Creating 40 and over variable.
DO IF (age ge 40).
	compute Over40 = 1.
ELSE.
	compute Over40 = 0.
END IF.
Variable Labels Over40 'Age over 40'.
Value labels Over40 0 'Under 40' 1 '40 and Over'.
exe.


variable labels
Q3901011	'I can see a clear link between the assessment and what I think is required by the job.'
Q3901021	'I tried my best on the assessment.'
Q3901031	'People who score well on the assessment will be good performers on the job.'
Q3901041	'It would be obvious to anyone that the items on the assessment are related to the job.'
Q3901051	'Doing well on the assessment probably means that a person can do the job well.'
Q3901061	 'I represented my experiences and opinions accurately when answering the questions on the assessment.'
Q3901071	'The assessment will provide an accurate evaluation of a candidates job-related background and experiences.'.
exe .

 value labels Q3901011 to Q3901071 
3900011 	'1'
3900021	'2'
3900031	'3'
3900041	'4'
3900051	'5'.
exe .
 
recode Q3901011 to Q3901071 (3900011=1) (3900021=2) (3900031=3) (3900041=4) (3900051=5) into ir1 to ir7.

Variable Labels
ir1 'I can see a clear link between the assessment and what I think is required by the job.'
ir2 'I tried my best on the assessment.'
ir3 'People who score well on the assessment will be good performers on the job.'
ir4 'It would be obvious to anyone that the items on the assessment are related to the job.'
ir5 'Doing well on the assessment probably means that a person can do the job well.'
ir6 'I represented my experiences and opinions accurately when answering the questions on the assessment.'
ir7 'The assessment will provide an accurate evaluation of a candidates job-related background and experiences.'.
exe .

Value Labels ir1 to ir7
1 'Strongly Disagree'
2 'Disagree'
3 'Neither Agree nor Disagree'
4 'Agree'
5 'Strongly Agree'.

variable labels 
	Q3901081 'Hours:'
	Q3901091 'Minutes:'
	Q3901101 'Do you have any additional comments about the assessment?'.
exe.



/*last category is actually 'more than 9'
recode Q3901081
(3900081=0) (3900091=1) (3900101=2) (3900111=3) (3900121=4) (3900131=5) (3900141=6) (3900151=7) (3900161=8) (3900171=9) (3900181=10) into hours .

recode Q3901091
(3900191=0 ) (3900201=1 ) (3900211=2 ) (3900221=3 ) (3900231=4 ) (3900241=5 ) (3900251=6 ) (3900261=7 ) (3900271=8 ) (3900281=9 ) (3900291=10) (3900301=11) 
(3900311=12) (3900321=13) (3900331=14) (3900341=15) (3900351=16) (3900361=17) (3900371=18) (3900381=19) (3900391=20) (3900401=21) (3900411=22) (3900421=23) 
(3900431=24) (3900441=25) (3900451=26) (3900461=27) (3900471=28) (3900481=29) (3900491=30) (3900501=31) (3900511=32) (3900521=33) (3900531=34) (3900541=35) 
(3900551=36) (3900561=37) (3900571=38) (3900581=39) (3900591=40) (3900601=41) (3900611=42) (3900621=43) (3900631=44) (3900641=45) (3900651=46) (3900661=47) 
(3900671=48) (3900681=49) (3900691=50) (3900701=51) (3900711=52) (3900721=53) (3900731=54) (3900741=55) (3900751=56) (3900761=57) (3900771=58) (3900781=59)
into minutes.
exe.


variable labels
	Q3911041 'Organizational Tenure (years)'
	Q3911051 'Organizational Tenure (months)'
	Q3911061 'Tenure in current position (years)'
	Q3911071 'Tenure in current position (months)'. 
exe.

/*last category is actually 'more than 50'
recode Q3911041 Q3911061
(3920011=0 ) (3920021=1 ) (3920031=2 ) (3920041=3 ) (3920051=4 ) (3920061=5 ) (3920071=6 ) (3920081=7 ) (3920091=8 ) (3920101=9 ) (3920111=10) (3920121=11) 
(3920131=12) (3920141=13) (3920151=14) (3920161=15) (3920171=16) (3920181=17) (3920191=18) (3920201=19) (3920211=20) (3920221=21) (3920231=22) (3920241=23) 
(3920251=24) (3920261=25) (3920271=26) (3920281=27) (3920291=28) (3920301=29) (3920311=30) (3920321=31) (3920331=32) (3920341=33) (3920351=34) (3920361=35) 
(3920371=36) (3920381=37) (3920391=38) (3920401=39) (3920411=40) (3920421=41) (3920431=42) (3920441=43) (3920451=44) (3920461=45) (3920471=46) (3920481=47) 
(3920491=48) (3920501=49) (3920511=50) (3920521=51)
into org_yrs pos_yrs. 

recode Q3911051 Q3911071
(3920641=0 ) (3920531=1 ) (3920541=2 ) (3920551=3 ) (3920561=4 ) (3920571=5 ) (3920581=6 ) (3920591=7 ) (3920601=8 ) (3920611=9 ) (3920621=10) (3920631=11)
into org_mths pos_mths.

COMPUTE orgten = (org_yrs*12) + (org_mths) .
COMPUTE jobten = (pos_yrs*12) + (pos_mths) .

variable labels
	hours 'Hours:'
	minutes 'Minutes:'
	org_yrs 'Organizational Tenure (years)'
	org_mths 'Organizational Tenure (months)'
	pos_yrs 'Tenure in current position (years)'
	pos_mths 'Tenure in current position (months)'
	orgten 'Organizational Tenure Total (Measured in Months)'
	jobten 'Position Tenure Total (Measured in Months)'.
exe.

/*E3
recode Q3905011 to Q3905241 (3900041=4) (3900051=5) (3900011=1) (3900021=2) (3900031=3) into e1 to e24.

Variable labels
e1 'In my department, my ideas and opinions are appreciated.'
e2 'People trust each other in my department.'
e3 'My job provides me with chances to grow and develop.'
e4 'I rarely think about quitting my job.'
e5 'In my department, people are assigned tasks that allow them to use their best skills.'
e6 'My department makes efficient use of its resources, time, and budget.'
e7 'I get sufficient feedback about how well I am doing.'
e8 'In my department, people are held accountable for low performance.'
e9 'Overall, I have a good understanding of what I am supposed to be doing in my job.'
e10 'I feel that I will be a long-term Associate in this company.'
e11 'People in my department quickly resolve conflicts when they arise.'
e12 'I am kept well informed about changes in the organization that affect my department.'
e13 'In this organization, different departments reach out to help and support each other.'
e14 'I cannot think of any reasons why I would quit my current job.'
e15 'People in my department understand and respect the things that make me unique.'
e16 'In my department, meetings are focused and efficient.'
e17 'People in my department cooperate with each other to get the job done.'
e18 'I find personal meaning and fulfillment in my work.'
e19 'I will probably <B>not</B> look for a new job within the next 6 months.'
e20 'I can make meaningful decisions about how I do my job.'
e21 'In my department, everyone tries to pick up new skills and knowledge.'
e22 'I am satisfied with my job.'
e23 'I would recommend employment at my organization to my friends or family.'
e24 'I feel a sense of loyalty to this company.'.


***E3 Scoring/Labels.

COMPUTE e3_CABER		= MEAN(e1, e2, e3, e5, e6, e7, e8, e9, e11,e12, e13, 
					e15, e16, e17, e18, e20, e21) * 17.
COMPUTE e3_outcomes	= MEAN(e22, e23, e24) * 3.
COMPUTE int_stay 		= MEAN(e4, e10, e14, e19) * 4.

variable labels 
	e3_CABER 	'Employee Engagement'
	int_stay	 	'Employee Intent to Stay' .
execute .

VARIABLE LABELS
	e3_CABER	'E3 Employee Engagement'
	e3_outcomes	'E3 outcomes'
	int_stay 	'Intent to Stay'.
	EXECUTE.

DESCRIPTIVES
  VARIABLES=e3_CABER int_stay  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX .

*To Eliminate Univariate Outliers.
RECODE 	Ze3_CABER Zint_stay  
  		(Lowest thru -3.29=SYSMIS)  (3.29 thru Highest=SYSMIS).
EXECUTE.



************************************************************************************************************************************************


/*Recoding from question ids to rcb variables.

RECODE Q70001 (70021=1) (70023=2) (70025=3) (70027=4) into rcb1.
RECODE Q70003 (70029=1) (70031=2) (70033=3) (70035=4) (70037=5) into rcb2.
RECODE Q70005 (70039=1) (70041=2) (70043=3) (70045=4) into rcb3.
RECODE Q70007 (70047=1) (70049=2) (70051=3) (70053=4) into rcb4.
RECODE Q70009 (70055=1) (70057=2) (70059=3) (70061=4) into rcb5.
RECODE Q70011 (70063=1) (70065=2) (70067=3) (70069=4) into rcb6.
RECODE Q70013 (70071=1) (70073=2) (70075=3) (70077=4) into rcb7.
RECODE Q70015 (70079=1) (70081=2) (70083=3) (70085=4) into rcb8.
RECODE Q70017 (70087=1) (70089=2) (70091=3) (70093=4) (70095=5) into rcb9.
RECODE Q70019 (70097=1) (70099=2) (70101=3) (70103=4) into rcb10.
RECODE Q70021 (70105=1) (70107=2) (70109=3) (70111=4) (70113=5) into rcb11.
RECODE Q70025 (70123=1) (70125=2) (70127=3) (70129=4) into rcb12.
RECODE Q70223 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb13.
RECODE Q70225 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb14.
RECODE Q70227 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb15.
RECODE Q70229 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb16.
RECODE Q70231 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb17.
RECODE Q70233 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb18.
RECODE Q70235 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb19.
RECODE Q70029 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb20.
RECODE Q70031 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb21.
RECODE Q70033 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb22.
RECODE Q70035 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb23.
RECODE Q70037 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb24.
RECODE Q70039 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb25.
RECODE Q70041 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb26.
RECODE Q70045 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb27.
RECODE Q70047 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb28.
RECODE Q70049 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb29.
RECODE Q70051 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb30.
RECODE Q70053 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb31.
RECODE Q70055 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb32.
RECODE Q70057 (70001=1) (70003=2) (70005=3) (70007=4) (70009=5) into rcb33.
RECODE Q70061 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb34.
RECODE Q70063 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb35.
RECODE Q70065 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb36.
RECODE Q70067 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb37.
RECODE Q70069 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb38.
RECODE Q70071 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb39.
RECODE Q70073 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb40.
RECODE Q70075 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb41.
RECODE Q70077 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb42.
RECODE Q70079 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb43.
RECODE Q70083 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb44.
RECODE Q70085 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb45.
RECODE Q70087 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb46.
RECODE Q70089 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb47.
RECODE Q70091 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb48.
RECODE Q70093 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb49.
RECODE Q70095 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb50.
RECODE Q70097 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb51.
RECODE Q70099 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb52.
RECODE Q70101 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb53.
RECODE Q70105 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb54.
RECODE Q70107 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb55.
RECODE Q70109 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb56.
RECODE Q70111 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb57.
RECODE Q70113 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb58.
RECODE Q70115 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb59.
RECODE Q70117 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb60.
RECODE Q70119 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb61.
RECODE Q70121 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb62.
RECODE Q70123 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb63.
RECODE Q70127 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb64.
RECODE Q70129 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb65.
RECODE Q70131 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb66.
RECODE Q70133 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb67.
RECODE Q70135 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb68.
RECODE Q70137 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb69.
RECODE Q70139 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb70.
RECODE Q70141 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb71.
RECODE Q70143 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb72.
RECODE Q70145 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb73.
RECODE Q70149 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb74.
RECODE Q70151 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb75.
RECODE Q70153 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb76.
RECODE Q70155 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb77.
RECODE Q70157 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb78.
RECODE Q70159 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb79.
RECODE Q70161 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb80.
RECODE Q70163 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb81.
RECODE Q70165 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb82.
RECODE Q70167 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb83.
RECODE Q70171 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb84.
RECODE Q70173 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb85.
RECODE Q70175 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb86.
RECODE Q70177 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb87.
RECODE Q70179 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb88.
RECODE Q70181 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb89.
RECODE Q70183 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb90.
RECODE Q70185 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb91.
RECODE Q70187 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb92.
RECODE Q70189 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into rcb93.
RECODE Q70193 (70131=1) (70133=2) (70135=3) (70137=4) (70139=5) into rcb94.
RECODE Q70195 (70141=1) (70143=2) (70145=3) (70147=4) (70149=5) into rcb95.
RECODE Q70197 (70151=1) (70153=2) (70155=3) (70157=4) (70159=5) into rcb96.
RECODE Q70199 (70161=1) (70163=2) (70165=3) (70167=4) into rcb97.
RECODE Q70201 (70169=1) (70171=2) (70173=3) (70175=4) into rcb98.
RECODE Q70203 (70177=1) (70179=2) (70181=3) (70183=4) (70185=5) into rcb99.
RECODE Q70205 (70187=1) (70189=2) (70191=3) (70193=4) (70195=5) into rcb100.
RECODE Q70207 (70197=1) (70199=2) (70201=3) (70203=4) into rcb101.
RECODE Q70209 (70205=1) (70207=2) (70209=3) (70211=4) into rcb102.
RECODE Q70211 (70213=1) (70215=2) (70217=3) (70219=4) (70221=5) into rcb103.
RECODE Q70213 (70223=1) (70225=2) (70227=3) (70229=4) into rcb104.
RECODE Q70215 (70231=1) (70233=2) (70235=3) (70237=4) (70239=5) into rcb105.
RECODE Q70217 (70241=1) (70243=2) (70245=3) (70247=4) into rcb106.
RECODE Q70219 (70249=1) (70251=2) (70253=3) (70255=4) into rcb107.



/*Recoding from question ids to cb variables.

RECODE Q70001 (70021=0) (70023=1) (70025=0) (70027=0) into cb1.
RECODE Q70003 (70029=0) (70031=0) (70033=0) (70035=0) (70037=1) into cb2.
RECODE Q70005 (70039=0) (70041=0) (70043=1) (70045=0) into cb3.
RECODE Q70007 (70047=0) (70049=1) (70051=0) (70053=0) into cb4.
RECODE Q70009 (70055=1) (70057=0) (70059=0) (70061=0) into cb5.
RECODE Q70011 (70063=0) (70065=1) (70067=0) (70069=0) into cb6.
RECODE Q70013 (70071=0) (70073=1) (70075=0) (70077=0) into cb7.
RECODE Q70015 (70079=0) (70081=0) (70083=0) (70085=1) into cb8.
RECODE Q70017 (70087=1) (70089=0) (70091=0) (70093=0) (70095=0) into cb9.
RECODE Q70019 (70097=0) (70099=1) (70101=0) (70103=0) into cb10.
RECODE Q70021 (70105=1) (70107=0) (70109=0) (70111=0) (70113=0) into cb11.
RECODE Q70025 (70123=0) (70125=1) (70127=0) (70129=0) into cb12.
RECODE Q70223 (70001=4) (70003=3) (70005=2) (70007=1) (70009=0) into cb13.
RECODE Q70225 (70001=4) (70003=3) (70005=2) (70007=1) (70009=0) into cb14.
RECODE Q70227 (70001=0) (70003=1) (70005=2) (70007=3) (70009=4) into cb15.
RECODE Q70229 (70001=2.4) (70003=1.4) (70005=0.4) (70007=0.6) (70009=1.6) into cb16.
RECODE Q70231 (70001=4) (70003=3) (70005=2) (70007=1) (70009=0) into cb17.
RECODE Q70233 (70001=2.4) (70003=1.4) (70005=0.4) (70007=0.6) (70009=1.6) into cb18.
RECODE Q70235 (70001=1) (70003=0) (70005=1) (70007=2) (70009=3) into cb19.
RECODE Q70029 (70001=3) (70003=2) (70005=1) (70007=0) (70009=1) into cb20.
RECODE Q70031 (70001=1) (70003=0) (70005=1) (70007=2) (70009=3) into cb21.
RECODE Q70033 (70001=3) (70003=2) (70005=1) (70007=0) (70009=1) into cb22.
RECODE Q70035 (70001=0.5) (70003=0.5) (70005=1.5) (70007=2.5) (70009=3.5) into cb23.
RECODE Q70037 (70001=4) (70003=3) (70005=2) (70007=1) (70009=0) into cb24.
RECODE Q70039 (70001=4) (70003=3) (70005=2) (70007=1) (70009=0) into cb25.
RECODE Q70041 (70001=0.5) (70003=0.5) (70005=1.5) (70007=2.5) (70009=3.5) into cb26.
RECODE Q70045 (70001=2.4) (70003=1.4) (70005=0.4) (70007=0.6) (70009=1.6) into cb27.
RECODE Q70047 (70001=3) (70003=2) (70005=1) (70007=0) (70009=1) into cb28.
RECODE Q70049 (70001=1.9) (70003=0.9) (70005=0.1) (70007=1.1) (70009=2.1) into cb29.
RECODE Q70051 (70001=1) (70003=0) (70005=1) (70007=2) (70009=3) into cb30.
RECODE Q70053 (70001=0) (70003=1) (70005=2) (70007=3) (70009=4) into cb31.
RECODE Q70055 (70001=1.6) (70003=0.6) (70005=0.4) (70007=1.4) (70009=2.4) into cb32.
RECODE Q70057 (70001=2.3) (70003=1.3) (70005=0.3) (70007=0.7) (70009=1.7) into cb33.
RECODE Q70061 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb34.
RECODE Q70063 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb35.
RECODE Q70065 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb36.
RECODE Q70067 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb37.
RECODE Q70069 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb38.
RECODE Q70071 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb39.
RECODE Q70073 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb40.
RECODE Q70075 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb41.
RECODE Q70077 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb42.
RECODE Q70079 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb43.
RECODE Q70083 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb44.
RECODE Q70085 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb45.
RECODE Q70087 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb46.
RECODE Q70089 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb47.
RECODE Q70091 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb48.
RECODE Q70093 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb49.
RECODE Q70095 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb50.
RECODE Q70097 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb51.
RECODE Q70099 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb52.
RECODE Q70101 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb53.
RECODE Q70105 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb54.
RECODE Q70107 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb55.
RECODE Q70109 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb56.
RECODE Q70111 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb57.
RECODE Q70113 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb58.
RECODE Q70115 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb59.
RECODE Q70117 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb60.
RECODE Q70119 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb61.
RECODE Q70121 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb62.
RECODE Q70123 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb63.
RECODE Q70127 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb64.
RECODE Q70129 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb65.
RECODE Q70131 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb66.
RECODE Q70133 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb67.
RECODE Q70135 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb68.
RECODE Q70137 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb69.
RECODE Q70139 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb70.
RECODE Q70141 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb71.
RECODE Q70143 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb72.
RECODE Q70145 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb73.
RECODE Q70149 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb74.
RECODE Q70151 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb75.
RECODE Q70153 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb76.
RECODE Q70155 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb77.
RECODE Q70157 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb78.
RECODE Q70159 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb79.
RECODE Q70161 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb80.
RECODE Q70163 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb81.
RECODE Q70165 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb82.
RECODE Q70167 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb83.
RECODE Q70171 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb84.
RECODE Q70173 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb85.
RECODE Q70175 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb86.
RECODE Q70177 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb87.
RECODE Q70179 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb88.
RECODE Q70181 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb89.
RECODE Q70183 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb90.
RECODE Q70185 (70011=5) (70013=4) (70015=3) (70017=2) (70019=1) into cb91.
RECODE Q70187 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb92.
RECODE Q70189 (70011=1) (70013=2) (70015=3) (70017=4) (70019=5) into cb93.
RECODE Q70193 (70131=5) (70133=4) (70135=3) (70137=2) (70139=1) into cb94.
RECODE Q70195 (70141=5) (70143=4) (70145=3) (70147=2) (70149=1) into cb95.
RECODE Q70197 (70151=3) (70153=2) (70155=1) (70157=4) (70159=5) into cb96.
RECODE Q70199 (70161=1) (70163=5) (70165=1) (70167=1) into cb97.
RECODE Q70201 (70169=1) (70171=5) (70173=1) (70175=1) into cb98.
RECODE Q70203 (70177=5) (70179=4) (70181=3) (70183=2) (70185=1) into cb99.
RECODE Q70205 (70187=5) (70189=4) (70191=3) (70193=2) (70195=1) into cb100.
RECODE Q70207 (70197=2) (70199=4) (70201=1) (70203=5) into cb101.
RECODE Q70209 (70205=1) (70207=2) (70209=4) (70211=5) into cb102.
RECODE Q70211 (70213=1) (70215=2) (70217=3) (70219=4) (70221=5) into cb103.
RECODE Q70213 (70223=5) (70225=4) (70227=1) (70229=2) into cb104.
RECODE Q70215 (70231=1) (70233=3) (70235=4) (70237=5) (70239=2) into cb105.
RECODE Q70217 (70241=4) (70243=2) (70245=5) (70247=3) into cb106.
RECODE Q70219 (70249=5) (70251=3) (70253=2) (70255=1) into cb107.


******************************BEGIN TMCB 5.0 ITEM-LEVEL SCORING******************************.

recode rcb1 (1=0) (2=1) (3=0) (4=0) (5=sysmis) (else=sysmis) into cb1 .
recode rcb2 (1=0) (2=0) (3=0) (4=0) (5=1) (else=sysmis) into cb2 .
recode rcb3 (1=0) (2=0) (3=1) (4=0) (5=sysmis) (else=sysmis) into cb3 .
recode rcb4 (1=0) (2=1) (3=0) (4=0) (5=sysmis) (else=sysmis) into cb4 .
recode rcb5 (1=1) (2=0) (3=0) (4=0) (5=sysmis) (else=sysmis) into cb5 .
recode rcb6 (1=0) (2=1) (3=0) (4=0) (5=sysmis) (else=sysmis) into cb6 .
recode rcb7 (1=0) (2=1) (3=0) (4=0) (5=sysmis) (else=sysmis) into cb7 .
recode rcb8 (1=0) (2=0) (3=0) (4=1) (5=sysmis) (else=sysmis) into cb8 .
recode rcb9 (1=1) (2=0) (3=0) (4=0) (5=0) (else=sysmis) into cb9 .
recode rcb10 (1=0) (2=1) (3=0) (4=0) (5=sysmis) (else=sysmis) into cb10 .
recode rcb11 (1=1) (2=0) (3=0) (4=0) (5=0) (else=sysmis) into cb11 .
recode rcb12 (1=0) (2=1) (3=0) (4=0) (5=sysmis) (else=sysmis) into cb12 .
recode rcb13 (1=4) (2=3) (3=2) (4=1) (5=0) (else=sysmis) into cb13 .
recode rcb14 (1=4) (2=3) (3=2) (4=1) (5=0) (else=sysmis) into cb14 .
recode rcb15 (1=0) (2=1) (3=2) (4=3) (5=4) (else=sysmis) into cb15 .
recode rcb16 (1=2.4) (2=1.4) (3=0.4) (4=0.6) (5=1.6) (else=sysmis) into cb16 .
recode rcb17 (1=4) (2=3) (3=2) (4=1) (5=0) (else=sysmis) into cb17 .
recode rcb18 (1=2.4) (2=1.4) (3=0.4) (4=0.6) (5=1.6) (else=sysmis) into cb18 .
recode rcb19 (1=1) (2=0) (3=1) (4=2) (5=3) (else=sysmis) into cb19 .
recode rcb20 (1=3) (2=2) (3=1) (4=0) (5=1) (else=sysmis) into cb20 .
recode rcb21 (1=1) (2=0) (3=1) (4=2) (5=3) (else=sysmis) into cb21 .
recode rcb22 (1=3) (2=2) (3=1) (4=0) (5=1) (else=sysmis) into cb22 .
recode rcb23 (1=0.5) (2=0.5) (3=1.5) (4=2.5) (5=3.5) (else=sysmis) into cb23 .
recode rcb24 (1=4) (2=3) (3=2) (4=1) (5=0) (else=sysmis) into cb24 .
recode rcb25 (1=4) (2=3) (3=2) (4=1) (5=0) (else=sysmis) into cb25 .
recode rcb26 (1=0.5) (2=0.5) (3=1.5) (4=2.5) (5=3.5) (else=sysmis) into cb26 .
recode rcb27 (1=2.4) (2=1.4) (3=0.4) (4=0.6) (5=1.6) (else=sysmis) into cb27 .
recode rcb28 (1=3) (2=2) (3=1) (4=0) (5=1) (else=sysmis) into cb28 .
recode rcb29 (1=1.9) (2=0.9) (3=0.1) (4=1.1) (5=2.1) (else=sysmis) into cb29 .
recode rcb30 (1=1) (2=0) (3=1) (4=2) (5=3) (else=sysmis) into cb30 .
recode rcb31 (1=0) (2=1) (3=2) (4=3) (5=4) (else=sysmis) into cb31 .
recode rcb32 (1=1.6) (2=0.6) (3=0.4) (4=1.4) (5=2.4) (else=sysmis) into cb32 .
recode rcb33 (1=2.3) (2=1.3) (3=0.3) (4=0.7) (5=1.7) (else=sysmis) into cb33 .
recode rcb34 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb34 .
recode rcb35 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb35 .
recode rcb36 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb36 .
recode rcb37 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb37 .
recode rcb38 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb38 .
recode rcb39 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb39 .
recode rcb40 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb40 .
recode rcb41 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb41 .
recode rcb42 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb42 .
recode rcb43 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb43 .
recode rcb44 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb44 .
recode rcb45 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb45 .
recode rcb46 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb46 .
recode rcb47 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb47 .
recode rcb48 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb48 .
recode rcb49 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb49 .
recode rcb50 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb50 .
recode rcb51 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb51 .
recode rcb52 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb52 .
recode rcb53 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb53 .
recode rcb54 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb54 .
recode rcb55 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb55 .
recode rcb56 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb56 .
recode rcb57 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb57 .
recode rcb58 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb58 .
recode rcb59 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb59 .
recode rcb60 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb60 .
recode rcb61 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb61 .
recode rcb62 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb62 .
recode rcb63 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb63 .
recode rcb64 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb64 .
recode rcb65 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb65 .
recode rcb66 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb66 .
recode rcb67 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb67 .
recode rcb68 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb68 .
recode rcb69 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb69 .
recode rcb70 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb70 .
recode rcb71 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb71 .
recode rcb72 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb72 .
recode rcb73 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb73 .
recode rcb74 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb74 .
recode rcb75 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb75 .
recode rcb76 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb76 .
recode rcb77 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb77 .
recode rcb78 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb78 .
recode rcb79 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb79 .
recode rcb80 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb80 .
recode rcb81 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb81 .
recode rcb82 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb82 .
recode rcb83 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb83 .
recode rcb84 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb84 .
recode rcb85 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb85 .
recode rcb86 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb86 .
recode rcb87 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb87 .
recode rcb88 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb88 .
recode rcb89 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb89 .
recode rcb90 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb90 .
recode rcb91 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb91 .
recode rcb92 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb92 .
recode rcb93 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb93 .
recode rcb94 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb94 .
recode rcb95 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb95 .
recode rcb96 (1=3) (2=2) (3=1) (4=4) (5=5) (else=sysmis) into cb96 .
recode rcb97 (1=1) (2=5) (3=1) (4=1) (5=sysmis) (else=sysmis) into cb97 .
recode rcb98 (1=1) (2=5) (3=1) (4=1) (5=sysmis) (else=sysmis) into cb98 .
recode rcb99 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb99 .
recode rcb100 (1=5) (2=4) (3=3) (4=2) (5=1) (else=sysmis) into cb100 .
recode rcb101 (1=2) (2=4) (3=1) (4=5) (5=sysmis) (else=sysmis) into cb101 .
recode rcb102 (1=1) (2=2) (3=4) (4=5) (5=sysmis) (else=sysmis) into cb102 .
recode rcb103 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into cb103 .
recode rcb104 (1=5) (2=4) (3=1) (4=2) (5=sysmis) (else=sysmis) into cb104 .
recode rcb105 (1=1) (2=3) (3=4) (4=5) (5=2) (else=sysmis) into cb105 .
recode rcb106 (1=4) (2=2) (3=5) (4=3) (5=sysmis) (else=sysmis) into cb106 .
recode rcb107 (1=5) (2=3) (3=2) (4=1) (5=sysmis) (else=sysmis) into cb107 .
execute .


**********************************************************************************************************************************************************************************************************************************
****5.0 Scale Scoring - Not Standardized. (pre-recalibration, from: <file://Y:\Tests\Career Batteries\Career Battery Scoring - Templates\Templates - 7.X Portal\TMCB 5.0\TMCB 5.0 Scoring.sps> Scoring of safety 
awareness was changed to *-1)


count sit_mss = cb1, cb2, cb3, cb4, cb5, cb6, cb7, cb8,cb9, cb10, cb11, cb12 (sysmis) .
DO IF (sit_mss GE 0).
compute sji_sit = (sum(sum(cb1, cb2, cb3, cb4, cb5, cb6, cb7, cb8,cb9, cb10, cb11, cb12),(sit_mss * 0)) * 1) .
ELSE.
compute sji_sit = mean(cb1, cb2, cb3, cb4, cb5, cb6, cb7, cb8,cb9, cb10, cb11, cb12) * 1 * 12 .
END IF.

count absf_mss = cb13, cb14, cb15, cb16, cb17, cb18, cb19 (sysmis) .
DO IF (absf_mss GE 2).
compute ab_sf = (sum(sum(cb13, cb14, cb15, cb16, cb17, cb18, cb19),(absf_mss * 4)) * -1) .
ELSE.
compute ab_sf = mean(cb13, cb14, cb15, cb16, cb17, cb18, cb19) * -1 * 7 .
END IF.

count abqa_mss = cb20, cb21, cb22, cb23, cb24, cb25, cb26 (sysmis) .
DO IF (abqa_mss GE 2).
compute ab_qa = (sum(sum(cb20, cb21, cb22, cb23, cb24, cb25, cb26),(abqa_mss * 4)) * -1) .
ELSE.
compute ab_qa = mean(cb20, cb21, cb22, cb23, cb24, cb25, cb26) * -1 * 7 .
END IF.

count ab_coll_mss = cb27, cb28, cb29, cb30, cb31, cb32, cb33 (sysmis) .
DO IF (ab_coll_mss GE 2).
compute ab_coll = (sum(sum(cb27, cb28, cb29, cb30, cb31, cb32, cb33),(ab_coll_mss * 4)) * -1) .
ELSE.
compute ab_coll = mean(cb27, cb28, cb29, cb30, cb31, cb32, cb33) * -1 * 7 .
END IF.

count dad_mss = cb37, cb44, cb49, cb52, cb62, cb66, cb73, cb81,cb86, cb90 (sysmis) .
DO IF (dad_mss GE 3).
compute dsp_ad = (sum(sum(cb37, cb44, cb49, cb52, cb62, cb66, cb73, cb81,cb86, cb90),(dad_mss * 1)) * 1) .
ELSE.
compute dsp_ad = mean(cb37, cb44, cb49, cb52, cb62, cb66, cb73, cb81,cb86, cb90) * 1 * 10 .
END IF.

count djfs_mss = cb34, cb38, cb40, cb50, cb53, cb56, cb59, cb63,cb67, cb70, cb74, cb82, cb91 (sysmis) .
DO IF (djfs_mss GE 4).
compute dsp_jfs = (sum(sum(cb34, cb38, cb40, cb50, cb53, cb56, cb59, cb63,cb67, cb70, cb74, cb82, cb91),(djfs_mss * 1)) * 1) .
ELSE.
compute dsp_jfs = mean(cb34, cb38, cb40, cb50, cb53, cb56, cb59, cb63,cb67, cb70, cb74, cb82, cb91) * 1 * 13 .
END IF.

count dlc_mss = cb41, cb45, cb54, cb64, cb71, cb75, cb78, cb83, cb87, cb92 (sysmis) .
DO IF (dlc_mss GE 3).
compute dsp_lc = (sum(sum(cb41, cb45, cb54, cb64, cb71, cb75, cb78, cb83, cb87, cb92),(dlc_mss * 1)) * 1) .
ELSE.
compute dsp_lc = mean(cb41, cb45, cb54, cb64, cb71, cb75, cb78, cb83, cb87, cb92) * 1 * 10 .
END IF.

count dse_mss = cb35, cb39, cb42, cb46, cb57, cb60, cb68, cb76,cb79, cb88 (sysmis) .
DO IF (dse_mss GE 3).
compute dsp_se = (sum(sum(cb35, cb39, cb42, cb46, cb57, cb60, cb68, cb76,cb79, cb88),(dse_mss * 1)) * 1) .
ELSE.
compute dsp_se = mean(cb35, cb39, cb42, cb46, cb57, cb60, cb68, cb76,cb79, cb88) * 1 * 10 .
END IF.

count ddm_mss = cb47, cb51, cb55, cb58, cb69, cb77, cb84, cb93 (sysmis) .
DO IF (ddm_mss GE 3).
compute dsp_dm = (sum(sum(cb47, cb51, cb55, cb58, cb69, cb77, cb84, cb93),(ddm_mss * 1)) * 1) .
ELSE.
compute dsp_dm = mean(cb47, cb51, cb55, cb58, cb69, cb77, cb84, cb93) * 1 * 8 .
END IF.

count dwq_mss = cb36, cb43, cb48, cb61, cb65, cb72, cb80, cb85,cb89 (sysmis) .
DO IF (dwq_mss GE 3).
compute dsp_wq = (sum(sum(cb36, cb43, cb48, cb61, cb65, cb72, cb80, cb85,cb89),(dwq_mss * 1)) * 1) .
ELSE.
compute dsp_wq = mean(cb36, cb43, cb48, cb61, cb65, cb72, cb80, cb85,cb89) * 1 * 9 .
END IF.

count adpt_mss = cb94, cb96, cb99, cb101, cb103, cb105, cb107 (sysmis) .
DO IF (adpt_mss GE 2).
compute be_adpt = (sum(sum(cb94, cb96, cb99, cb101, cb103, cb105, cb107),(adpt_mss * 1)) * 1) .
ELSE.
compute be_adpt = mean(cb94, cb96, cb99, cb101, cb103, cb105, cb107) * 1 * 7 .
END IF.

count ws_mss = cb95, cb97, cb98, cb100, cb102, cb104, cb106 (sysmis) .
DO IF (ws_mss GE 2).
compute be_ws = (sum(sum(cb95, cb97, cb98, cb100, cb102, cb104, cb106),(ws_mss * 1)) * 1) .
ELSE.
compute be_ws = mean(cb95, cb97, cb98, cb100, cb102, cb104, cb106) * 1 * 7 .
END IF.
execute .


VARIABLE LABELS
sji_sit 'WRJ Situational Judgment' 
ab_sf 'WRJ AB Safety Awareness'
ab_qa 'WRJ AB Quality Orientation'
ab_coll 'WRJ AB Collaboration'
dsp_ad 'WSD Adaptability'
dsp_jfs 'WSD Job Fit Team Member'
dsp_lc 'WSD Locus of Control'
dsp_se 'WSD Self Efficacy'
dsp_dm 'WSD Decision Making Style' 
dsp_wq 'WSD Work Quality'
be_adpt 'BE Adaptability'
be_ws 'BE Work Standards'.
EXECUTE.

*Counting Items Missing for a Filter - Should be the Full Set of Items.  Do occular inspection of scale_mss variables*

COUNT items_missing 	= Q70001 to Q70219 (sysmis).			
EXECUTE. 


*deleting Items missing variables
delete variables 	 sit_mss absf_mss abqa_mss ab_coll_mss dad_mss djfs_mss dlc_mss dse_mss ddm_mss dwq_mss adpt_mss ws_mss.


***Recoding Predictor Outliers as SYSMIS.

*Cleaning Up Standardized Variables - This is Important to Keep You From Creating New Standardized Variables Rather than Replacing the Old.
*NOTE: The First Time, You Will Get an Error (b/c the Standardized Variables Have Not Yet Been Created).

DELETE VARIABLES 	Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws.


*Run This to Base the Standardized Variables on Cases Remaining After the _Predictor_ Filters.

USE ALL.
COMPUTE filter_$=(pred_filters = 0).
FILTER BY filter_$.
EXECUTE .


TITLE 'Halliburton TMCB Validation Analyses'.
SUBTITLE 'Predictor Scale Descriptives'.
DESCRIPTIVES VARIABLES=	sji_sit ab_sf ab_qa ab_coll dsp_ad dsp_jfs dsp_lc dsp_se dsp_dm dsp_wq be_adpt be_ws
   /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX .


/*This Counts The Outliers For Use in a Filter.
RECODE 	Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
                        (Lowest thru -3.29 = 1) (3.29 thru Highest = 1) (ELSE = 0)
	            INTO
	            out01 to out12.
COMPUTE count_outliers = sum(out01 to out12).
EXECUTE.


**Deleting outlier variables 
DELETE VARIABLES 	out01 to out12. 


*Recoding to Eliminate Univariate Outliers on All Predictor Scales.
RECODE  	Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
  	(Lowest thru -3.29=SYSMIS)  (3.29 thru Highest=SYSMIS).
EXECUTE .



/*Composite scores.

Numeric wrj_cmp dsp_cmp be_cmp (f8.2) .

COMPUTE wrj_cmp	= mean(Zsji_sit, Zab_sf, Zab_qa, Zab_coll).
COMPUTE dsp_cmp	= mean(Zdsp_ad, Zdsp_jfs, Zdsp_lc, Zdsp_se, Zdsp_dm, Zdsp_wq).
COMPUTE be_cmp	= mean(Zbe_adpt, Zbe_ws).
EXECUTE.	

DELETE VARIBLES Zwrj_cmp Zdsp_cmp Zbe_cmp.

*Standardizing Based on Cases Remaining After the _Predictor_ Filters.
USE ALL.
COMPUTE filter_$=(pred_filters = 0).
FILTER BY filter_$.
EXECUTE .

TITLE 'Halliburton TMCB 5.0 Validation Study - Predictor Composite Descriptives'.
DESCRIPTIVES
  VARIABLES= wrj_cmp dsp_cmp be_cmp 
  /SAVE
  /STATISTICS=MEAN STDDEV .
EXECUTE.		


*IMPORTANT - To Eliminate Univariate Outliers on All Predictor Composites.
RECODE  	Zwrj_cmp Zdsp_cmp Zbe_cmp
  		(Lowest thru -3.29=SYSMIS)  (3.29 thru Highest=SYSMIS).
EXECUTE .
	

COMPUTE cb_ovr	= mean(Zwrj_cmp, Zdsp_cmp, Zbe_cmp).
exe.

VARIABLE LABELS
	wrj_cmp		'Work-related Judgment Composite'
	dsp_cmp		'Work Style and Disposition Composite'
	be_cmp			'Background Experience Composite'
	cb_ovr			'TMCB 5.0 Overall'.
EXECUTE.

*Cleaning Up Standardized Variables.
DELETE VARIABLES Zcb_ovr .

*Standardizing Based on Cases Remaining After the _Predictor_ Filters.
USE ALL.
COMPUTE filter_$=(pred_filters = 0).
FILTER BY filter_$.
EXECUTE .

TITLE 'Halliburton TMCB 5.0 Validation Study - Overall Test Score Descriptives'.
DESCRIPTIVES
  VARIABLES=cb_ovr
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX .

*IMPORTANT - To Eliminate Univariate Outliers on the Overall Predictor Score.
RECODE  	Zcb_ovr
  		(Lowest thru -3.29=SYSMIS)  (3.29 thru Highest=SYSMIS).
EXECUTE .


FILTER OFF.
USE ALL.
EXECUTE .


****************************************************************BEGIN CRITERION CREATION**************************************************************

numeric adpt_avg al_avg comm_avg cts_avg dm_avg qo_avg sa_avg st_avg ws_avg (F8.2).

COMPUTE adpt_avg 		= mean (adapt1, adapt2, adapt3, adapt4, adapt_overall).
COMPUTE al_avg 		= mean (appLearn1, appLearn2, appLearn3, appLearn4, appLearn_overall).
COMPUTE comm_avg 		= mean (comm1, comm2, comm3, comm4, comm_overall).
COMPUTE cts_avg 		= mean (contTeamSuccss1, contTeamSuccss2, contTeamSuccss3, contTeamSuccss4, contTeamSuccss_overall).
COMPUTE dm_avg 		= mean (decMak1, decMak2, decMak3, decMak4, decMak5, decMak6, decMak7).
COMPUTE qo_avg 		= mean (qualOr1, qualOr2, qualOr3, qualOr4, qualOr_overall).
COMPUTE sa_avg 		= mean (safeAware1, safeAware2, safeAware3, safeAware4, safeAware5).
COMPUTE st_avg 		= mean (stressTol1, stressTol2, stressTol3, stressTol4, stressTol5).
COMPUTE ws_avg 		= mean (workStand1, workStand2, workStand3, workStand4, workStand5).
EXECUTE.

VARIABLE LABELS
	adpt_avg	'Adaptability'
	al_avg		'Applied learning'
	comm_avg	'Communication'
	cts_avg		'Contributing to team success'
	dm_avg		'Decision making'
	qo_avg		'Quality orientation'
	sa_avg		'Safety awareness'
	st_avg		'Stress tolerance'
	ws_avg		'Work standards'.
EXECUTE .
 

/*Rename bottomline variables

recode blq1 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into avoid_dis_actions_and_violation_company_policies .
recode blq2 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into compl_with_safety_guidelines.
recode blq3 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into avoid_misuse_of_time.
recode blq4 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into maintain_low_error_rates.
recode blq5 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into meet_productivity_goals.
recode blq6 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into speed_to_productivity.
recode blq7 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into overall_job_perf_compared_to_other_Operator_Assistants.
recode blq8 (1=1) (2=2) (3=3) (4=4) (5=5) (else=sysmis) into potential_overall_job_perf_in_the_future.

VARIABLE LABELS
	avoid_dis_actions_and_violation_company_policies	'avoiding formal disciplinary actions and other violations of company policies'
	compl_with_safety_guidelines				'compliance with safety guidelines'
	avoid_misuse_of_time					'ability to avoid misuse of time at work'
	maintain_low_error_rates 				'ability to maintain low rates of error'	
	meet_productivity_goals					'ability to meet productivity goals at work'
	speed_to_productivity					'speed to reach acceptable productivity levels'
	overall_job_perf_compared_to_other_Operator_Assistants 'OVERALL JOB PERFORMANCE compared to other Operator Assistants'
	potential_overall_job_perf_in_the_future			'potential to demonstrate effective OVERALL JOB PERFORMANCE in the future'.
EXECUTE .




DELETE VARIABLES 	Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
			Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates 
                                    Zmeet_productivity_goals Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future.


USE ALL.
COMPUTE filter_$=(crit_filters= 0).
FILTER BY filter_$.
EXECUTE .

SUBTITLE 'Criterion Competency Descriptives'.
DESCRIPTIVES
  VARIABLES= adpt_avg al_avg comm_avg cts_avg dm_avg qo_avg sa_avg st_avg ws_avg 
	           avoid_dis_actions_and_violation_company_policies compl_with_safety_guidelines avoid_misuse_of_time maintain_low_error_rates
                       meet_productivity_goals speed_to_productivity overall_job_perf_compared_to_other_Operator_Assistants potential_overall_job_perf_in_the_future
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX .
EXECUTE.

*To Eliminate Univariate Outliers.
RECODE
	Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
            Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates 
            Zmeet_productivity_goals Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
  	(Lowest thru -3.29=SYSMIS)  (3.29 thru Highest=SYSMIS).
EXECUTE.


numeric ovr_unit cando willdo interp (F8.2).

COMPUTE ovr_unit  	= mean (adpt_avg, al_avg, comm_avg, cts_avg, dm_avg, qo_avg, sa_avg, st_avg, ws_avg).
COMPUTE cando 	= mean (al_avg, dm_avg).
COMPUTE willdo 	= mean (adpt_avg,  qo_avg, sa_avg, st_avg, ws_avg).
COMPUTE interp 	= mean (comm_avg, cts_avg).
COMPUTE bottomline	= mean (avoid_dis_actions_and_violation_company_policies, compl_with_safety_guidelines, avoid_misuse_of_time, maintain_low_error_rates, meet_productivity_goals, speed_to_productivity,
                                                 overall_job_perf_compared_to_other_Operator_Assistants, potential_overall_job_perf_in_the_future).
EXECUTE.

VARIABLE LABELS
	ovr_unit 	'Overall Performance (Unweighted Average Across Dimension Ratings)'
	cando 		'Can Do Performance Composite'
	willdo 		'Will Do Performance Composite'
	interp 		'Interpersonal Performance Composite'
	bottomline	'Bottomline Performance Composite'.
EXECUTE.


DELETE VARIABLES 	Zovr_unit Zcando Zwilldo Zinterp Zbottomline.



SUBTITLE 'Criterion Competency Descriptives'.
DESCRIPTIVES
  VARIABLES= 	ovr_unit cando willdo interp bottomline
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX .
EXECUTE.


*To Eliminate Univariate Outliers.
RECODE 	Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  		(Lowest thru -3.29=SYSMIS)  (3.29 thru Highest=SYSMIS).
EXECUTE.

FILTER OFF.
USE ALL.
EXECUTE .



****************************************************************BEGIN FILTER CREATION**************************************************************.

***************Potential RATER ERROR criterion filters (using Evan's syntax)**************************

*****STEP 1******

***First, create a single variable averaging all of the individual dimensions, but WITHOUT overall performance ratings
***Second, create a variable as the variance of all dimension items (NOT including overall items)
***Insert these variable names in the right side of the computations below
***Also, insert the name of your Familiarity Variable and your Frequency of Contact Variable (if available)

COMPUTE alldims 		= mean (Zadpt_avg, Zal_avg, Zcomm_avg, Zcts_avg, Zdm_avg, Zqo_avg, Zsa_avg, Zst_avg, Zws_avg) .
COMPUTE pers_var 		= variance (adapt1, adapt2, adapt3, adapt4, appLearn1, appLearn2, appLearn3, appLearn4, comm1, comm2, comm3, comm4,
				   contTeamSuccss1, contTeamSuccss2, contTeamSuccss3, contTeamSuccss4, decMak1, decMak2, decMak3, decMak4, decMak5, decMak6,
                                                   decMak7, qualOr1, qualOr2, qualOr3, qualOr4, safeAware1, safeAware2, safeAware3, safeAware4, safeAware5, stressTol1, stressTol2, stressTol3, stressTol4,
                                                   stressTol5, workStand1, workStand2, workStand3, workStand4, workStand5) .
COMPUTE famil			= Frequency .
COMPUTE contact 		= Familiarity .
COMPUTE rater_accuracy	= Accuracy .
EXECUTE.

****STEP 2: RUN THE SYNTAX BELOW****
**************NOTE: IT WILL REPLACE THE WORKING FILE, SO SAVE BEFORE RUNNING THIS SECTION***************

*****Aggregating by Supervisor to Check Rater Quality--Start by Recoding Supervisor Name into a Numeric Code Variable
*****NOTE: This syntax deletes cases with blank supervisor names
*****To Aggregate by Rating Site, Replace "sup_id" with Location Code.by Rating Site, Replace "supid" with Location Code

AUTORECODE
  VARIABLES=mgr_ID /INTO sup_id
  /PRINT.


AGGREGATE OUTFILE=*
	/BREAK 								= sup_id 
	/COUNT 	'Number of Incumbents Rated'				= N 
	/avgfamil 	'Average Familiarity'					= mean(famil)
	/avgcont 	'Average Contact Frequency'				= mean(contact)
	/avgacc		'Average Accuracy'					= mean(rater_accuracy)
	/avgall 		'Mean Across Dims and Ratees'				= mean(alldims)
	/sdratee		'B/w Ratee Discriminability - SD Across Dims'		= sd(alldims)
	/varall		'Halo - Low Variance Within Ratee'			= mean(pers_var)
	/highall 		'Leniency - Pct of Ratees Above 4'			= pin(alldims,4.01,5)
	/lowall		'Severity - Pct of Ratees Below 2'			            = pin(alldims,1,1.99)
	/midall 		'Central Tendency - Pct of Ratees b/w 2.5 and 3.5'	= pin(alldims,2.5,3.5).
EXECUTE.

FILTER OFF.
USE ALL.
SELECT IF(sup_id > 1).
EXECUTE.


***Saves Standardized Values as Variables

DESCRIPTIVES
  VARIABLES=count avgfamil avgacc avgcont avgall sdratee varall highall lowall midall
   /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX .

***Sets Leniency, Severity, and Central Tendency Values as Missing for Those Rating Only 1 Person
***Otherwise, these concepts really make no sense...

DO IF (count = 1) .
RECODE
  highall lowall midall  (ELSE=SYSMIS)  .
END IF .
EXECUTE .

***Number of Incumbents Report.

SORT CASES BY
  count (D) .
summarize
  /tables=sup_id count zcount 
  /title='Supervisors by Number of Incumbents Rated'
  /format=validlist nocasenum total missing='.'
  /statistics=none.
execute.

***Average Familiarity Report.

SORT CASES BY
  avgfamil (A) .
summarize
  /tables=sup_id count avgfamil zavgfamil 
  /title='Supervisors by Average Familiarity Rating'
  /format=validlist nocasenum total missing='.'
  /statistics=none.
execute.

***Average Accuracy Report.

SORT CASES BY
  avgacc (A) .
summarize
  /tables=sup_id count avgacc zavgacc
  /title='Supervisors by Average Accuracy Rating'
  /format=validlist nocasenum total missing='.'
  /statistics=none.
execute.

***Average Contact Frequency Report--NOTE: CHECK CODING TO MAKE SURE THE ORDERING IS APPROPRIATE.

SORT CASES BY
  avgcont (A) .
summarize
  /tables=sup_id count avgcont zavgcont 
  /title='Supervisors by Average Contact Frequency Rating'
  /format=validlist nocasenum total missing='.'
  /statistics=none.
execute.

***SD Across Ratees Report.

SORT CASES BY
  sdratee   (A) .
summarize
  /tables=sup_id count sdratee zsdratee 
  /title='Supervisors by SD Across Ratees'
  /format=validlist nocasenum total missing='.'
  /statistics=none.
execute.

***Within Ratee Variance Report.

SORT CASES BY
  varall (A) .
summarize
  /tables=sup_id count varall zvarall 
  /title='Supervisors by Within Ratee Variance'
  /format=validlist nocasenum total missing='.'
  /statistics=none.
execute.

***Potenial Leniency Report.

SORT CASES BY
  highall  (D) .
summarize
  /tables=sup_id count highall zhighall
  /title='Supervisors by Percent Above 4 - Potential Leniency'
  /format=validlist nocasenum total missing='.'
  /statistics=none.
execute.

***Potenial Severity Report.

SORT CASES BY
  lowall  (D) .
summarize
  /tables=sup_id count lowall zlowall
  /title='Supervisors by Percent Below 2 - Potential Severity'
  /format=validlist nocasenum total missing='.'
  /statistics=none.
execute.

***Potenial Central Tendency Report.

SORT CASES BY
  midall  (D) .
summarize
  /tables=sup_id count midall zmidall
  /title='Supervisors by Percent b/w 2.5 and 3.5 - Potential Central Tendency'
  /format=validlist nocasenum total missing='.'
  /statistics=none.
execute.


******STEP 3: look for potential outliers (Z score above or below 3.29)

*************************
CRITERION FILTERS -- ('1' is filtered OUT of sample)
*************************


 FREQUENCIES
  VARIABLES=frequency familiarity accuracy
  /ORDER=  ANALYSIS .



RECODE Frequency	(1 = 1) (ELSE = 0) 	INTO low_freq_filter.
RECODE Familiarity	(1 = 1) (ELSE = 0) 	INTO low_famil_filter.
RECODE Accuracy	(1 = 1) (ELSE = 0) 	INTO low_accuracy_filter.
RECODE mgr_id	('hal016' = 1) (ELSE = 0)	INTO severity_error_filter.	
EXECUTE.

variable labels
	low_freq_filter			'Filtered if low Frequency'	
	low_famil_filter			'Filtered if low Familiarity'
	low_accuracy_filter		'Filtered if low Accuracy'
	severity_error_filter		'Filtered if manager severity Z score was > 3.29'.
exe.


COMPUTE crit_filters = sum(low_accuracy_filter, low_freq_filter, low_famil_filter) .
RECODE crit_filters (0=0) (ELSE = 1) .
EXECUTE .

***NOTE: manager ID "hal003" did not rate adaptability, applied learning, communication, or contributing to team success.

*************************
PREDICTOR FILTERS -- ('1' is filtered OUT of sample)
*************************

FREQUENCIES
  VARIABLES=items_missing count_outliers ir2 ir6 orgten jobten 
  /ORDER=  ANALYSIS .


RECODE items_missing  	(44 thru highest= 1)  (ELSE=0) 		INTO items_missing_filter .
RECODE count_outliers 	(2 thru Highest = 1) (ELSE = 0)		INTO outliers_filter.
exe.


***. 

RECODE orgten 	(Lowest thru 2 = 1) (ELSE = 0)		INTO orgten_filter.
RECODE jobten		(Lowest thru 3 = 1) (ELSE = 0)		INTO posten_filter.

COMPUTE pred_filters = sum(items_missing_filter, outliers_filter, orgten_filter).
RECODE pred_filters (0 = 0) (ELSE = 1). 
EXECUTE .


*************************
FINAL SAMPLE FILTER -- ('0' is filtered OUT of sample)
*************************

/*

delete variables val_samp val_samp_temp .

RECODE matched (1 = 0) (ELSE = 1) INTO matched_filter.
COMPUTE val_samp_temp = sum(pred_filters, crit_filters, matched_filter).
RECODE val_samp_temp (0 = 1) (ELSE = 0).
EXECUTE.

RENAME VARIABLES (val_samp_temp = val_samp).
EXECUTE.

variable labels
val_samp 'FINAL VALIDATION SAMPLE'.
exe.

value labels val_samp
0 'Filtered OUT of sample'
1 'Included in sample'.
exe.


***************************************************PRELIMINARY CORRELATIONS*************************************************************************.

TITLE 'frequency tables of various filter variables'.
FREQUENCIES
  VARIABLES=low_famil_filter low_freq_filter severity_error_filter low_accuracy_filter crit_filters items_missing_filter outliers_filter orgten_filter posten_filter pred_filters
                      matched_filter val_samp
  /STATISTICS=SKEWNESS SESKEW KURTOSIS SEKURT
  /ORDER=  ANALYSIS .


TITLE 'frequency tables of various filter variables'.
FREQUENCIES
  VARIABLES=low_famil_filter low_freq_filter low_accuracy_filter 
  /STATISTICS=SKEWNESS SESKEW KURTOSIS SEKURT
  /ORDER=  ANALYSIS .

TITLE 'histograpms of the predictor score distribution'.
FREQUENCIES
  VARIABLES=Zcb_ovr Zwrj_cmp Zdsp_cmp Zbe_cmp 
                      Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
  /HISTOGRAM
  /ORDER=  ANALYSIS .


TITLE 'histograpms of the criterion score distribution'.
FREQUENCIES
  VARIABLES=Zovr_unit Zcando Zwilldo Zinterp Zbottomline
                      Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
                      Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                      Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
                      Ze3_CABER Zint_stay 
 /HISTOGRAM
  /ORDER=  ANALYSIS .


USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= Zcb_ovr Zwrj_cmp Zdsp_cmp Zbe_cmp 
                        Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
                        Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
                        Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                        Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
                        Ze3_CABER Zint_stay
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .

/*After first pass go back to the beginning, recreate the standardized variables, then come back to this section.


*************************************************************************************************COMPOSITE MANIPULATIONS for final scoring********************************************************************.
***Factor level manipulations***.

/*look for negative Beta coefficients -- these scales may need to be removed.


TITLE 'Halliburton TMCB WRJ regression'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT Zovr_unit  
  /METHOD=ENTER Zsji_sit, Zab_sf, Zab_qa, Zab_coll.
FILTER OFF.
USE ALL.
EXECUTE .


TITLE 'Halliburton TMCB WSD regression'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT Zovr_unit  
  /METHOD=ENTER Zdsp_ad, Zdsp_jfs, Zdsp_lc, Zdsp_se, Zdsp_dm, Zdsp_wq.
FILTER OFF.
USE ALL.
EXECUTE .


TITLE 'Halliburton TMCB BE regression'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT  Zovr_unit
  /METHOD=ENTER Zbe_adpt, Zbe_ws.
FILTER OFF.
USE ALL.
EXECUTE .



************************************************CREATE NEW COMPOSITES**********************************************************.



COMPUTE wrj_cmp2	 	= mean(Zsji_sit, Zab_sf, Zab_qa, Zab_coll).

COMPUTE dsp_cmp2	 	= mean(Zdsp_ad, Zdsp_jfs, Zdsp_se). 	        /*no Zdsp_lc, Zdsp_dm, or Zdsp_wq.

COMPUTE be_cmp2	 	= mean(Zbe_adpt, Zbe_ws). 



VARIABLE LABELS
	wrj_cmp2		'WRJ composite -- no scales removed'
	dsp_cmp2		'WSD composite -- NO Zdsp_lc, Zdsp_dm, or Zdsp_wq'
	be_cmp2	 	'BE composite -- no scales removed'.
EXECUTE.


delete variables Zwrj_cmp2 Zdsp_cmp2 Zbe_cmp2.

USE ALL.
COMPUTE filter_$=(pred_filters = 0).
FILTER BY filter_$.
EXECUTE .
DESCRIPTIVES
  VARIABLES=wrj_cmp2 dsp_cmp2 be_cmp2 
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp2 Zdsp_cmp2 Zbe_cmp2 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary between all original compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp Zdsp_cmp Zbe_cmp 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .



***********************************************************************************Overall Factor Weighting*********************************************************************


TITLE 'Halliburton TMCB Validation Study'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT Zovr_unit
  /METHOD=ENTER Zwrj_cmp2 Zdsp_cmp2 Zbe_cmp2 .
EXECUTE .



compute TMCB_ovr2 = mean(2*Zwrj_cmp2, 1*Zdsp_cmp2, 1*Zbe_cmp2) .
compute TMCB_ovr3 = mean(2*Zwrj_cmp2, 2*Zdsp_cmp2, 1*Zbe_cmp2) .
compute TMCB_ovr4 = mean(3*Zwrj_cmp2, 2*Zdsp_cmp2, 1*Zbe_cmp2) .
compute TMCB_ovr5 = mean(3*Zwrj_cmp2, 2*Zdsp_cmp2, 2*Zbe_cmp2) .
compute TMCB_ovr6 = mean(3*Zwrj_cmp2, 3*Zdsp_cmp2, 2*Zbe_cmp2) .
compute TMCB_ovr7 = mean(2*Zwrj_cmp2, 1*Zdsp_cmp2, 2*Zbe_cmp2) .
compute TMCB_ovr8 = mean(3*Zwrj_cmp2, 1*Zdsp_cmp2, 2*Zbe_cmp2) .
compute TMCB_ovr9 = mean(2*Zwrj_cmp2, 3*Zdsp_cmp2, 1*Zbe_cmp2) .
compute TMCB_ovr10 = mean(2*Zwrj_cmp2, 3*Zdsp_cmp2, 3*Zbe_cmp2) .
compute TMCB_ovr11 = mean(2*Zwrj_cmp2, 2*Zdsp_cmp2, 3*Zbe_cmp2) .
compute TMCB_ovr12 = mean(3*Zwrj_cmp2, 2*Zdsp_cmp2, 3*Zbe_cmp2) .
compute TMCB_ovr13 = mean(3*Zwrj_cmp2, 1*Zdsp_cmp2, 3*Zbe_cmp2) .
compute TMCB_ovr14 = mean(2*Zwrj_cmp2, 1*Zdsp_cmp2, 3*Zbe_cmp2) .
compute TMCB_ovr15 = mean(3*Zwrj_cmp2, 1*Zdsp_cmp2, 3*Zbe_cmp2) .
compute TMCB_ovr16 = mean(1*Zwrj_cmp2, 1*Zdsp_cmp2, 3*Zbe_cmp2) .
EXECUTE.


variable labels
TMCB_ovr2 'TMCB 2 - 2,1,1'
TMCB_ovr3 'TMCB 3 - 2,2,1'
TMCB_ovr4 'TMCB 4 - 3,2,1'
TMCB_ovr5 'TMCB 5 - 3,2,2'
TMCB_ovr6 'TMCB 6 - 3,3,2'
TMCB_ovr7 'TMCB 7 - 2,1,2'
TMCB_ovr8 'TMCB 8 - 3,1,2'
TMCB_ovr9 'TMCB 9 - 2,3,1'
TMCB_ovr10 'TMCB 10 - 2,3,3'
TMCB_ovr11 'TMCB 11 - 2,2,3'
TMCB_ovr12 'TMCB 12 - 3,2,3'
TMCB_ovr13 'TMCB 13 - 3,1,3'
TMCB_ovr14 'TMCB 14 - 2,1,3'
TMCB_ovr15 'TMCB 15 - 3,1,3'
TMCB_ovr16 'TMCB 16 - 1,1,3'.
exe.


USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$.
EXECUTE .
SUBTITLE 'Overall Test Score Descriptives'. 
DESCRIPTIVES VARIABLES =TMCB_ovr2 TMCB_ovr3 TMCB_ovr4 TMCB_ovr5 TMCB_ovr6 TMCB_ovr7 TMCB_ovr8 TMCB_ovr9 TMCB_ovr10 TMCB_ovr11 TMCB_ovr12 TMCB_ovr13
TMCB_ovr14 TMCB_ovr15 TMCB_ovr16
/SAVE 
/STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


*****************************************************************Preliminary Correlations (with adjusted composites) & Overall Scatterplot********************************************************


TITLE 'preliminary correlations between potential test score composites and criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= Zcb_ovr ZTMCB_ovr2 ZTMCB_ovr3 ZTMCB_ovr4 ZTMCB_ovr5 ZTMCB_ovr6 ZTMCB_ovr7 ZTMCB_ovr8 ZTMCB_ovr9 ZTMCB_ovr10 ZTMCB_ovr11 ZTMCB_ovr12 ZTMCB_ovr13
                        ZTMCB_ovr14 ZTMCB_ovr15 ZTMCB_ovr16    
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .




TITLE 'scatterplots of overall test score with overall performance'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
GRAPH
  /SCATTERPLOT(BIVAR)=ZTMCB_ovr14 WITH Zovr_unit 
  /MISSING=LISTWISE .


*********************TMCB_ovr14 is the winner!!!!

variable labels
TMCB_ovr14 'TMCB 14 - 2,1,3 -- FINAL FULL TMCB' 
ZTMCB_ovr14 'Z score: TMCB 14 - 2,1,3 -- FINAL FULL TMCB' .
exe.

DELETE VARIABLES TMCB_ovr2 TMCB_ovr3 TMCB_ovr4 TMCB_ovr5 TMCB_ovr6 TMCB_ovr7 TMCB_ovr8 TMCB_ovr9 TMCB_ovr10 TMCB_ovr11 TMCB_ovr12 TMCB_ovr13
                                TMCB_ovr15 TMCB_ovr16 .


DELETE VARIABLES ZTMCB_ovr2 ZTMCB_ovr3 ZTMCB_ovr4 ZTMCB_ovr5 ZTMCB_ovr6 ZTMCB_ovr7 ZTMCB_ovr8 ZTMCB_ovr9 ZTMCB_ovr10 ZTMCB_ovr11 ZTMCB_ovr12 ZTMCB_ovr13
                                ZTMCB_ovr15 ZTMCB_ovr16 .


**********************************************************FULL CORRELATION TABLE*******************************************************************

TITLE 'FINAL correlations between all scales and criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr14 Zwrj_cmp2 Zdsp_cmp2 Zbe_cmp2 
                        Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
                        Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
                        Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                        Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
                        Ze3_CABER Zint_stay 
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


***Correlations for Test X Dimension Spreadsheet.

TITLE 'Correlations for Test X Dimension Spreadsheet - Part 1'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES=	Zovr_unit Zcando Zwilldo Zinterp Zbottomline
		Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
                     	WITH
		ZTMCB_ovr14 Zwrj_cmp2 Zdsp_cmp2 Zbe_cmp2 
		Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


TITLE 'Correlations for Test X Dimension Spreadsheet - Part 2'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES=	Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                        Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
                        Ze3_CABER Zint_stay 
		WITH
		ZTMCB_ovr14 Zwrj_cmp2 Zdsp_cmp2 Zbe_cmp2 
		Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .




******************************************************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************************************************
*******************************************************************************LOOKING FOR A TMCB 5.0 SHORT FORM*********************************************************************************************************************

****************************Full TMCB -- 9 scales scored*************************************
/* No WSD Locus of Control, WSD Decision Making Style, or WSD Work Quality.


TITLE 'FINAL correlations between all scales and all criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr14 Zwrj_cmp2 Zdsp_cmp2 Zbe_cmp2 
                        Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
                        Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
                        Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                        Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
                        Ze3_CABER Zint_stay 
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .



***********************************TMCB  --  8 scales scored**********************************************

***CREATE NEW COMPOSITES


COMPUTE wrj_cmp3	 	= mean(Zab_sf, Zab_qa, Zab_coll).	/*no Zsji_sit.

COMPUTE dsp_cmp3	 	= mean(Zdsp_ad, Zdsp_jfs, Zdsp_se). 	        /*no Zdsp_lc, Zdsp_dm, or Zdsp_wq.

COMPUTE be_cmp3	 	= mean(Zbe_adpt, Zbe_ws). 



VARIABLE LABELS
	wrj_cmp3		'WRJ composite -- NO Zsji_sit'
	dsp_cmp3		'WSD composite -- NO Zdsp_lc, Zdsp_dm, or Zdsp_wq'
	be_cmp3	 	'BE composite -- no scales removed'.
EXECUTE.


delete variables Zwrj_cmp3 Zdsp_cmp3 Zbe_cmp3.

USE ALL.
COMPUTE filter_$=(pred_filters = 0).
FILTER BY filter_$.
EXECUTE .
DESCRIPTIVES
  VARIABLES=wrj_cmp3 dsp_cmp3 be_cmp3 
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp3 Zdsp_cmp3 Zbe_cmp3 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .

/* for comparison
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp2 Zdsp_cmp2 Zbe_cmp2 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .




***Overall Factor Weighting

TITLE 'Halliburton TMCB Validation Study'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT Zovr_unit
  /METHOD=ENTER Zwrj_cmp3 Zdsp_cmp3 Zbe_cmp3 .
EXECUTE .



compute TMCB_ovr17 = mean(2*Zwrj_cmp3, 1*Zdsp_cmp3, 1*Zbe_cmp3) .
compute TMCB_ovr18 = mean(2*Zwrj_cmp3, 2*Zdsp_cmp3, 1*Zbe_cmp3) .
compute TMCB_ovr19 = mean(3*Zwrj_cmp3, 2*Zdsp_cmp3, 1*Zbe_cmp3) .
compute TMCB_ovr20 = mean(3*Zwrj_cmp3, 2*Zdsp_cmp3, 2*Zbe_cmp3) .
compute TMCB_ovr21 = mean(3*Zwrj_cmp3, 3*Zdsp_cmp3, 2*Zbe_cmp3) .
compute TMCB_ovr22 = mean(2*Zwrj_cmp3, 1*Zdsp_cmp3, 2*Zbe_cmp3) .
compute TMCB_ovr23 = mean(3*Zwrj_cmp3, 1*Zdsp_cmp3, 2*Zbe_cmp3) .
compute TMCB_ovr24 = mean(2*Zwrj_cmp3, 3*Zdsp_cmp3, 1*Zbe_cmp3) .
compute TMCB_ovr25 = mean(2*Zwrj_cmp3, 3*Zdsp_cmp3, 3*Zbe_cmp3) .
compute TMCB_ovr26 = mean(2*Zwrj_cmp3, 2*Zdsp_cmp3, 3*Zbe_cmp3) .
compute TMCB_ovr27 = mean(3*Zwrj_cmp3, 2*Zdsp_cmp3, 3*Zbe_cmp3) .
compute TMCB_ovr28 = mean(3*Zwrj_cmp3, 1*Zdsp_cmp3, 3*Zbe_cmp3) .
compute TMCB_ovr29 = mean(2*Zwrj_cmp3, 1*Zdsp_cmp3, 3*Zbe_cmp3) .
compute TMCB_ovr30 = mean(3*Zwrj_cmp3, 1*Zdsp_cmp3, 3*Zbe_cmp3) .
compute TMCB_ovr31 = mean(1*Zwrj_cmp3, 1*Zdsp_cmp3, 3*Zbe_cmp3) .
EXECUTE.


variable labels
TMCB_ovr17 'TMCB 17 - 2,1,1'
TMCB_ovr18 'TMCB 18 - 2,2,1'
TMCB_ovr19 'TMCB 19 - 3,2,1'
TMCB_ovr20 'TMCB 20 - 3,2,2'
TMCB_ovr21 'TMCB 21 - 3,3,2'
TMCB_ovr22 'TMCB 22 - 2,1,2'
TMCB_ovr23 'TMCB 23 - 3,1,2'
TMCB_ovr24 'TMCB 24 - 2,3,1'
TMCB_ovr25 'TMCB 25 - 2,3,3'
TMCB_ovr26 'TMCB 26 - 2,2,3'
TMCB_ovr27 'TMCB 27 - 3,2,3'
TMCB_ovr28 'TMCB 28 - 3,1,3'
TMCB_ovr29 'TMCB 29 - 2,1,3'
TMCB_ovr30 'TMCB 30 - 3,1,3'
TMCB_ovr31 'TMCB 31 - 1,1,3'.
exe.


USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$.
EXECUTE .
SUBTITLE 'Overall Test Score Descriptives'. 
DESCRIPTIVES VARIABLES =TMCB_ovr17 TMCB_ovr18 TMCB_ovr19 TMCB_ovr20 TMCB_ovr21 TMCB_ovr22 TMCB_ovr23 TMCB_ovr24 TMCB_ovr25 TMCB_ovr26 TMCB_ovr27 TMCB_ovr28
                                             TMCB_ovr29 TMCB_ovr30 TMCB_ovr31
/SAVE 
/STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


***Preliminary Correlations (with adjusted composites) & Overall Scatterplot


TITLE 'preliminary correlations between potential test score composites and criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr17 ZTMCB_ovr18 ZTMCB_ovr19 ZTMCB_ovr20 ZTMCB_ovr21 ZTMCB_ovr22 ZTMCB_ovr23 ZTMCB_ovr24 ZTMCB_ovr25 ZTMCB_ovr26 ZTMCB_ovr27 ZTMCB_ovr28
                        ZTMCB_ovr29 ZTMCB_ovr30 ZTMCB_ovr31
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .



TITLE 'scatterplots of overall test score with overall performance'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
GRAPH
  /SCATTERPLOT(BIVAR)=ZTMCB_ovr29 WITH Zovr_unit 
  /MISSING=LISTWISE .


***TMCB_ovr29 is the winner!!!!

variable labels
TMCB_ovr29 'TMCB 29 - 2,1,3 -- FINAL -- 8 scales' 
ZTMCB_ovr29 'Z score: TMCB 29 - 2,1,3 -- FINAL -- 8 scales' .
exe.


DELETE VARIABLES TMCB_ovr17 TMCB_ovr18 TMCB_ovr19 TMCB_ovr20 TMCB_ovr21 TMCB_ovr22 TMCB_ovr23 TMCB_ovr24 TMCB_ovr25 TMCB_ovr26 TMCB_ovr27 TMCB_ovr28
                                TMCB_ovr30 TMCB_ovr31.

DELETE VARIABLES ZTMCB_ovr17 ZTMCB_ovr18 ZTMCB_ovr19 ZTMCB_ovr20 ZTMCB_ovr21 ZTMCB_ovr22 ZTMCB_ovr23 ZTMCB_ovr24 ZTMCB_ovr25 ZTMCB_ovr26 ZTMCB_ovr27 ZTMCB_ovr28
                                ZTMCB_ovr30 ZTMCB_ovr31.

.

***final correlation matrix between all scales and all criteria

/* No WSD Locus of Control, WSD Decision Making Style, WSD Work Quality, or WRJ Situational Judgment.

TITLE 'FINAL correlations between all scales and all criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr29 Zwrj_cmp3 Zdsp_cmp3 Zbe_cmp3 
                        Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
                        Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
                        Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                        Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
                        Ze3_CABER Zint_stay 
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


***********************************TMCB  --  7 scales scored**********************************************


***CREATE NEW COMPOSITES


COMPUTE wrj_cmp4	 	= mean(Zab_sf, Zab_qa, Zab_coll).	/*no Zsji_sit.

COMPUTE dsp_cmp4	 	= mean(Zdsp_ad, Zdsp_se). 	        /*no Zdsp_lc, Zdsp_dm, Zdsp_wq, or Zdsp_jfs.

COMPUTE be_cmp4	 	= mean(Zbe_adpt, Zbe_ws). 



VARIABLE LABELS
	wrj_cmp4		'WRJ composite -- NO Zsji_sit'
	dsp_cmp4		'WSD composite -- NO Zdsp_lc, Zdsp_dm, Zdsp_wq or Zdsp_jfs'
	be_cmp4	 	'BE composite -- no scales removed'.
EXECUTE.


delete variables Zwrj_cmp4 Zdsp_cmp4 Zbe_cmp4.

USE ALL.
COMPUTE filter_$=(pred_filters = 0).
FILTER BY filter_$.
EXECUTE .
DESCRIPTIVES
  VARIABLES=wrj_cmp4 dsp_cmp4 be_cmp4 
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp4 Zdsp_cmp4 Zbe_cmp4 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .

/*for comparison
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp3 Zdsp_cmp3 Zbe_cmp3 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .

/*for comparison
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp2 Zdsp_cmp2 Zbe_cmp2 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .



***Overall Factor Weighting

TITLE 'Halliburton TMCB Validation Study'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT Zovr_unit
  /METHOD=ENTER Zwrj_cmp4 Zdsp_cmp4 Zbe_cmp4 .
EXECUTE .



compute TMCB_ovr17 = mean(2*Zwrj_cmp4, 1*Zdsp_cmp4, 1*Zbe_cmp4) .
compute TMCB_ovr18 = mean(2*Zwrj_cmp4, 2*Zdsp_cmp4, 1*Zbe_cmp4) .
compute TMCB_ovr19 = mean(3*Zwrj_cmp4, 2*Zdsp_cmp4, 1*Zbe_cmp4) .
compute TMCB_ovr20 = mean(3*Zwrj_cmp4, 2*Zdsp_cmp4, 2*Zbe_cmp4) .
compute TMCB_ovr21 = mean(3*Zwrj_cmp4, 3*Zdsp_cmp4, 2*Zbe_cmp4) .
compute TMCB_ovr22 = mean(2*Zwrj_cmp4, 1*Zdsp_cmp4, 2*Zbe_cmp4) .
compute TMCB_ovr23 = mean(3*Zwrj_cmp4, 1*Zdsp_cmp4, 2*Zbe_cmp4) .
compute TMCB_ovr24 = mean(2*Zwrj_cmp4, 3*Zdsp_cmp4, 1*Zbe_cmp4) .
compute TMCB_ovr25 = mean(2*Zwrj_cmp4, 3*Zdsp_cmp4, 3*Zbe_cmp4) .
compute TMCB_ovr26 = mean(2*Zwrj_cmp4, 2*Zdsp_cmp4, 3*Zbe_cmp4) .
compute TMCB_ovr27 = mean(3*Zwrj_cmp4, 2*Zdsp_cmp4, 3*Zbe_cmp4) .
compute TMCB_ovr28 = mean(3*Zwrj_cmp4, 1*Zdsp_cmp4, 3*Zbe_cmp4) .
compute TMCB_ovr32 = mean(2*Zwrj_cmp4, 1*Zdsp_cmp4, 3*Zbe_cmp4) .
compute TMCB_ovr30 = mean(3*Zwrj_cmp4, 1*Zdsp_cmp4, 3*Zbe_cmp4) .
compute TMCB_ovr31 = mean(1*Zwrj_cmp4, 1*Zdsp_cmp4, 3*Zbe_cmp4) .
EXECUTE.


variable labels
TMCB_ovr17 'TMCB 17 - 2,1,1'
TMCB_ovr18 'TMCB 18 - 2,2,1'
TMCB_ovr19 'TMCB 19 - 3,2,1'
TMCB_ovr20 'TMCB 20 - 3,2,2'
TMCB_ovr21 'TMCB 21 - 3,3,2'
TMCB_ovr22 'TMCB 22 - 2,1,2'
TMCB_ovr23 'TMCB 23 - 3,1,2'
TMCB_ovr24 'TMCB 24 - 2,3,1'
TMCB_ovr25 'TMCB 25 - 2,3,3'
TMCB_ovr26 'TMCB 26 - 2,2,3'
TMCB_ovr27 'TMCB 27 - 3,2,3'
TMCB_ovr28 'TMCB 28 - 3,1,3'
TMCB_ovr32 'TMCB 32 - 2,1,3'
TMCB_ovr30 'TMCB 30 - 3,1,3'
TMCB_ovr31 'TMCB 31 - 1,1,3'.
exe.


USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$.
EXECUTE .
SUBTITLE 'Overall Test Score Descriptives'. 
DESCRIPTIVES VARIABLES =TMCB_ovr17 TMCB_ovr18 TMCB_ovr19 TMCB_ovr20 TMCB_ovr21 TMCB_ovr22 TMCB_ovr23 TMCB_ovr24 TMCB_ovr25 TMCB_ovr26 TMCB_ovr27 TMCB_ovr28
                                             TMCB_ovr32 TMCB_ovr30 TMCB_ovr31
/SAVE 
/STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


***Preliminary Correlations (with adjusted composites) & Overall Scatterplot


TITLE 'preliminary correlations between potential test score composites and criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr17 ZTMCB_ovr18 ZTMCB_ovr19 ZTMCB_ovr20 ZTMCB_ovr21 ZTMCB_ovr22 ZTMCB_ovr23 ZTMCB_ovr24 ZTMCB_ovr25 ZTMCB_ovr26 ZTMCB_ovr27 ZTMCB_ovr28
                        ZTMCB_ovr32 ZTMCB_ovr30 ZTMCB_ovr31
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .



TITLE 'scatterplots of overall test score with overall performance'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
GRAPH
  /SCATTERPLOT(BIVAR)=ZTMCB_ovr32 WITH Zovr_unit 
  /MISSING=LISTWISE .


***TMCB_ovr32 is the winner!!!!

variable labels
TMCB_ovr32 'TMCB 32 - 2,1,3 -- FINAL -- 7 scales' 
ZTMCB_ovr32 'Z score: TMCB 32 - 2,1,3 -- FINAL -- 7 scales' .
exe.


DELETE VARIABLES TMCB_ovr17 TMCB_ovr18 TMCB_ovr19 TMCB_ovr20 TMCB_ovr21 TMCB_ovr22 TMCB_ovr23 TMCB_ovr24 TMCB_ovr25 TMCB_ovr26 TMCB_ovr27 TMCB_ovr28
                                TMCB_ovr30 TMCB_ovr31.

DELETE VARIABLES ZTMCB_ovr17 ZTMCB_ovr18 ZTMCB_ovr19 ZTMCB_ovr20 ZTMCB_ovr21 ZTMCB_ovr22 ZTMCB_ovr23 ZTMCB_ovr24 ZTMCB_ovr25 ZTMCB_ovr26 ZTMCB_ovr27 ZTMCB_ovr28
                                ZTMCB_ovr30 ZTMCB_ovr31.

.

***final correlation matrix between all scales and all criteria

/* No WSD Locus of Control, WSD Decision Making Style, WSD Work Quality, WRJ Situational Judgment, or WSD Job Fit Team Member.

TITLE 'FINAL correlations between all scales and all criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr32 Zwrj_cmp4 Zdsp_cmp4 Zbe_cmp4 
                        Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
                        Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
                        Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                        Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
                        Ze3_CABER Zint_stay 
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


***********************************TMCB  --  6 scales scored**********************************************

**************************************************************
**************************************************************
****************POTENTIAL WINNER!!!!!!*****************
Include WSD Adaptability and WSD Job Fit Team Member as unscored components to build out the personality item set
**************************************************************
**************************************************************



***CREATE NEW COMPOSITES


COMPUTE wrj_cmp5	 	= mean(Zab_sf, Zab_qa, Zab_coll).	/*no Zsji_sit.

COMPUTE dsp_cmp5	 	= mean(Zdsp_se). 	        /*no Zdsp_lc, Zdsp_dm, Zdsp_wq, Zdsp_jfs, or Zdsp_ad.

COMPUTE be_cmp5	 	= mean(Zbe_adpt, Zbe_ws). 



VARIABLE LABELS
	wrj_cmp5		'WRJ composite -- NO Zsji_sit'
	dsp_cmp5		'WSD composite -- NO Zdsp_lc, Zdsp_dm, Zdsp_wq, Zdsp_jfs or Zdsp_ad'
	be_cmp5	 	'BE composite -- no scales removed'.
EXECUTE.


delete variables Zwrj_cmp5 Zdsp_cmp5 Zbe_cmp5.

USE ALL.
COMPUTE filter_$=(pred_filters = 0).
FILTER BY filter_$.
EXECUTE .
DESCRIPTIVES
  VARIABLES=wrj_cmp5 dsp_cmp5 be_cmp5 
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp5 Zdsp_cmp5 Zbe_cmp5 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .

/*for comparison
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp4 Zdsp_cmp4 Zbe_cmp4 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


/*for comparison
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp3 Zdsp_cmp3 Zbe_cmp3 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .

/*for comparison
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp2 Zdsp_cmp2 Zbe_cmp2 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .



***Overall Factor Weighting

TITLE 'Halliburton TMCB Validation Study'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT Zovr_unit
  /METHOD=ENTER Zwrj_cmp5 Zdsp_cmp5 Zbe_cmp5 .
EXECUTE .




compute TMCB_ovr33 = mean(2*Zwrj_cmp5, 1*Zdsp_cmp5, 3*Zbe_cmp5) .
compute TMCB_ovr42 = mean(1*Zwrj_cmp5, 3*Zdsp_cmp5, 1*Zbe_cmp5) .
compute TMCB_ovr43 = mean(2*Zwrj_cmp5, 3*Zdsp_cmp5, 2*Zbe_cmp5) .
compute TMCB_ovr44 = mean(1*Zwrj_cmp5, 2*Zdsp_cmp5, 1*Zbe_cmp5) .
compute TMCB_ovr45 = mean(1*Zwrj_cmp5, 1*Zdsp_cmp5, 1*Zbe_cmp5) .
EXECUTE.


variable labels
TMCB_ovr33 'TMCB 33 - 2,1,3'
TMCB_ovr42 'TMCB 42 - 1,3,1'
TMCB_ovr43 'TMCB 43 - 2,3,2'
TMCB_ovr44 'TMCB 44 - 1,2,1'
TMCB_ovr45 'TMCB 45 - 1,1,1'.
exe.



USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$.
EXECUTE .
SUBTITLE 'Overall Test Score Descriptives'. 
DESCRIPTIVES VARIABLES = TMCB_ovr33 TMCB_ovr42 TMCB_ovr43 TMCB_ovr44 TMCB_ovr45
/SAVE 
/STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .



variable labels
TMCB_ovr33 'TMCB 33 - 2,1,3 -- FINAL -- 6 scales' 
ZTMCB_ovr33 'Z score: TMCB 33 - 2,1,3 -- FINAL -- 6 scales' .
TMCB_ovr42 'TMCB 42 - 1,3,1 -- FINAL -- 6 scales' 
ZTMCB_ovr42 'Z score: TMCB 42 - 1,3,1 -- FINAL -- 6 scales' .
exe.



***final correlation matrix between all scales and all criteria

/* No WSD Locus of Control, WSD Decision Making Style, WSD Work Quality, WRJ Situational Judgment, WSD Job Fit Team Member, or WSD Adaptability.

TITLE 'FINAL correlations between all scales and all criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr33 ZTMCB_ovr42 ZTMCB_ovr43 ZTMCB_ovr44 ZTMCB_ovr45 Zwrj_cmp5 Zdsp_cmp5 Zbe_cmp5 
                        Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
                        Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
                        Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                        Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
                        Ze3_CABER Zint_stay 
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


***********************************TMCB  --  5 scales scored**********************************************


***CREATE NEW COMPOSITES

/* you will get an error message here because there are no variables to compute dsp_cmp6.

COMPUTE wrj_cmp6	 	= mean(Zab_sf, Zab_qa, Zab_coll).	/*no Zsji_sit.

COMPUTE dsp_cmp6	 	= mean(). 	        /*no Zdsp_lc, Zdsp_dm, Zdsp_wq, Zdsp_jfs, Zdsp_ad, or Zdsp_se.

COMPUTE be_cmp6	 	= mean(Zbe_adpt, Zbe_ws). 



VARIABLE LABELS
	wrj_cmp6		'WRJ composite -- NO Zsji_sit'
	dsp_cmp6		'WSD composite -- NO Zdsp_lc, Zdsp_dm, Zdsp_wq, Zdsp_jfs, Zdsp_ad, or Zdsp_se '
	be_cmp6	 	'BE composite -- no scales removed'.
EXECUTE.


delete variables Zwrj_cmp6 Zbe_cmp6.

USE ALL.
COMPUTE filter_$=(pred_filters = 0).
FILTER BY filter_$.
EXECUTE .
DESCRIPTIVES
  VARIABLES=wrj_cmp6 be_cmp6 
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp6 Zbe_cmp6 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .

/*for comparison
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp5 Zdsp_cmp5 Zbe_cmp5 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


/*for comparison
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp4 Zdsp_cmp4 Zbe_cmp4 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


/*for comparison
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp3 Zdsp_cmp3 Zbe_cmp3 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .

/*for comparison
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp2 Zdsp_cmp2 Zbe_cmp2 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .



***Overall Factor Weighting

TITLE 'Halliburton TMCB Validation Study'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT Zovr_unit
  /METHOD=ENTER Zwrj_cmp6 Zbe_cmp6 .
EXECUTE .


compute TMCB_ovr17 = mean(1*Zwrj_cmp6, 1*Zbe_cmp6) .
compute TMCB_ovr18 = mean(2*Zwrj_cmp6, 1*Zbe_cmp6) .
compute TMCB_ovr19 = mean(2*Zwrj_cmp6, 2*Zbe_cmp6) .
compute TMCB_ovr34 = mean(2*Zwrj_cmp6, 3*Zbe_cmp6) .
compute TMCB_ovr20 = mean(3*Zwrj_cmp6, 1*Zbe_cmp6) .
compute TMCB_ovr21 = mean(3*Zwrj_cmp6, 2*Zbe_cmp6) .
compute TMCB_ovr22 = mean(3*Zwrj_cmp6, 3*Zbe_cmp6) .
EXECUTE.


variable labels
TMCB_ovr17 'TMCB 17 - 1,1'
TMCB_ovr18 'TMCB 18 - 2,1'
TMCB_ovr19 'TMCB 19 - 2,2'
TMCB_ovr34 'TMCB 34 - 2,3'
TMCB_ovr20 'TMCB 20 - 3,1'
TMCB_ovr21 'TMCB 21 - 3,2'
TMCB_ovr22 'TMCB 22 - 3,3'.
exe.


USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$.
EXECUTE .
SUBTITLE 'Overall Test Score Descriptives'. 
DESCRIPTIVES VARIABLES =TMCB_ovr17 TMCB_ovr18 TMCB_ovr19 TMCB_ovr34 TMCB_ovr20 TMCB_ovr21 TMCB_ovr22
/SAVE 
/STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


***Preliminary Correlations (with adjusted composites) & Overall Scatterplot


TITLE 'preliminary correlations between potential test score composites and criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr17 ZTMCB_ovr18 ZTMCB_ovr19 ZTMCB_ovr34 ZTMCB_ovr20 ZTMCB_ovr21 ZTMCB_ovr22
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .



TITLE 'scatterplots of overall test score with overall performance'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
GRAPH
  /SCATTERPLOT(BIVAR)=ZTMCB_ovr34 WITH Zovr_unit 
  /MISSING=LISTWISE .


***TMCB_ovr34 is the winner!!!!

variable labels
TMCB_ovr34 'TMCB 34 - 2,3 -- FINAL -- 5 scales' 
ZTMCB_ovr34 'Z score: TMCB 34 - 2,3 -- FINAL -- 5 scales' .
exe.


DELETE VARIABLES TMCB_ovr17 TMCB_ovr18 TMCB_ovr19 TMCB_ovr20 TMCB_ovr21 TMCB_ovr22.

DELETE VARIABLES ZTMCB_ovr17 ZTMCB_ovr18 ZTMCB_ovr19 ZTMCB_ovr20 ZTMCB_ovr21 ZTMCB_ovr22.

.

***final correlation matrix between all scales and all criteria

/* No WSD Locus of Control, WSD Decision Making Style, WSD Work Quality, WRJ Situational Judgment, WSD Job Fit Team Member, WSD Adaptability, or WSD Self Efficacy.

TITLE 'FINAL correlations between all scales and all criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr34 Zwrj_cmp6 Zbe_cmp6 
                        Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
                        Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
                        Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                        Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
                        Ze3_CABER Zint_stay 
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


***********************************TMCB  --  4 scales scored**********************************************


***CREATE NEW COMPOSITES

/* you will get an error message here because there are no variables to compute dsp_cmp7.

COMPUTE wrj_cmp7	 	= mean(Zab_sf, Zab_qa).	/*no Zsji_sit or Zab_coll.

COMPUTE dsp_cmp7	 	= mean(). 	        /*no Zdsp_lc, Zdsp_dm, Zdsp_wq, Zdsp_jfs, Zdsp_ad, or Zdsp_se.

COMPUTE be_cmp7	 	= mean(Zbe_adpt, Zbe_ws). 



VARIABLE LABELS
	wrj_cmp7		'WRJ composite -- NO Zsji_sit or Zab_coll'
	dsp_cmp7		'WSD composite -- NO Zdsp_lc, Zdsp_dm, Zdsp_wq, Zdsp_jfs, Zdsp_ad, or Zdsp_se '
	be_cmp7	 	'BE composite -- no scales removed'.
EXECUTE.


delete variables Zwrj_cmp7 Zbe_cmp7.

USE ALL.
COMPUTE filter_$=(pred_filters = 0).
FILTER BY filter_$.
EXECUTE .
DESCRIPTIVES
  VARIABLES=wrj_cmp7 be_cmp7 
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp7 Zbe_cmp7 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .

/*for comparison
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp6 Zbe_cmp6 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


/*for comparison
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp5 Zdsp_cmp5 Zbe_cmp5 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


/*for comparison
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp4 Zdsp_cmp4 Zbe_cmp4 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


/*for comparison
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp3 Zdsp_cmp3 Zbe_cmp3 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .

/*for comparison
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp2 Zdsp_cmp2 Zbe_cmp2 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .



***Overall Factor Weighting

TITLE 'Halliburton TMCB Validation Study'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT Zovr_unit
  /METHOD=ENTER Zwrj_cmp7 Zbe_cmp7 .
EXECUTE .


compute TMCB_ovr17 = mean(1*Zwrj_cmp7, 1*Zbe_cmp7) .
compute TMCB_ovr18 = mean(2*Zwrj_cmp7, 1*Zbe_cmp7) .
compute TMCB_ovr19 = mean(2*Zwrj_cmp7, 2*Zbe_cmp7) .
compute TMCB_ovr35 = mean(2*Zwrj_cmp7, 3*Zbe_cmp7) .
compute TMCB_ovr20 = mean(3*Zwrj_cmp7, 1*Zbe_cmp7) .
compute TMCB_ovr21 = mean(3*Zwrj_cmp7, 2*Zbe_cmp7) .
compute TMCB_ovr22 = mean(3*Zwrj_cmp7, 3*Zbe_cmp7) .
EXECUTE.


variable labels
TMCB_ovr17 'TMCB 17 - 1,1'
TMCB_ovr18 'TMCB 18 - 2,1'
TMCB_ovr19 'TMCB 19 - 2,2'
TMCB_ovr35 'TMCB 35 - 2,3'
TMCB_ovr20 'TMCB 20 - 3,1'
TMCB_ovr21 'TMCB 21 - 3,2'
TMCB_ovr22 'TMCB 22 - 3,3'.
exe.


USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$.
EXECUTE .
SUBTITLE 'Overall Test Score Descriptives'. 
DESCRIPTIVES VARIABLES =TMCB_ovr17 TMCB_ovr18 TMCB_ovr19 TMCB_ovr35 TMCB_ovr20 TMCB_ovr21 TMCB_ovr22
/SAVE 
/STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


***Preliminary Correlations (with adjusted composites) & Overall Scatterplot


TITLE 'preliminary correlations between potential test score composites and criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr17 ZTMCB_ovr18 ZTMCB_ovr19 ZTMCB_ovr35 ZTMCB_ovr20 ZTMCB_ovr21 ZTMCB_ovr22
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .



TITLE 'scatterplots of overall test score with overall performance'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
GRAPH
  /SCATTERPLOT(BIVAR)=ZTMCB_ovr35 WITH Zovr_unit 
  /MISSING=LISTWISE .


***TMCB_ovr35 is the winner!!!!

variable labels
TMCB_ovr35 'TMCB 35 - 2,3 -- FINAL -- 4 scales' 
ZTMCB_ovr35 'Z score: TMCB 35 - 2,3 -- FINAL -- 4 scales' .
exe.


DELETE VARIABLES TMCB_ovr17 TMCB_ovr18 TMCB_ovr19 TMCB_ovr20 TMCB_ovr21 TMCB_ovr22.

DELETE VARIABLES ZTMCB_ovr17 ZTMCB_ovr18 ZTMCB_ovr19 ZTMCB_ovr20 ZTMCB_ovr21 ZTMCB_ovr22.

.

***final correlation matrix between all scales and all criteria

/* No WSD Locus of Control, WSD Decision Making Style, WSD Work Quality, WRJ Situational Judgment, WSD Job Fit Team Member, WSD Adaptability, WSD Self Efficacy, or WRJ AB Collaboration.

TITLE 'FINAL correlations between all scales and all criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr35 Zwrj_cmp7 Zbe_cmp7 
                        Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
                        Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
                        Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                        Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
                        Ze3_CABER Zint_stay 
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .



***********************************TMCB  --  7 scales scored - option 2**********************************************

***CREATE NEW COMPOSITES


COMPUTE wrj_cmp8	 	= mean(Zab_sf, Zab_qa).	/*no Zsji_sit or Zab_coll.

COMPUTE dsp_cmp8	 	= mean(Zdsp_ad, Zdsp_jfs, Zdsp_se). 	        /*no Zdsp_lc, Zdsp_dm, or Zdsp_wq.

COMPUTE be_cmp8	 	= mean(Zbe_adpt, Zbe_ws). 



VARIABLE LABELS
	wrj_cmp8		'WRJ composite -- NO Zsji_sit or Zab_coll'
	dsp_cmp8		'WSD composite -- NO Zdsp_lc, Zdsp_dm, or Zdsp_wq'
	be_cmp8	 	'BE composite -- no scales removed'.
EXECUTE.


delete variables Zwrj_cmp8 Zdsp_cmp8 Zbe_cmp8.

USE ALL.
COMPUTE filter_$=(pred_filters = 0).
FILTER BY filter_$.
EXECUTE .
DESCRIPTIVES
  VARIABLES=wrj_cmp8 dsp_cmp8 be_cmp8 
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp8 Zdsp_cmp8 Zbe_cmp8 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


***Overall Factor Weighting

TITLE 'Halliburton TMCB Validation Study'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT Zovr_unit
  /METHOD=ENTER Zwrj_cmp8 Zdsp_cmp8 Zbe_cmp8 .
EXECUTE .



compute TMCB_ovr17 = mean(2*Zwrj_cmp8, 1*Zdsp_cmp8, 1*Zbe_cmp8) .
compute TMCB_ovr18 = mean(2*Zwrj_cmp8, 2*Zdsp_cmp8, 1*Zbe_cmp8) .
compute TMCB_ovr19 = mean(3*Zwrj_cmp8, 2*Zdsp_cmp8, 1*Zbe_cmp8) .
compute TMCB_ovr20 = mean(3*Zwrj_cmp8, 2*Zdsp_cmp8, 2*Zbe_cmp8) .
compute TMCB_ovr21 = mean(3*Zwrj_cmp8, 3*Zdsp_cmp8, 2*Zbe_cmp8) .
compute TMCB_ovr22 = mean(2*Zwrj_cmp8, 1*Zdsp_cmp8, 2*Zbe_cmp8) .
compute TMCB_ovr23 = mean(3*Zwrj_cmp8, 1*Zdsp_cmp8, 2*Zbe_cmp8) .
compute TMCB_ovr24 = mean(2*Zwrj_cmp8, 3*Zdsp_cmp8, 1*Zbe_cmp8) .
compute TMCB_ovr25 = mean(2*Zwrj_cmp8, 3*Zdsp_cmp8, 3*Zbe_cmp8) .
compute TMCB_ovr26 = mean(2*Zwrj_cmp8, 2*Zdsp_cmp8, 3*Zbe_cmp8) .
compute TMCB_ovr27 = mean(3*Zwrj_cmp8, 2*Zdsp_cmp8, 3*Zbe_cmp8) .
compute TMCB_ovr28 = mean(3*Zwrj_cmp8, 1*Zdsp_cmp8, 3*Zbe_cmp8) .
compute TMCB_ovr36 = mean(2*Zwrj_cmp8, 1*Zdsp_cmp8, 3*Zbe_cmp8) .
compute TMCB_ovr30 = mean(3*Zwrj_cmp8, 1*Zdsp_cmp8, 3*Zbe_cmp8) .
compute TMCB_ovr31 = mean(1*Zwrj_cmp8, 1*Zdsp_cmp8, 3*Zbe_cmp8) .
EXECUTE.


variable labels
TMCB_ovr17 'TMCB 17 - 2,1,1'
TMCB_ovr18 'TMCB 18 - 2,2,1'
TMCB_ovr19 'TMCB 19 - 3,2,1'
TMCB_ovr20 'TMCB 20 - 3,2,2'
TMCB_ovr21 'TMCB 21 - 3,3,2'
TMCB_ovr22 'TMCB 22 - 2,1,2'
TMCB_ovr23 'TMCB 23 - 3,1,2'
TMCB_ovr24 'TMCB 24 - 2,3,1'
TMCB_ovr25 'TMCB 25 - 2,3,3'
TMCB_ovr26 'TMCB 26 - 2,2,3'
TMCB_ovr27 'TMCB 27 - 3,2,3'
TMCB_ovr28 'TMCB 28 - 3,1,3'
TMCB_ovr36 'TMCB 36 - 2,1,3'
TMCB_ovr30 'TMCB 30 - 3,1,3'
TMCB_ovr31 'TMCB 31 - 1,1,3'.
exe.


USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$.
EXECUTE .
SUBTITLE 'Overall Test Score Descriptives'. 
DESCRIPTIVES VARIABLES =TMCB_ovr17 TMCB_ovr18 TMCB_ovr19 TMCB_ovr20 TMCB_ovr21 TMCB_ovr22 TMCB_ovr23 TMCB_ovr24 TMCB_ovr25 TMCB_ovr26 TMCB_ovr27 TMCB_ovr28
                                             TMCB_ovr36 TMCB_ovr30 TMCB_ovr31
/SAVE 
/STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


***Preliminary Correlations (with adjusted composites) & Overall Scatterplot


TITLE 'preliminary correlations between potential test score composites and criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr17 ZTMCB_ovr18 ZTMCB_ovr19 ZTMCB_ovr20 ZTMCB_ovr21 ZTMCB_ovr22 ZTMCB_ovr23 ZTMCB_ovr24 ZTMCB_ovr25 ZTMCB_ovr26 ZTMCB_ovr27 ZTMCB_ovr28
                        ZTMCB_ovr36 ZTMCB_ovr30 ZTMCB_ovr31
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .



TITLE 'scatterplots of overall test score with overall performance'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
GRAPH
  /SCATTERPLOT(BIVAR)=ZTMCB_ovr36 WITH Zovr_unit 
  /MISSING=LISTWISE .


***TMCB_ovr36 is the winner!!!!

variable labels
TMCB_ovr36 'TMCB 36 - 2,1,3 -- FINAL -- 7 scales' 
ZTMCB_ovr36 'Z score: TMCB 36 - 2,1,3 -- FINAL -- 7 scales' .
exe.


DELETE VARIABLES TMCB_ovr17 TMCB_ovr18 TMCB_ovr19 TMCB_ovr20 TMCB_ovr21 TMCB_ovr22 TMCB_ovr23 TMCB_ovr24 TMCB_ovr25 TMCB_ovr26 TMCB_ovr27 TMCB_ovr28
                                TMCB_ovr30 TMCB_ovr31.

DELETE VARIABLES ZTMCB_ovr17 ZTMCB_ovr18 ZTMCB_ovr19 ZTMCB_ovr20 ZTMCB_ovr21 ZTMCB_ovr22 ZTMCB_ovr23 ZTMCB_ovr24 ZTMCB_ovr25 ZTMCB_ovr26 ZTMCB_ovr27 ZTMCB_ovr28
                                ZTMCB_ovr30 ZTMCB_ovr31.

.

***final correlation matrix between all scales and all criteria

/* No WSD Locus of Control, WSD Decision Making Style, WSD Work Quality, WRJ Situational Judgment, or WRJ Collaboration.

TITLE 'FINAL correlations between all scales and all criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr36 Zwrj_cmp8 Zdsp_cmp8 Zbe_cmp8 
                        Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
                        Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
                        Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                        Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
                        Ze3_CABER Zint_stay 
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


************************************************************************************************ROUND 2 AFTER SEEING AI RESULTS************************************************************************************

***********************************TMCB  --  8 scales scored - different weighting**********************************************



compute TMCB_ovr37 = mean(2*Zwrj_cmp3, 3*Zdsp_cmp3, 2*Zbe_cmp3) .
EXECUTE.



USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$.
EXECUTE .
SUBTITLE 'Overall Test Score Descriptives'. 
DESCRIPTIVES VARIABLES =TMCB_ovr37 
/SAVE 
/STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


***Preliminary Correlations (with adjusted composites) & Overall Scatterplot


TITLE 'preliminary correlations between potential test score composites and criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr37 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .



variable labels
TMCB_ovr37 'TMCB 37 - 2,3,2 -- FINAL -- 8 scales -- After AI' 
ZTMCB_ovr37 'Z score: TMCB 37 - 2,3,2 -- FINAL -- 8 scales -- After AI' .
exe.



***final correlation matrix between all scales and all criteria

/* No WSD Locus of Control, WSD Decision Making Style, WSD Work Quality, or WRJ Situational Judgment.

TITLE 'FINAL correlations between all scales and all criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr37 Zwrj_cmp3 Zdsp_cmp3 Zbe_cmp3 
                        Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
                        Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
                        Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                        Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
                        Ze3_CABER Zint_stay 
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .



***********************************TMCB  --  9 scales scored - different weighting + add work quality in**********************************************



***CREATE NEW COMPOSITES


COMPUTE wrj_cmp9	 	= mean(Zab_sf, Zab_qa, Zab_coll).	/*no Zsji_sit.

COMPUTE dsp_cmp9	 	= mean(Zdsp_ad, Zdsp_jfs, Zdsp_se, Zdsp_wq). 	        /*no Zdsp_lc, Zdsp_dm.

COMPUTE be_cmp9	 	= mean(Zbe_adpt, Zbe_ws). 



VARIABLE LABELS
	wrj_cmp9		'WRJ composite -- NO Zsji_sit'
	dsp_cmp9		'WSD composite -- NO Zdsp_lc, Zdsp_dm'
	be_cmp9	 	'BE composite -- no scales removed'.
EXECUTE.


delete variables Zwrj_cmp9 Zdsp_cmp9 Zbe_cmp9.

USE ALL.
COMPUTE filter_$=(pred_filters = 0).
FILTER BY filter_$.
EXECUTE .
DESCRIPTIVES
  VARIABLES=wrj_cmp9 dsp_cmp9 be_cmp9 
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .




compute TMCB_ovr38 = mean(1*Zwrj_cmp3, 3*Zdsp_cmp3, 1*Zbe_cmp3) .
EXECUTE.



USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$.
EXECUTE .
SUBTITLE 'Overall Test Score Descriptives'. 
DESCRIPTIVES VARIABLES =TMCB_ovr38
/SAVE 
/STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


***Preliminary Correlations (with adjusted composites) & Overall Scatterplot


TITLE 'preliminary correlations between potential test score composites and criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr38
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .




variable labels
TMCB_ovr38 'TMCB 38 - 1,3,1 -- FINAL -- 9 scales -- After AI' 
ZTMCB_ovr38 'Z score: TMCB 38 - 1,3,1 -- FINAL -- 9 scales -- After AI' .
exe.


.

***final correlation matrix between all scales and all criteria

/* No WSD Locus of Control, WSD Decision Making Style or WRJ Situational Judgment.

TITLE 'FINAL correlations between all scales and all criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr38 Zwrj_cmp9 Zdsp_cmp9 Zbe_cmp9
                        Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
                        Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
                        Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                        Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
                        Ze3_CABER Zint_stay 
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


***********************************TMCB  --  6 scales scored - different weighting/different scales**********************************************



***CREATE NEW COMPOSITES


COMPUTE wrj_cmp10	 	= mean(Zab_sf, Zab_coll).	/*no Zsji_sit or Zab_qa.

COMPUTE dsp_cmp10	 	= mean(Zdsp_ad, Zdsp_se, Zdsp_wq). 	        /*no Zdsp_lc, Zdsp_dm, or Zdsp_jfs.

COMPUTE be_cmp10	 	= mean(Zbe_adpt).	/*no Zbe_ws.



VARIABLE LABELS
	wrj_cmp10		'WRJ composite -- NO Zsji_sit or Zab_qa'
	dsp_cmp10		'WSD composite -- NO Zdsp_lc, Zdsp_dm, or Zdsp_jfs'
	be_cmp10	 	'BE composite -- NO Zbe_ws'.
EXECUTE.


delete variables Zwrj_cmp10 Zdsp_cmp10 Zbe_cmp10.

USE ALL.
COMPUTE filter_$=(pred_filters = 0).
FILTER BY filter_$.
EXECUTE .
DESCRIPTIVES
  VARIABLES=wrj_cmp10 dsp_cmp10 be_cmp10 
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .




compute TMCB_ovr39 = mean(1*Zwrj_cmp3, 3*Zdsp_cmp3, 1*Zbe_cmp3) .
compute TMCB_ovr40 = mean(2*Zwrj_cmp3, 3*Zdsp_cmp3, 2*Zbe_cmp3) .
EXECUTE.



USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$.
EXECUTE .
SUBTITLE 'Overall Test Score Descriptives'. 
DESCRIPTIVES VARIABLES =TMCB_ovr39 TMCB_ovr40
/SAVE 
/STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


***Preliminary Correlations (with adjusted composites) & Overall Scatterplot


TITLE 'preliminary correlations between potential test score composites and criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr39 ZTMCB_ovr40
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .




variable labels
TMCB_ovr39 'TMCB 39 - 1,3,1 -- FINAL -- 6 scales -- After AI' 
ZTMCB_ovr39 'Z score: TMCB 39 - 1,3,1 -- FINAL -- 6 scales -- After AI' 
TMCB_ovr40 'TMCB 40 - 1,3,1 -- FINAL -- 6 scales -- After AI' 
ZTMCB_ovr40 'Z score: TMCB 40 - 2,3,2 -- FINAL -- 6 scales -- After AI' .
exe.


.

***final correlation matrix between all scales and all criteria


TITLE 'FINAL correlations between all scales and all criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr39 ZTMCB_ovr40 Zwrj_cmp10 Zdsp_cmp10 Zbe_cmp10
                        Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
                        Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
                        Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                        Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
                        Ze3_CABER Zint_stay 
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


***********************************TMCB  --  5 scales scored - different weighting/different scales**********************************************



***CREATE NEW COMPOSITES


COMPUTE wrj_cmp11	 	= mean(Zab_sf, Zab_coll).	/*no Zsji_sit or Zab_qa.

COMPUTE dsp_cmp11	 	= mean(Zdsp_se, Zdsp_wq). 	        /*no Zdsp_lc, Zdsp_dm, Zdsp_jfs, or Zdsp_ad, .

COMPUTE be_cmp11	 	= mean(Zbe_adpt).	/*no Zbe_ws.



VARIABLE LABELS
	wrj_cmp11		'WRJ composite -- NO Zsji_sit or Zab_qa'
	dsp_cmp11		'WSD composite -- NO Zdsp_lc, Zdsp_dm, Zdsp_jfs, or Zdsp_ad, '
	be_cmp11	 	'BE composite -- NO Zbe_ws'.
EXECUTE.


delete variables Zwrj_cmp11 Zdsp_cmp11 Zbe_cmp11.

USE ALL.
COMPUTE filter_$=(pred_filters = 0).
FILTER BY filter_$.
EXECUTE .
DESCRIPTIVES
  VARIABLES=wrj_cmp11 dsp_cmp11 be_cmp11 
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .




compute TMCB_ovr41 = mean(1*Zwrj_cmp3, 3*Zdsp_cmp3, 1*Zbe_cmp3) .
EXECUTE.



USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$.
EXECUTE .
SUBTITLE 'Overall Test Score Descriptives'. 
DESCRIPTIVES VARIABLES =TMCB_ovr41
/SAVE 
/STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


***Preliminary Correlations (with adjusted composites) & Overall Scatterplot


TITLE 'preliminary correlations between potential test score composites and criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr41
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .




variable labels
TMCB_ovr41 'TMCB 41 - 1,3,1 -- FINAL -- 5 scales -- After AI' 
ZTMCB_ovr41 'Z score: TMCB 41 - 1,3,1 -- FINAL -- 5 scales -- After AI'.
exe.


.

***final correlation matrix between all scales and all criteria


TITLE 'FINAL correlations between all scales and all criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr41 Zwrj_cmp11 Zdsp_cmp11 Zbe_cmp11
                        Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
                        Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
                        Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                        Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
                        Ze3_CABER Zint_stay 
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .




******************************************************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************************************************
******************************************************************************************************************************************************************************************************************************************************
*******************************************************************************TMCB SHORT FORM (TMCB 5.3) INFORMATION/RESUTS****************************************************************************************************************
NOTE: 
ZTMCB_ovr14 = Overall score for the Full TMCB (composites = Zwrj_cmp2, Zdsp_cmp2, Zbe_cmp2) (weighting = 2,1,3)
ZTMCB_ovr44 = Overall score for Halliburton's shortform of the TMCB (composites = Zwrj_cmp5, Zdsp_cmp5, Zbe_cmp5) (weighting = 1,2,1)

***********************************TMCB  --  6 scales scored**********************************************


****************WINNER!!!!!!*********************
**Include WSD Adaptability and WSD Job Fit Team Member as unscored components of the  to build out the personality item set**
**************************************************************

***CREATE NEW COMPOSITES


COMPUTE wrj_cmp5	 	= mean(Zab_sf, Zab_qa, Zab_coll).	/*no Zsji_sit.

COMPUTE dsp_cmp5	 	= mean(Zdsp_se). 	        /*no Zdsp_lc, Zdsp_dm, Zdsp_wq, Zdsp_jfs, or Zdsp_ad.

COMPUTE be_cmp5	 	= mean(Zbe_adpt, Zbe_ws). 



VARIABLE LABELS
	wrj_cmp5		'WRJ composite -- NO Zsji_sit'
	dsp_cmp5		'WSD composite -- NO Zdsp_lc, Zdsp_dm, Zdsp_wq, Zdsp_jfs or Zdsp_ad'
	be_cmp5	 	'BE composite -- no scales removed'.
EXECUTE.


delete variables Zwrj_cmp5 Zdsp_cmp5 Zbe_cmp5.

USE ALL.
COMPUTE filter_$=(pred_filters = 0).
FILTER BY filter_$.
EXECUTE .
DESCRIPTIVES
  VARIABLES=wrj_cmp5 dsp_cmp5 be_cmp5 
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
TITLE 'preliminary correlations between all adjusted compostites and criteria'.
CORRELATIONS
  /VARIABLES= Zwrj_cmp5 Zdsp_cmp5 Zbe_cmp5 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .





***Overall Factor Weighting

TITLE 'Halliburton TMCB Validation Study'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT Zovr_unit
  /METHOD=ENTER Zwrj_cmp5 Zdsp_cmp5 Zbe_cmp5 .
EXECUTE .




*compute TMCB_ovr33 = mean(2*Zwrj_cmp5, 1*Zdsp_cmp5, 3*Zbe_cmp5) .
*compute TMCB_ovr42 = mean(1*Zwrj_cmp5, 3*Zdsp_cmp5, 1*Zbe_cmp5) .
*compute TMCB_ovr43 = mean(2*Zwrj_cmp5, 3*Zdsp_cmp5, 2*Zbe_cmp5) .
compute TMCB_ovr44 = mean(1*Zwrj_cmp5, 2*Zdsp_cmp5, 1*Zbe_cmp5) .
*compute TMCB_ovr45 = mean(1*Zwrj_cmp5, 1*Zdsp_cmp5, 1*Zbe_cmp5) .
EXECUTE.


variable labels
*TMCB_ovr33 'TMCB 33 - 2,1,3'
*TMCB_ovr42 'TMCB 42 - 1,3,1'
*TMCB_ovr43 'TMCB 43 - 2,3,2'
TMCB_ovr44 'TMCB 44 - 1,2,1'
*TMCB_ovr45 'TMCB 45 - 1,1,1'.
exe.



USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$.
EXECUTE .
SUBTITLE 'Overall Test Score Descriptives'. 
DESCRIPTIVES VARIABLES = TMCB_ovr33 TMCB_ovr42 TMCB_ovr43 TMCB_ovr44 TMCB_ovr45
/SAVE 
/STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .


variable labels
TMCB_ovr44 'TMCB 44 - 1,2,1 -- FINAL HALLIBURTON TMCB SHORT FORM' 
ZTMCB_ovr44 'Z score: TMCB 44 - 1,2,1 -- FINAL HALLIBURTON TMCB SHORT FORM' .
exe.



***final correlation matrix between all scales and all criteria

/* No WSD Locus of Control, WSD Decision Making Style, WSD Work Quality, WRJ Situational Judgment, WSD Job Fit Team Member, or WSD Adaptability.

TITLE 'FINAL correlations between all scales and all criteria'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr44 Zwrj_cmp5 Zdsp_cmp5 Zbe_cmp5 
                        Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
                        Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
                        Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                        Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
                        Ze3_CABER Zint_stay 
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .






*******************************************************************EXPECTANCY CHARTS/ODDS RATIOS********************************************************.

DELETE VARIABLES 	 NZTMCB_o NTI001 NZovr_un NZcando NZwilldo NZinterp NZbottom NZadpt_a NZal_avg NZcomm_a NZcts_av NZdm_avg NZqo_avg NZsa_avg
                                     NZst_avg NZws_avg NZavoid_ NZcompl_ NTI002 NZmainta NZmeet_p NZspeed_ NZoveral NZpotent NZe3_CAB NZint_st.
EXECUTE.


USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
RANK VARIABLES=	ZTMCB_ovr44
			(A) /NTILES (4) /PRINT=NO /TIES=MEAN .

USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
RANK VARIABLES=	Zovr_unit Zcando Zwilldo Zinterp Zbottomline
                                    Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
                                    Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                                    Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
                                    Ze3_CABER Zint_stay 
                                    (A) /NTILES (2) /PRINT=NO /TIES=MEAN .

RECODE NZTMCB_o (1 = 1) (2 thru 3 = 2) (4 = 3) INTO NZcb_ovr_3Cats.
EXECUTE. 


TITLE 'Halliburton TMCB - Crosstabs'.
CROSSTABS
/TABLES=
NZcb_ovr_3Cats
BY  
NZovr_un NZcando NZwilldo NZinterp NZbottom NZadpt_a NZal_avg NZcomm_a NZcts_av NZdm_avg NZqo_avg NZsa_avg
NZst_avg NZws_avg NZavoid_ NZcompl_ NTI002 NZmainta NZmeet_p NZspeed_ NZoveral NZpotent NZe3_CAB NZint_st
/FORMAT= AVALUE TABLES
/CELLS= COUNT ROW .   


FILTER OFF.
USE ALL.
EXECUTE .


*******************************************************************************************Information for PPT presentation*******************************************************************************************.

TITLE 'Halliburton TMCB Validation Study -- demographics'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
FREQUENCIES
  VARIABLES=gender race Over40 age
  /STATISTICS=STDDEV MEAN
  /ORDER=  ANALYSIS .
DESCRIPTIVES
  VARIABLES=age
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .

DESCRIPTIVES
  VARIABLES=age
  /STATISTICS=MEAN STDDEV MIN MAX .



TITLE 'Halliburton TMCB Validation Study -- outcome variables'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr44   
  WITH 
  Zovr_unit Zcando Zwilldo Zinterp Zbottomline 
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .

TITLE 'Halliburton TMCB Validation Study -- outcome variables'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr44   
  WITH 
  Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


TITLE 'Halliburton TMCB Validation Study -- bottomline variables'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr44   
  WITH 
  Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
  Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


TITLE 'Halliburton TMCB Validation Study -- engagement variables'.
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr44    
  WITH 
  Ze3_CABER Zint_stay
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .



*******************************************************************************************Information for Halliburton Report*******************************************************************************************.


title 'Table'
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
FREQUENCIES
  VARIABLES=gender race 
  /ORDER=  ANALYSIS .
FILTER OFF.
USE ALL.
EXECUTE .

title 'Table'
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
DESCRIPTIVES
  VARIABLES=orgten jobten age
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .

title 'Table'
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
DESCRIPTIVES
  VARIABLES= TMCB_ovr44 wrj_cmp5 dsp_cmp5 be_cmp5 
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .

title 'Table' 
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
DESCRIPTIVES
  VARIABLES= ovr_unit cando willdo interp bottomline
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .

title 'Table' 
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
DESCRIPTIVES
  VARIABLES= adpt_avg al_avg comm_avg cts_avg dm_avg qo_avg sa_avg st_avg ws_avg
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .

title 'Table' 
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
DESCRIPTIVES
  VARIABLES= avoid_dis_actions_and_violation_company_policies compl_with_safety_guidelines avoid_misuse_of_time maintain_low_error_rates meet_productivity_goals
                        speed_to_productivity overall_job_perf_compared_to_other_Operator_Assistants potential_overall_job_perf_in_the_future
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .

title 'Table' 
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
DESCRIPTIVES
  VARIABLES= e3_CABER int_stay
  /STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .
  
title 'Table' 
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES=ZTMCB_ovr44 Zwrj_cmp5 Zdsp_cmp5 Zbe_cmp5 
                        WITH 
                        Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .

title 'Predictor Composites and Bottom-line Criteria' 
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES=ZTMCB_ovr44 Zwrj_cmp5 Zdsp_cmp5 Zbe_cmp5 
                       WITH  
                       Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                       Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .

title 'Predictor composites and Attitudinal Criteria' 
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES=ZTMCB_ovr44 Zwrj_cmp5 Zdsp_cmp5 Zbe_cmp5 
                       WITH  
                       Ze3_CABER Zint_stay
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .

Title 'Appendix  - location detail' 
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
FREQUENCIES
  VARIABLES=txt_location
  /ORDER=  ANALYSIS .
FILTER OFF.
USE ALL.
EXECUTE .

Title 'Appendix  - Scoring detail' 
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
DESCRIPTIVES
  VARIABLES= sji_sit ab_sf ab_qa ab_coll dsp_ad dsp_jfs dsp_lc dsp_se dsp_dm dsp_wq be_adpt be_ws
/STATISTICS=MEAN STDDEV MIN MAX .
FILTER OFF.
USE ALL.
EXECUTE .

title 'Mega correlation table -- Criterion composites' 
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr44 Zwrj_cmp5 Zdsp_cmp5 Zbe_cmp5 
		Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
                       	WITH  
		 Zovr_unit Zcando Zwilldo Zinterp Zbottomline
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


title 'Mega correlation table -- Bottom-line'
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr44 Zwrj_cmp5 Zdsp_cmp5 Zbe_cmp5 
		Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
		WITH  
		Zavoid_dis_actions_and_violation_company_policies Zcompl_with_safety_guidelines Zavoid_misuse_of_time Zmaintain_low_error_rates Zmeet_productivity_goals
                       Zspeed_to_productivity Zoverall_job_perf_compared_to_other_Operator_Assistants Zpotential_overall_job_perf_in_the_future
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .


title 'Mega correlation table -- Attitudinal criteria'
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr44 Zwrj_cmp5 Zdsp_cmp5 Zbe_cmp5 
		Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
		WITH  
		Ze3_CABER Zint_stay
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .

title 'Mega correlation table -- Criterion dimensions'
USE ALL.
COMPUTE filter_$=val_samp.
FILTER BY filter_$ .
EXECUTE .
CORRELATIONS
  /VARIABLES= ZTMCB_ovr44 Zwrj_cmp5 Zdsp_cmp5 Zbe_cmp5 
		Zsji_sit Zab_sf Zab_qa Zab_coll Zdsp_ad Zdsp_jfs Zdsp_lc Zdsp_se Zdsp_dm Zdsp_wq Zbe_adpt Zbe_ws
		WITH  
		Zadpt_avg Zal_avg Zcomm_avg Zcts_avg Zdm_avg Zqo_avg Zsa_avg Zst_avg Zws_avg
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE .
FILTER OFF.
USE ALL.
EXECUTE .




