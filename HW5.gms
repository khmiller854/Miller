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


* 1. DEFINE the SETS (watering months)
Sets m monthly time steps /1*6/;
    

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
    S(m)    'Storage at the end of month m'
    T(m)    'Turbine release in month m'
    I(m)    'Irrigation release in month m'
    spill(m)'Spill in month m'
    Z       'Total benefits';

* Establish non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   objective             'Total profit ($) and objective function value'
   res_mass_balance(m)   'Water Mass Balance for Reservoir'
   turbine_capacity(m)   'Monthly Turbine Capacity Constraint'
   min_flow_A(m)         'Minimum Unit Delivery to River at A'
   reservoir_capacity(m) 'Reservoir Capacity Constraint'
   initial_ending_S      'Initial and Ending Storage Constraint'
   begin_S               'Begin Storage Constraint for Timestep 1';

* Objective Function: Maximize Total Benefits from Hydropower and Irrigation Releases
objective..  Z =e= sum(m, data(m,'HP_benefits')*T(m) + data(m,'IRR_benefits')*I(m));

* Reservoir Mass Balance Equation
res_mass_balance(m)..
    S(m+1) =e= S(m) + data(m,'inflow') - spill(m) - T(m)
    $(ord(m) lt card(m) + initial_S$(ord(m) eq card(m)));
    
*Begin Storage Constraint for Timestep 1
begin_S.. S('1') =e= initial_S;

* Turbine Capacity Constraint
turbine_capacity(m).. T(m) =l= turbine_cap;

* Minimum Flow Requirement at Point A in River
min_flow_A(m).. T(m) + spill(m) =g= minimum_flow_A;

* Reservoir Capacity Constraint
reservoir_capacity(m).. S(m) =l= reservoir_cap;

* 7. Model definition
Model reservoir /all/;

* 8. Solve the model using linear programming
Solve reservoir maximizing Z using lp;


* 9. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file

