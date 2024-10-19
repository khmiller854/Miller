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

* 1. Define the time set, Assuming that their are 182.5 days in the first and second 6 month sections of the year. (Total Days: 365 days/year)
SET 
    t Seasons 1 and 2 within the year /1*2/;          
* 2. DEFINE input data, *pump capacity converted from acft/day to acft/year

PARAMETER
    Q(t)            'River inflow (acre-feet)'
        /1 600,
         2 200/
    demand(t)       'Irrigation demand (acre-feet/acre)'
        /1 1.0,
         2 3.0/
    high_cap_dam    'High dam capacity (acre-feet)'
        /700/
    low_cap_dam     'Low dam capacity (acre-feet)'
        /300/
    high_dam_cost   'High dam capital cost ($)'
        /10000/
    low_dam_cost    'Low dam capital cost ($)'
        /6000/
    pump_cost       'Pump capital cost ($)'
        /8000/
    pump_op_cost    'Pump operating cost ($/acre-foot)'
        /20/
    rev_per_acre    'Revenue per acre irrigated ($)'
        /300/
    days_per_season 'Days in each season'
        /182.5/;
        
* 3. DEFINE the variables    
VARIABLES
    X1               'Binary variable for high dam (1 if built, 0 otherwise)'
    X2               'Binary variable for low dam (1 if built, 0 otherwise)'
    P                'Binary variable for pump (1 if installed, 0 otherwise)'
    A                'Area irrigated (acres)'
    P1(t)            'Amount of water pumped in season t (acre-feet)'
    W1(t)            'Amount of water used from reservoir in season t (acre-feet)'
    profit           'Total profit ($)';
    

POSITIVE VARIABLES A, W1(t), P1(t);
BINARY VARIABLES X1, X2, P;

EQUATIONS
    Objective               'Objective function'
    Irr_demand(t)           'Irrigation Water supply constraint'
    high_dam_constraint(t)     'High dam capacity constraint'
    low_dam_constraint(t)      'Low dam capacity constraint'
    river_inflow(t)         'River inflow constraint'
    pump_cap(t)             'Pump capacity constraint'
    dam_choice              'Binary choice of dam type';   

* Objective Function: Maximize profit
Objective.. profit =E= rev_per_acre * A - (high_dam_cost * X1 + low_dam_cost * X2 + pump_cost * P + pump_op_cost * sum(t, P1(t)));

* Water supply constraints: irrigation demand must be met
Irr_demand(t).. W1(t) + P1(t) =G= A * demand(t);

* Reservoir capacity constraints
high_dam_constraint(t).. W1(t) =L= high_cap_dam * X1;

low_dam_constraint(t).. W1(t) =L= low_cap_dam * X2;

* River inflow constraints
river_inflow(t).. W1(t) =L= Q(t) + 2 * days_per_season;  

* Pump capacity constraints
pump_cap(t).. P1(t) =L= 2.2 * days_per_season * P;  
    
* Only one dam can be built
dam_choice.. X1 + X2 =L= 1;

* Model
MODEL reservoir_design /all/;

* Solve
SOLVE reservoir_design USING MIP MAXIMIZING profit;

* Display results
DISPLAY A.l, W1.l, P1.l, profit.l, X1.l, X2.l, P.l;