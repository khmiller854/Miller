$ontext
CEE 5410 - Water Resources Systems Analysis
Chapter 2, Problem #3 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)

THE PROBLEM:

An irrigation development will plant two crops:  hay and grain. The objective is to maximize crop profit.
A industrial users' aqueduct provides excess water to the development during June, July, and August.  Data are as follows:

Seasonal Resource
Inputs or Profit        Crops        Resource
Availability
                June                July                    August
Water        14,000 acft            18,000 acft             6,000 acft
                Hay-June            Hay-July                Hay-August
                2 acft/acre         1 acft/acre             1 acft/acre
                Grain-June          Grain-July              Grain-August
                1 acft/acre         2 acft/acre             0 acft/acre
Land        10,000 acres

                    Hay         Grain
Profit/plant        $100/acre     $120/acre

                Determine the optimal planting for the two crops.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Kyle Miller
September 30, 2024
$offtext

* 1. DEFINE the SETS
SETS t water months /June, July, August/
     c plants /Hay, Grain/;

* 2. DEFINE input data, monthly water resources
PARAMETERS
   water_available(t) Right hand constraint values (per resource)
         /June  14000,
          July  18000,
          August 6000/;
          
* 3. DEFINE water requirements for each plant per unit area
TABLE
   water_required(c,t) Left hand side constraint coefficients
            June    July    August
     Hay     2        1       1
     Grain   1        2       0;
  
* 4. Net returns for each crop type per unit area   
Parameter
    net_return(c) / Hay 100, Grain 120/;

* 5. Establish positive variables to enforce non-negativity
Positive Variable
    x(c)     'Acres planted of each crop';

Variable
    Z        'Total net return';

* 6. Declare equations
Equations
    obj         'Objective function: Maximize net return'
    water_con(t) 'Water constraint for each month'
    land_con    'Land constraint';

* Objective function
obj..  Z =e= sum(c, net_return(c) * x(c));

* Water constraints
water_con(t).. sum(c, water_required(c,t) * x(c)) =L= water_available(t);

* Land constraint
land_con.. sum(c, x(c)) =L= 10000;

* 7. Model definition
Model irrigation /all/;

* 8. Solve the model using linear programming
Solve irrigation maximizing Z using lp;

* 9. Display the results
Display x.l, Z.l;

* 10. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
