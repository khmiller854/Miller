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

HW 6 - Dual and IP Formulations
Kyle Miller
October 14, 2024
$offtext


* 1. DEFINE the SETS
SETS months growing months /June, July, August, Land/
     crops available crops for planting /Hay, Grain/;

* 2. DEFINE input data

* Net returns for each crop type per unit area   
Parameter
    net_return(crops) / Hay 100, Grain 120/;
    
PARAMETERS
   water_available(months) Right hand constraint values (per resource)
         /June  14000,
          July  18000,
          August 6000,
          Land  10000/;
          
* 3. DEFINE water requirements for each plant per unit area
TABLE
 water_required(crops,months) Left hand side constraint coefficients
            June    July    August    Land
     Hay     2        1       1         1
     Grain   1        2       0         1;
    
VARIABLES X(crops) plants planted (Number)
          VPROFIT  total profit ($)
          Y(months)  value of resources used (units specific to variable)
          VREDCOST total reduced cost ($);

* Non-negativity constraints
POSITIVE VARIABLES X,Y;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT_PRIMAL Total profit ($) and objective function value
   RES_CONS_PRIMAL(months) Resource constraints
   REDCOST_DUAL Reduced Cost ($) associated with using resources
   RES_CONS_DUAL(crops) Profit levels;

*Primal Equations
PROFIT_PRIMAL..                 VPROFIT =E= SUM(crops,net_return(crops)*X(crops));
RES_CONS_PRIMAL(months)..    SUM(crops,water_required(crops,months)*X(crops)) =L= water_available(months);


*Dual Equations
REDCOST_DUAL..                 VREDCOST =E= SUM(months,water_available(months)*Y(months));
RES_CONS_DUAL(crops)..          SUM(months,water_required(crops,months)*Y(months)) =G= net_return(crops);


* 5. DEFINE the MODELS
*PRIMAL model
MODEL PLANT_PRIMAL /PROFIT_PRIMAL, RES_CONS_PRIMAL/;
*Set the options file to print out range of basis information
PLANT_PRIMAL.optfile = 1;

*DUAL model
MODEL PLANT_DUAL /REDCOST_DUAL, RES_CONS_DUAL/;

* 6. SOLVE the MODELS
* Solve the PLANTING PRIMAL model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANT_PRIMAL USING LP MAXIMIZING VPROFIT;

* Solve the PLANTING DUAL model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANT_DUAL USING LP MINIMIZING VREDCOST;

display x.l, x.m;

* 7. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file

* 8 . Dump all data and results to GAMS proprietary file storage .gdx and to Excel
Execute_Unload "HW6.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls HW6.gdx"
* To open the GDX file in the GAMS IDE, select File => Open.
* In the Open window, set Filetype to .gdx and select the file.
