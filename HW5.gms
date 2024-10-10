$ontext
CEE 5410/6410 - Water Resources Systems Analysis
HW 5 - Reservoir Problem

THE PROBLEM:

A reservoir is designed to provide hydropower and water for irrigation.
The turbine releases may also be used for irrigation as shown in Figure 1.
At least one unit of water must be kept in the river each month at point A.
The hydropower turbines have a capacity of 4 units of water per month,
(flows are constant during any single month), and any other releases must bypass the turbines.
The size of farmed area is very large relative to the amount of irrigation water available,
so there is no upper limit on usable irrigation water.  The reservoir has a capacity of 9 units,
and initial storage is 5 units of water.  The ending storage must be equal to or greater than the beginning storage.
The benefits per unit of water, and the estimated average inflows to the reservoir are given in Table 1.

Table 1.
Month   Inflow Units    Hydropower Benefits ($/unit)    Irrigation Benefits ($/unit)
1           2                    1.6                                1.0
2           2                    1.7                                1.2
3           3                    1.8                                1.9
4           4                    1.9                                2.0
5           3                    2.0                                2.2
6           2                    2.0                                2.2

Decision Variables for Objective Function on a monthly basis: Units of Water to Hydropower, Units of Water to Irrigation


*Fundamental Law at Reservoir and Location of Irrigation Diversion*
Change in Storage = Inflow - Outflow
Mass Balance at the Reservoir
    Flow In = Change in Storage + Ouflow

DEVELOP and SOLVE an LP MODEL FOR MAXIMIZING THE ECONOMIC BENEFITS OF RESERVOIR OPERATION

Kyle Miller
a02300078@usu.edu
October 9, 2024
$offtext


$ontext
CEE 5410/6410 - Water Resources Systems Analysis
HW 5 - Reservoir Problem

THE PROBLEM:

A reservoir is designed to provide hydropower and water for irrigation.
...

Table 1.
Month   Inflow Units    Hydropower Benefits ($/unit)    Irrigation Benefits ($/unit)
1           2                    1.6                                1.0
2           2                    1.7                                1.2
3           3                    1.8                                1.9
4           4                    1.9                                2.0
5           3                    2.0                                2.2
6           2                    2.0                                2.2;

$offtext

* 1. DEFINE the SETS (watering months, one through six)
Sets 
    m /1*6/;

* 2. DEFINE input data in Table
Table data(m,*) 'Inflow, Hydropower Benefits, Irrigation Benefits'
          inflow              HP_benefits                      IRR_benefits
1           2                    1.6                                1.0
2           2                    1.7                                1.2
3           3                    1.8                                1.9
4           4                    1.9                                2.0
5           3                    2.0                                2.2
6           2                    2.0                                2.2;

* 3. Define Scalars to initialize parameters of dimensionality zero.
Scalars
    turbine_cap /4/
    minimum_flow_A /1/
    reservoir_cap /9/
    initial_S /5/;

* 4. DEFINE the variables
VARIABLES
    S(m)      'Storage at the end of month m'
    T(m)      'Units used for Hydropower Turbines in month m'
    spill(m)  'Units spilled from reservoir and bypassing hydropower turbines in month m'
    I(m)      'Units used for Irrigation in month m'
    flow_A(m) 'Units retained in River at Point A each month'
    Z         'Total benefits';

* Establish non-negativity constraints
POSITIVE VARIABLES S, T, spill, I, flow_A;

* 4. COMBINE variables and data in equations
EQUATIONS
   objective             'Total profit ($) and objective function value'
   m1_S                  'Mass Balance Equation at Month 1'
   res_mass_balance      'Water Mass Balance for Reservoir from Month 2 to Month 6'
   reservoir_capacity    'Reservoir Capacity Constraint'
   turbine_capacity      'Monthly Turbine Capacity Constraint'
   irr_diversion         'Inflows to Irrigation Diversion Equal Outflows at Irrigation Diversion'
   min_flow_A            'Minimum Unit Delivery to River at Point A'
   initial_ending_S      'Initial and Ending Storage Constraint are the same';

* Objective Function: Maximize Total Benefits from Hydropower and Irrigation Releases
objective..  Z =e= sum(m, data(m,'HP_benefits')*T(m)) + sum(m, data(m,'IRR_benefits')*I(m));

* Mass Balance Equation at First Month of Operation
m1_S.. S('1') =e= initial_S + data('1', 'inflow') - spill('1') - T('1');

* Reservoir Mass Balance Equation for Months 2 through 6, based on previous months storage plus the inflow minus the spill and release for hydropower
res_mass_balance(m)$(ord(m) > 1).. S(m) =e= S(m-1) + data(m,'inflow') - spill(m) - T(m);

* Reservoir Capacity Constraint
reservoir_capacity(m).. S(m) =l= reservoir_cap;

* Turbine Capacity Constraint
turbine_capacity(m).. T(m) =l= turbine_cap;

*Irrigation Diversion Equation, Units bypassing turbines plus the spill is equal to the downstream flow, one unit must be allocated to point A each month
irr_diversion(m).. T(m) + spill(m) - flow_A(m) =e= I(m);

* Minimum Flow Requirement at Point A in River
min_flow_A(m).. flow_A(m) =g= minimum_flow_A;

* End Storage Constraint, Storage at the End is greater than or equal to the initial storage
initial_ending_S.. S('6') =g= initial_S;

* 7. Model definition
Model reservoir /all/;

* 8. Solve the model using linear programming
Solve reservoir maximizing Z using lp;

* 9. Display results
Display Z.l, T.l, I.l, S.l, spill.l;
