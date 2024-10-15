$onText
CEE 5410 - Water Resources Systems Analysis
Chapter 7, Problem #1 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)

THE PROBLEM:
A farmer plans to develop water for irrigation. He is considering 2 possible sources of water: a gravity diversion
from a possible reservoir with two alternative capacites and/or a pump from a lower river (refer to Figure 7.3).
Between the reservoir and pump site the rise base flow increases by 2 acft/day due to groundwater drainage into the river. 
Ignore losses from the reservoir. Revenue is estimated at $300/acre/year.

Flow Process - Flow into reservoir -> Reservoir -> Water to Farm -> Groundwater Infiltration -> Pump from a Lower River Diversion Back to Farm


Seasonal Flow and Demand

Season, (t)         River Inflow, (Q_t), acft       Irrigation Demand, acft/acre

    1                           600                             1.0
    
    2                           200                             3.0

Profit/area    $300/acre irrigated/year

WATER SOURCE #1
Reservoir Specifications - High Dam (Capacity: 700 acft, Capital Costs: $10,000/yr), Low Dam (Capacity: 300 acft, Capital Costs: $6,000/yr), No operating costs
WATER SOURCE #2
Pump (Capacity: 2.2 acft/day, Capital Cost if Built: $8,000/yr, Operating Cost: $20/acft)


THE SOLUTION:
Uses Mixed Integer Programming to Solve this Linear Program

HW 6 - Dual and IP Formulations
Kyle Miller
October 14, 2024
$offtext

* 1. Define the time set, Assuming that their are 182.5 days in the first and second 6 month sections of the year. 
SET 
    src /hrsvr "High Dam Reservoir", lrsvr "Low Dam Reservoir", pump "Pump Station"/
    t Seasons 1 and 2 within the year /1*2/;  

* 2. DEFINE input data, *pump capacity converted from acft/day to acft/year
PARAMETERS
    TotDemand(t)   'Total demand per season (ac-ft per season)'
        /1 1, 2 3/
    TotalInflow(t) 'Total inflow per season (ac-ft per season)'
        /1 600, 2 200/
    CapCost(src)     capital cost ($ to build per year)
         /hrsvr 10000,
          lrsvr 6000,          
          pump  8000/
    OpCost(src) operating cost ($ per ac-ft)
         /hrsvr 0,
          lrsvr 0,
          pump  20/
    MaxCapacity(src) Maximum capacity of source when built (ac-ft per year)
          /hrsvr 700,
           lrsvr 300,
           pump  830/
    MinUse(src) Minimum required use of source when built (ac-ft per year)
          /hrsvr 0,
           lrsvr 0,
           pump  0/
* "Integer" variables free within 0 to 1 bounds. Same as "Binary Variables" statement below
* Leave values as is
   IntUpBnd(src) Upper bound on integer variables (#)
          /hrsvr 1,
           lrsvr 1,
           pump  1/
   IntLowBnd(src) Lower bound on integer variables (#)
            /hrsvr 0,
           lrsvr 0,
           pump  0/;
           
* 3. DEFINE the variables
VARIABLES I(src) binary decision to build or do prject from source src (1=yes 0=no)
          X(src,t) volume of water provided by source src (ac-ft per season)
          TCOST  total capital and operating costs of supply actions ($);

BINARY VARIABLES I;
* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   COST            Total Cost ($)
   MaxCap(src,t)     Maximum capacity of source when built (ac-ft per year)
   MinReqUse(src)  Minimum required use of source when built (ac-ft per year)
   MeetDemand(t)      Meet demand (ac-ft per year)
   IntUpBound(src) Upper bound on interger variables (number)
   IntLowBound(src) Lower bound on integer variables (number);

* Total cost includes both capital and operating costs
COST.. TCOST =E= SUM(src, CapCost(src)*I(src) + SUM(t, OpCost(src)*X(src,t)));

* Water provided by a source should not exceed its capacity
MaxCap(src,t).. X(src,t) =L= MaxCapacity(src)*I(src);

* Minimum required use if a source is built
MinReqUse(src).. SUM(t, X(src,t)) =G= MinUse(src)*I(src);

* Total water provided must meet demand for each season
MeetDemand(t).. SUM(src, X(src,t)) =G= TotDemand(t);

* Integer variable bounds
IntUpBound(src).. I(src) =L= IntUpBnd(src);
IntLowBound(src).. I(src) =G= IntLowBnd(src);

* 5. Define the model
MODEL WatSupplyRelaxed /ALL/;

* 6. Solve as a mixed-integer program, minimizing the total cost
SOLVE WatSupplyRelaxed USING MIP MINIMIZING TCOST;

* 7. Display results
DISPLAY X.L, I.L, TCOST.L;


* Dump all input data and results to a GAMS gdx file
Execute_Unload "HW6 - IP.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls HW6 - IP.gdx"