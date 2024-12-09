* 1. DEFINE the SETS (number of years, 1-13 [2010-2022])
Sets 
    year /1*13/;

* 2. DEFINE input data in Table
Table data(year,*) 'Inflow (ac-ft), Porcupine Highline Canal Company Use (ac-ft), Paradise Irrigation and Reservoir Company Use (ac-ft), Utah Division of Wildlife Resources Pool (ac-ft)'
          inflow                HighlineIrrUse                ParadiseIrrUse                                              
1          37500                   4274.58                        2400.0                
2          37500                   2147.72                        3319.8                        
3          37500                   6159.52                        5155.1                    
4          37500                   6213.66                        5775.2                
5          37500                   3643.13                        4072.7                
6          37500                   4869.60                        4428.7                
7          37500                   6418.20                        5192.5                 
8          37500                   5124.40                        4052.1                 
9          37500                   5004.51                        7183.0                
10         37500                   4755.76                        5843.0                
11         37500                   7285.50                        8459.0                 
12         37500                   5225.85                        4875.0               
13         37500                   4783.43                        4183.0;

* 3. Define Scalars to initialize parameters of dimensionality zero.
* Minimum flow to the confluence from the East Fork will need to be 2190 ac-ft per year. This results in 6 ac-ft per day.
* Porcupine Reservoir capacity is 13196 ac-ft.
* Initial storage of reservoir based on Cache Valley Water Bank data is 4975 ac-ft.
* The UDWR has the right to 500 ac-ft in the reservoir.
* The volume of the reservoir must stay above the threshold level at 1546 ac-ft.
Scalars 
    minimum_flow_confluence /2190/ 
    reservoir_cap /13196/
    initial_S /4975/
    udwr_pool /500/
    res_threshold /1546/
*    yearly_budget /35000/;

* 4. DEFINE the variables
VARIABLES
    S(year)                         'Storage at the end of a given year'
    R(year)                         'Units released from reservoir each year'
    I(year)                         'Units used for Irrigation each year'
    flow_confluence(year)           'Units retained in River at confluence each year'
    irrigation_water_acquire(year)  'Volume of water acquired from irrigation companies water rights to fulfill confluence flow constraint per year'
    udwr(year)                      'Volume of UDWR Pool used per year to fulfill confluence flow constraint per year'
    irrigation_payment(year)        'Cost of water acquired from irrigation companies, $33.94/ac-ft'
    total_irrigation_payment        'Sum of irrigation payments across all years';

* Establish non-negativity constraints
POSITIVE VARIABLES S, R, I, flow_confluence, irrigation_water_purchase, udwr, irrigation_payment;

* 4. COMBINE variables and data in equations
EQUATIONS
   objective             'Minimize Cost ($) to Pay Irrigation Companies to Meet Confluence Goal'
   
   irrigation_cost_year  'Cost to purchase water from irrigation in a given year'
   
   water_purchase        'Amount of water purchased from irrigation companys water rights'
   
   irrigation_release    'Water released from reservoir for irrigation purposes'
   
   amount_to_confluence  'Amount at confluence every year'
   
   min_flow              'Flow Confluence Constraint'
   
   year1_S               'Mass Balance Equation at Year 1'
   
   yearly_release        'Amount of water released each year for irrigation, purchased irrigation, and UDWR pool'
   
   udwr_constraint       'Limit on UDWR Pool Release'
   
   res_mass_balance      'Water Mass Balance for Reservoir from Year 2 to Year 13'
   
   reservoir_capacity    'Reservoir Capacity Constraint'
   
   ending_S              'Storage Constraint is equal to or above the threshold';

* Objective Function: Maximize Total Benefits from Hydropower and Irrigation Releases
objective..  total_irrigation_payment =e= sum(year, irrigation_payment(year));

* Cost to purchase irrigation water to fulfill confluence goal in a given year
irrigation_cost_year(year).. irrigation_payment(year) =e= irrigation_water_acquire(year) * 33.94;

*Volume of water purchased from irrigation companys water rights
water_purchase(year).. irrigation_water_acquire(year) =l= 19024.71 - I(year);

*Water released from reservoir for irrigation purposes
irrigation_release(year).. I(year) =e= data(year,'HighlineIrrUse') + data(year,'ParadiseIrrUse');

*Amount at confluence every year
amount_to_confluence(year).. flow_confluence(year) =e= irrigation_water_acquire(year) + udwr(year);

* Minimum Flow Requirement at Point A in River
min_flow(year).. flow_confluence(year) =g= minimum_flow_confluence;

* Mass Balance Equation at First Year of Operation
year1_S.. S('1') =e= initial_S + data('1', 'inflow') - R('1');

* Reservoir Mass Balance Equation for Years 2 through 13, based on previous years storage plus the inflow minus the release
res_mass_balance(year)$(ord(year) > 1).. S(year) =e= S(year-1) + data(year,'inflow') - R(year);

*Define Release Term
yearly_release(year).. R(year) =e= I(year) + irrigation_water_acquire(year) + udwr(year);

*Limit on UDWR Pool Release in Yearly Release Function
udwr_constraint(year).. udwr(year) =l= udwr_pool;

* Reservoir Capacity Constraint
reservoir_capacity(year).. S(year) =l= reservoir_cap;

* End Storage Constraint, Storage at the End is greater than or equal to the initial storage
ending_S.. S('13') =g= res_threshold;

* 7. Model definition
Model reservoir /all/;

* 8. Solve the model using linear programming
Solve reservoir using lp maximizing total_irrigation_payment;

* 9. Display results
*Display objective.l;
