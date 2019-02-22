;;Lynx dispersal model
;;Author Ian Philips

;;This model was developed in Netlogo 5.2 
;;running on Windows 7

;;-------------------- extensions and variables ---------------------
extensions [table
            gis]


breed [lynxes lynx]



globals
[i
 prob
 Ps
 var1 ;; checking for ptype barrier
 Neighbors-green
 Neighbors-yellow
 var5 ;;records last green patch a lynx was on
 dispersal-max

 ;; iterations
 ;;counter adds one each time a run of the model happens.  When it reaches the number in the iterations button it halts.
 ;;See the experiment procedure
 counter
 ;; pvisits is for plotting the number of habitat patches visited each iteration
 pvisits
 ;;avgpvisits is sum of pvisits / iterations  
 avg-pvisits
 raster1
 raster_roads
 raster-out
 Pc
 current-patch
 n-barr
 sum-green
 sum-yellow
 pattern2
 x-visit-all
 y-visit-all
 go-multi-expt
 count-rows
 countvar
 
 surviving_lynx
 ;;for sens test  
 xvar
 matvar
 var_i
 pvis250718
 
  
]

patches-own [
  ptype
  hasroad
  visited 
  runs-visited
  number-of-visits
  
  ;; summary variables collected when best release is run
  pvis ;; patch visits resulting from a release at this patch
  dispmean ;; mean dispersal distance from this patch
  dispmax  ;;max dispersal distance from this patch
  p2 ;; ratio of yellow to green
  patch-pvisits ;;this should capture the number of times patches visited when a release expt is made from that patch from the global pvisits
  
  ]


lynxes-own [ last-green-x
   last-green-y   
   number-mat
   leave-var
   pleave
   travel
   distance_today
   lynxonroad ;; used in road mortality
   ] 



;;----------------- Run the model with different parameters ---------------------

;;This runs "best release" under several parameterisations
;; of number of lynx releases and different values of "max-number-mat"

to sensitivity-test
  
   ;;for each combination of parameters 
   ;;set parameters
   ;;set the names of output files
   ;;setup model -call setup scotland
   ;;run nmodel -call best release
  
  
  ;;set parameters
  ;; 9 maxnumbermat and 6 lynx
  set move-table "normx11smax45" 
  print "normx11smax45"
  set xvar "normx11smax45"
  ;;test-maxmat
  set max-number-mat 9
  print "max mat 9"
  set matvar "m9"
  ;;run-with-change-lynx-numbers
  set number-of-lynxes 6
  print "lynx 6"
  set var_i 2
  print var_i 
  
  ;;The file names of output are set by concatenation.
  print (word "paperA" "pvis" var_i xvar matvar "lynx 6" ".asc") 
  set pvis-ascii-file-name (word "paperA" "pvis" var_i xvar matvar "lynx 6" ".asc")
  set disp-max-file-name (word "paperA" "dispmax" var_i xvar matvar "lynx 6" ".asc")
  set p2-file-name (word "paperA" "p2" var_i xvar matvar "lynx 6" ".asc")
 
  
  ;;setup the model and run 
  setup-scotland
  print"setup-scotland"
  best-release
  print "best-release"
 
 
;;9 max-number-mat 32lynx
   
  set number-of-lynxes 32
  print "lynx 32"
   set var_i 2
   print var_i 
   print (word "paperB" "pvis" var_i xvar matvar "lynx 32" ".asc")  
  set pvis-ascii-file-name (word "paperB" "pvis" var_i xvar matvar "lynx 32" ".asc")
  set disp-max-file-name (word "paperB" "dispmax" var_i xvar matvar "lynx 32" ".asc")
  set p2-file-name (word "paperB" "p2" var_i xvar matvar "lynx 32" ".asc")
  
  
  setup-scotland
  print"setup-scotland" 
  best-release 
  print "best-release"


  ;; max-number-mat 60 lynx 32
  set max-number-mat 60
  print "maxmat 60"
  set matvar "m60" 
    
  set number-of-lynxes 32
  print "lynx 32"
  set var_i 2
  print var_i 
  print (word "paperD" "pvis" var_i xvar matvar "lynx 32" ".asc") 
  set pvis-ascii-file-name (word "paperD" "pvis" var_i xvar matvar "lynx 32" ".asc")
  set disp-max-file-name (word "paperD" "dispmax" var_i xvar matvar "lynx 32" ".asc")
  set p2-file-name (word "paperD" "p2" var_i xvar matvar "lynx 32" ".asc")
  
    
  setup-scotland
  print"setup-scotland"
  best-release 
  print "best-release"
 

  ;; number-of-lynxes 6 max-number-mat 60
  set number-of-lynxes 6
  print "lynx 6"
  set var_i 4
  print var_i 
  print (word "paperC" "pvis"  var_i xvar matvar "lynx 6" ".asc") 
  set pvis-ascii-file-name (word "paperC" "pvis" var_i xvar matvar "lynx 6" ".asc")
  set disp-max-file-name (word "paperC" "dispmax" var_i xvar matvar "lynx 6" ".asc")
  set p2-file-name (word "paperC" "p2" var_i xvar matvar "lynx 6" ".asc")
  
  setup-scotland
  print"setup-scotland"
  best-release  
  print "best-release"
 
end



;;------------------------------ setting up ----------------------------------------------- 

to setup-scotland
   setup-model true
   ;; initialize-scotland
   
   ;;calls procedures which load gis data to patches
   load-costgridNUK
   show-costgridNUK
   LoadRoads 
  
end



to set-up-big-expt
   ;;This is called instead of setup model which was run when only one patch is being tested as a release point
   ;;It clears most things, but not the patches.  
   ;;Instead it asks patches to set pvisits and visited variables to 0

    clear-turtles
    clear-drawing
    clear-output ;; check what this is  - irrelevant if there's no output box
    reset-ticks
    ask patches [set visited 0 set pvisits 0]
    set counter 0
    set dispersal-max 0
    setup-turtles  
end


to setup-model [reset-counter]
;;This avoids clearing variables which need to be kept through all the iterations of the model
 ifelse (not reset-counter) [
                            clear-turtles
                            ;clear-patches
                            clear-drawing
                            clear-output
                            reset-ticks
                            ask patches [set visited 0 ]
                            ;;set pvisits 0
                                                      
                            ]
 [;;else clear everything 
   
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  __clear-all-and-reset-ticks ] 
 
  setup-turtles
  read-table
end


to load-costgridNUK
  ;;this loads an ascii file with 1000m resolution covering Scotland and the 
  ;;Kielder forest region adjacent to the Scottish border
  ;;the full path to the map can be inserted here
  set raster1 gis:load-dataset  "patchdata/sco_kielpatch4.asc"
  print "file load"
  ;; assignes values in the raster to the patch variable ptype
  gis:apply-raster Raster1 ptype
end  
  

  
to show-costgridNUK
  ;;this displays the patches
  ;;makes a list of the different raster values 
  gis:set-world-envelope gis:envelope-of raster1
  print "envelope set"
  gis:apply-raster Raster1 ptype
   
  ask patches [if ptype = 2 [set pcolor green]] ;;woodland and scrub
  ask patches [if ptype = 1 [set pcolor yellow]] ;;anything not woodland or scrub
  ask patches [if ptype = -9999 [set pcolor red]] ;; any missing values coded as -9999 in GIS 
  ask patches [if ptype = 0 [set pcolor red]]
  print "costgrid displayed"
end 



to LoadRoads
  ;;reads in a rasterised roads dataset
  set raster_roads gis:load-dataset  "patchdata/Mrwayards.asc"
  ;;gis:set-world-envelope gis:envelope-of raster1 ;; this is too big a raster for the model
  print "roads load"
  gis:apply-raster raster_roads  hasroad  
end   




to setup-turtles
  create-lynxes number-of-lynxes [set color pink 
  set size 1 
  ]
  ;;This starts all the agents from one point e.g. a release site.  
  ;;ask lynxes [ setxy release-x release-y ]
  ;; when running simulations on every patch 
  ;;x-visit-all and y-visit-all are used
  
  ask lynxes [setxy x-visit-all y-visit-all ]
  set Pc continue-straight
end




to read-table
    set prob table:make
    ;;an absolute path can be given if necessary
    ;;set-current-directory "C:\\Users\\Ian\\Documents\\Dissertation\\models"

    if move-table = "x8 max dist 25" [file-open "book2.txt" set smax 25]
    if move-table = "x17 max dist 25" [file-open "Ps_x_is_17.txt" set smax 25]
    if move-table = "x2 max dist 40" [file-open  "Ps_x_is_2_max40.txt" set smax 40]
    if move-table = "x11_smax25" [file-open  "x11_smax25.txt" set smax 25]
    if move-table = "x11smax45" [file-open  "x11smax45.txt" set smax 45]
    if move-table = "normx11smax25" [file-open  "movetable/normx11smax25.txt" set smax 25]
    if move-table = "normx11smax45" [file-open  "movetable/normx11smax45.txt" set smax 45]
    
    while [file-at-end? = false] [
  
                                  table:put prob file-read file-read
  
                                  ]
  
    file-close  
end  







;;------------------- experiment control ----------------------------------------------- 



;;------------ control simulations which run for every patch or multiple parameter settings ----

to best-release
;;this is a button;;
;; If you want to run this from the butotn
;;you have to setup scotland before you press this button if you want anything to work
;;This procedure is also called by sentitivity test, which also 
;;sets parameters and calls the setup procedures
visit-every-patch  
end  




to visit-every-patch
  ;;This is called by pressing the best release button
  ;;It visits every patch inturn going along each row.  
  ;;If a cell is green then it calls set-up-bigexperiment 
  ;;It will also call experiment to run the simulation for that patch
  ;;it also calls outputbig-expt-data later to write to files the results from each cell
  
  ;;call this procedure here instead of having to call it every experiment  
  ;; this is the table giving the probability of a certain number of movement steps
  read-table
    
  set x-visit-all 0 
  set y-visit-all 0
  set go-multi-expt 0
  set count-rows 0 ;; used in output-big-expt-data but does the same as  x-visit-all


  ;; have to start a loop here
  ;;Rows
  repeat (envy) [
    
    ;columns
       repeat (envx) [
      
         ask patch  x-visit-all  y-visit-all [if pcolor = green [set go-multi-expt 1]]
      
         ;;flow control for big expt
         ;;This part of the proceture only runs experiment if the patch is green, because 
         ;;releases would only happen on green patches
         if go-multi-expt = 1 [set-up-big-expt
            repeat iterations [experiment] ;;repeat statement makes this run multiple iterations on each patch 
                                       ;;print x-visit-all
        
         ]
      
         ;;4 6 12 this is called for every cell even if it's not green. 
         ;;This is so the raster gets zero values to show the position of the green cells
         ;;these next few lines will output 0 for red and yellow cells without running experiment
      
         ;;summarise the results of the experiment at each patch for every cell
         ;; these procedures replace output-big-expt-datav2
         set-summary-patch-variables
      
         ;;post experiment - reset appropriate variables 
         set go-multi-expt 0
         ;;move to the next cell
         set x-visit-all (x-visit-all + 1) 
      
         ;;have to set dispersal-max to 0 here so the value of the last green cell isn't carried into yellow and red cells
         set dispersal-max 0
         
         set pvisits 0
         set avg-pvisits 0 
            
         ;;these feed the calibrate function and are reset here
         set sum-yellow 0
         set sum-green 0
         set pattern2 0
        
         ;;end of the inner columns loop 
         ]
  
    set  y-visit-all ( y-visit-all + 1) ;;after experimenting on every cell in a row add 1 to rows y
    print "current Y value"
    print y-visit-all
    ;;print "turtlesalive" 
    ;;print count turtles 
    set   x-visit-all 0
    
    ;; update the output file of experiment results 
    ;;This outputs results every row
    ;; so if computer crashes then not whole model run lost
    patch-summary-to-asc 
    
  ;;end of the rows loop
  ]
  
  print "visited all cells"
  
end





to experiment 
 ;;This runs the simulation on a particular patch and calls movement and mortality procedures
 
 ;;iterations is an input.  This block of code is effectively a loop with stopping condition
 ;; stop when the specified iterations have run
 ifelse counter < iterations [ set counter counter + 1
                             ;print "counter plus 1 runs in expt"
                             ;; this line leads to what gets reset between iterations
                             setup-model false]
                             ;;else do this 
                             [ stop] 

  ;;The Kramer-Schadt et al model runs for a number of years
  repeat (365 * years) [  

                        ;;if all lynxes have died just tick to the end of the iteration. 
                        if any? lynxes [
                        ask lynxes [BasicMortality] 
                    
                                        if count lynxes > 0[
                                                               ask lynxes [set leave-var random-float 1
                                                               prob-dist
                                                               rt random 360
                                                               chdw
                                                               ]
                                                           ]

                                        ]
                                
                       tick
                       ]
  
  
  ;; summarise the simulation run
  set pvis250718 count patches  with [visited = 1]
 
  ;;distance-from-release-point is calculated here but is not recorded in a variable
  ;;just the summary is kept 
  if count lynxes > 0 [ 
                       set dispersal-max max [distancexy x-visit-all y-visit-all] of lynxes 
                       
                       calibrate
  ]  
  
  ;;;avg-pvisits at the end of an experiment
  set avg-pvisits avg-pvisits + pvisits / iterations
  
   
end


;;--------- control a simulation on a single patch -------------------------------------- 


to experiment-1-patch 
  ;;Sometimes users might just want to run simulations for a single patch
  setup-scotland 
  ;;release-x and release-y are inputs
  set x-visit-all release-x 
  set y-visit-all release-y 
  ;;calls up setup up turtles
  set-up-big-expt  
  ;;iterations is an input
  repeat iterations [experiment do-plot]

  print "dispersal-max" print(dispersal-max) print"pattern2" print(pattern2) print"pvisits" print(pvisits / 50) 
end




;;------------------------- movement --------------------------------------------
to prob-dist
  set travel random-float 1
  ;;just a check that distance from one day isn't being carried into the next
  set distance_today 0  

  set i smax
  while [i >= 1] 
        [  
         set Ps  table:get prob i
     
         set i (i - 1)
         ;; Ps of 45 is small Ps 1 is big
         ;; once Ps gets bigger than the travel value distance_today is set for chdw and  
         ;; the procedure is halted.  
        if Ps  > travel [ set distance_today i stop ]
   
        ;;end of while loop
        ]
end   



to chdw
  
  ;;Pc is the probability of continuing in a straight line
  ;;it is set using a slider
  
    ;; each movement step occurs in this while loop
  ;; this is the loop in which to ask whether lynxes are reaching enough patches
  ;; and to run a roads mortality procedure 
  while [distance_today > 0] [
                     ;;Sets pvisits the variable which will be used to plot the number of cells visited
                     ;;This sets the patches own variable number-of-visits to show how many visits it has had ?in 
                     ;;all the iterations? 
                     if any? lynxes [set number-of-visits number-of-visits + 1]
       
                     ask patch-here [if ptype = 2 
       
                                                 [if visited = 0  
                                                 [set visited 1 set pvisits pvisits + 1 set runs-visited runs-visited + 1]
                                                 ]
                                   ]
      
      
        ;;last-green-x and y are used to return lynx to dispersal habitat that have wandered the maximum 
        ;;allowable distance into matrix 
        if [ptype] of patch-here = 2 [set last-green-x [pxcor] of patch-here set last-green-y [pycor] of patch-here ]      
        if [ptype] of patch-here = 0 [setxy last-green-x last-green-y stop] 
       
        ;;number-mat counts the number of steps into matrix a lynx has taken
        ;;Revilla cited in Kramer-Schadt said 9 was the maximum it would travel out of the dispersal
        if [ptype] of patch-here = 1 [set number-mat number-mat + 1 ]
        if number-mat >= max-number-mat [set number-mat 0 setxy last-green-x last-green-y]
       
        
        ;;If there are any holes in code and a lynx strays onto barrier then it is returned to the 
        ;;last dispersal patch it was on        
        ask lynx who [ask patch-here [if ptype = 0 [set var5 1]]]
        if var5 = 1 [setxy last-green-x last-green-y]
       
        ;;Next lines are used several times in code to deal with lynxes reaching the edge
        carefully [ask patch-ahead 1 [set var1 ptype]] [stop print "error at chdw"] 
       
        if patch-ahead 1 = nobody [rt 180 forward 1 
                                  type "at edge"
                                  ask lynx who [ ask patch-ahead 1 [set var1 ptype]]
                                  ]
        
        if patch-ahead 1 = nobody [stop]
 
        ;;check-for-barrier
        while [var1 = 0]           
                  [rt random 360
                      if patch-ahead 1 = nobody [rt 180 forward 1 type "at edge"] 
                      ask lynx who [ ask patch-ahead 1 [set var1 ptype]]
                      ask patch-ahead 1 [set var1 ptype]
                  ]
       
        ;;these 3 lines are the lynx sensing its surroundings
        ask lynx who [set Neighbors-green count neighbors  with [pcolor = green] ]        
        ask lynx who [set Neighbors-yellow count neighbors  with [pcolor = yellow] ]
        ask lynx who [set n-barr count neighbors  with [pcolor = red] ]
        ;;A random direction was set at the start of the day
           
  
        ;;This section applies the rules and decides movement based upon the rules explained in the text 
        ;;There are 3 main groups of situations in the code: Allneighbors are green, all yellow or a mix. 
        
        ;; the random-float 1 in this and similar blocks below
        ;; is Randcontinue_straight in the paper
        ;;all neighbors green
        ask lynx who[ if Neighbors-green = 8  [ 
                                   if-else pc > random-float 1 [forward 1]
                                                               [ rt random 360 
                                                               forward 1 ]
                                    ]
                     ]
         
         ;;all neighbors yellow
         ask lynx who[if Neighbors-yellow = 8 [
                                   if-else pc > random-float 1 [forward 1]
                                                               [ rt random 360
                                                               forward 1]
                                   ]
                     ]
  
  
         ;;neighbors have a range of patch types
         ;;changed from using an and line here whilst debugging it made no difference.  
         if Neighbors-yellow != 0[  if Neighbors-green != 0 [
                                       Ask lynx who [set current-patch [ptype] of patch-here]
                                       ask lynx who [if current-patch = 2 [do-green-220718]]                        
                                       ask lynx who [if current-patch = 1 [do-yellow]] 
                   
                                      ]
                      ]
   
  
         ;; To deal with what if there is a red neighbor.  
         if n-barr != 0[  if Neighbors-green != 0 or Neighbors-yellow != 0  [
   
                                                       Ask lynx who [set current-patch [ptype] of patch-here]
                                                       ask lynx who [if current-patch = 2 [do-green-220718]]                                                                       
                                                       ask lynx who [if current-patch = 1 [do-yellow]]                               
                                                       ask lynx who [if current-patch = 0 [stop]] 
                                                      ]
                        ]
   
   
         ;;reduce the dist: the number of cells still to pass through today
         set distance_today ( distance_today - 1)
   
         
         ;procedure call - each movement step see if the lynx crosses a road 
         road_cross_mortality   
   
 ;;end of the while loop distance_today is > 0
 ]
  
end  





to check-for-barrier
    ;;this may get called several times during the chdw procedure
    ;; to avoid lynxes stepping into barrier
    while [var1 = 0]
                      [rt random 360 
                      if patch-ahead 1 = nobody [setxy last-green-x last-green-y stop] 
                      ask lynx who [ ask patch-ahead 1 [set var1 ptype]]
                      ask patch-ahead 1 [set var1 ptype]
                  ]
end  








to do-green-220718
 ;;Procedure order of actions matches Kramer-Schadt.  Older version of proceedure had different order
 ;;Called when a lynx is on a green patch with mixed neighbors 
 ;;APPLY PLEAVE FIRST AND THEN DECIDE WHETHER TO CARRY ON IN A STRAIGHT LINE
 ;;If it is on green and there is a green option ahead it first considers continuing in a straight line
 
 carefully [set var1 [ptype] of patch-ahead 1] [stop print "error at chdw"] 
  
 ask lynx who [ 
                ;;use pleave to determine whether it will choose a yellow or a green patch
                ;;this mimics the Kramer-Schadt condition of having a chance of moving into matrix ranging from 
                ;; 0 to randomly choosing any matrix patch pstep-into-matrix is pmatrix in the literature
                set pleave (Neighbors-yellow * pstep-into-matrix)
                           
                if pleave > leave-var [   
                                            ;; lynx decides to step into matrix 
                                            ;;#### this is the change that makes it different to earlier version of procedure
                                            ;; if a lynx has decided to move into matrix, 
                                            ;; If one of the yellow patches is infront of it, 
                                            ;; it goes into the nested if and has to decide whether to go straight on or not
                                            if [ptype] of patch-ahead 1 = 1 [ 
                                                 
                                                                             if pc > random-float 1 [forward 1 stop] ;;####stop will exit do green procedure
                                                                             ;; if it decides not to go straight ahead, 
                                                                             ;;the code will carry on after this loop.  
                                                                             ] 
                                        
                                            ;; if in the block above the lynx has decided to step into matrix                                                 
                                            ;; turn round until facing a yellow patch
                                            if count neighbors  with [pcolor = yellow] != 0 [                                                                                       
                                            ;; randomise whether the lynx turns clockwise or anticlockwise to choose 
                                            ;; a matrix patch to step into
                                              if-else random-float 1 > 0.5  [rt 45 if  [ptype] of patch-ahead 1 = 1 [forward 1 stop] ;45
                                                 rt 45 if  [ptype] of patch-ahead 1 = 1 [forward 1 stop] ;90
                                                 rt 45 if  [ptype] of patch-ahead 1 = 1 [forward 1 stop] ;135
                                                 rt 45 if  [ptype] of patch-ahead 1 = 1 [forward 1 stop] ;180
                                                 rt 45 if  [ptype] of patch-ahead 1 = 1 [forward 1 stop] ;225
                                                 rt 45 if  [ptype] of patch-ahead 1 = 1 [forward 1 stop] ;270
                                                 rt 45 if  [ptype] of patch-ahead 1 = 1 [forward 1 stop] ;315
                                                 rt 45 if  [ptype] of patch-ahead 1 = 1 [forward 1 stop] ;360                                                                                          
                                              ]
                                              ;check each patch anti clockwise
                                              [
                                                  rt -45 if  [ptype] of patch-ahead 1 = 1 [forward 1 stop] ;45
                                                  rt -45 if  [ptype] of patch-ahead 1 = 1 [forward 1 stop] ;90
                                                  rt -45 if  [ptype] of patch-ahead 1 = 1 [forward 1 stop] ;135
                                                  rt -45 if  [ptype] of patch-ahead 1 = 1 [forward 1 stop] ;180
                                                  rt -45 if  [ptype] of patch-ahead 1 = 1 [forward 1 stop] ;225
                                                  rt -45 if  [ptype] of patch-ahead 1 = 1 [forward 1 stop] ;270
                                                  rt -45 if  [ptype] of patch-ahead 1 = 1 [forward 1 stop] ;315
                                                  rt -45 if  [ptype] of patch-ahead 1 = 1 [forward 1 stop] ;360
                                              ]
                                                                                             
                                                                                             
                                            ]
                                             
                                       ] 
                  
                      
                  ;;this code runs if the lynx decides not to step into matrix
                  ;;if there is the option to go straight ahead into green 
                  ;; check if the lynx wants to
                  if [ptype] of patch-ahead 1 = 2 [
                                                      ;;lynx decides to go straight on into green
                                                      if-else pc > random-float 1 [forward 1 stop] ;;####stop will exit do green procedure
                                                      
                                                      [ ;;lynx wants to stay in green but change direction
                                                        if-else random-float 1 > 0.5  [rt 45 if  [ptype] of patch-ahead 1 = 1 [forward 1 stop] ;45
                                                                                              rt 45 if  [ptype] of patch-ahead 1 = 2 [forward 1 stop] ;90
                                                                                              rt 45 if  [ptype] of patch-ahead 1 = 2 [forward 1 stop] ;135
                                                                                              rt 45 if  [ptype] of patch-ahead 1 = 2 [forward 1 stop] ;180
                                                                                              rt 45 if  [ptype] of patch-ahead 1 = 2 [forward 1 stop] ;225
                                                                                              rt 45 if  [ptype] of patch-ahead 1 = 2 [forward 1 stop] ;270
                                                                                              rt 45 if  [ptype] of patch-ahead 1 = 2 [forward 1 stop] ;315
                                                                                              rt 45 if  [ptype] of patch-ahead 1 = 2 [forward 1 stop] ;360
                                                                                                                                                                                      
                                                                                              ]
                                                                                             ;check each patch anti clockwise
                                                                                             [rt -45 if  [ptype] of patch-ahead 1 = 2 [forward 1 stop] ;45
                                                                                              rt -45 if  [ptype] of patch-ahead 1 = 2 [forward 1 stop] ;90
                                                                                              rt -45 if  [ptype] of patch-ahead 1 = 2 [forward 1 stop] ;135
                                                                                              rt -45 if  [ptype] of patch-ahead 1 = 2 [forward 1 stop] ;180
                                                                                              rt -45 if  [ptype] of patch-ahead 1 = 2 [forward 1 stop] ;225
                                                                                              rt -45 if  [ptype] of patch-ahead 1 = 2 [forward 1 stop] ;270
                                                                                              rt -45 if  [ptype] of patch-ahead 1 = 2 [forward 1 stop] ;315
                                                                                              rt -45 if  [ptype] of patch-ahead 1 = 2 [forward 1 stop] ;360
                                                                                              ]
                                                       ]
                                                 ;end of if [ptype] of patch-ahead 1 = 2     
                                                 ]
             ;;end of ask lynx who      
                ]       


end  








to do-green
 ;;OLD VERSION OF PROCEDURE 
 ;;can be used to test effect of the order of behavioural rules on outcomes.  
 ;;Called when a lynx is on a green patch with mixed neighbors
 ;;If it is on green and there is a green option ahead it first considers continuing in a straight line
 carefully [ask patch-ahead 1 [set var1 ptype]] [stop print "error at chdw"] 
 ask lynx who [if [ptype] of patch-ahead 1 = 2 [
                           
                            if-else pc > random-float 1 [forward 1 stop]
                                                         ;;else use pleave to determine whether it will choose a yellow or a green patch
                                                         ;;this mimics the Kramer-Schadt condition of having a chance of moving into matrix ranging from 
                                                         ;; 0 to randomly choosing any matrix patch pstep-into-matrix is pmatrix in the literature
                                                         [ set pleave (Neighbors-yellow * pstep-into-matrix)
                                                         ]
                                                                                                                         
                                                                 if pleave > leave-var [ rt random 360   
                                                                 ;; this option it randomly chooses a patch
                                                                    if patch-ahead 1 = nobody [setxy last-green-x last-green-y stop]
                                                                   ask patch-ahead 1 [set var1 ptype]
                                                                                                                                                                          
                                                                                      check-for-barrier ;; need to check it's not barrier
                                                                                                                                                                                                                                             
                                                                                     ;;end of if pleave
                                                                                     forward 1 stop]
                                                                                                                                  
                                                                 if pleave < leave-var [ rt random 360
                                                                  ;;this option it decides to stay in dispersal habitat 
                                                                  ;; if [ptype] of patch-ahead 1 = nobody [rt 180 forward 1 type "at edge"]
                                                                  carefully [ask patch-ahead 1 [set var1 ptype]] [stop print "error at chdw"]               
                                                                                
                                                                                 ask patch-ahead 1 [set var1 ptype]
                                                                                    
                                                                                     While [var1 != 2]
                                                                                           [rt random 360 
                                                                                            set var1 ptype
                                                                                     ]
                                                                              
                                                                              
                                                                                      forward 1  stop
                                                                               ;end of if pleave
                                                                               ]
                                                                   
                                                          ;end of if patch ahead 1 = green   
                                                          ]
]
                           
;;Now checking what to do if situation if it is on green but the patch ahead is yellow
carefully [ask patch-ahead 1 [set var1 ptype]] [stop print "error at chdw"] 

ask lynx who [if [ptype] of patch-ahead 1 = 1 [
                                               set pleave (Neighbors-yellow * pstep-into-matrix)
                               
                              if pleave < leave-var [ rt random 360
                                                    if patch-ahead 1 = nobody [rt 180 forward 1 type "at edge"]  
                                                    if-else any? neighbors with [ptype = 2] 
                                                    [   face one-of neighbors with [ptype = 2]
                                                     forward 1
                                                    stop]
                                                    [check-for-barrier forward 1 stop]
                                                    ]
                               ;;so if pleave is over the threshold for chosing either matrix or dispersal habitat 
                               ;; first consider continuing in a straight line then going in a different direction on yellow.  
                               if-else pc > random-float 1 [forward 1]
                                                           ;;else
                                                           [   
                                                            rt random 360   
                                                                  if patch-ahead 1 = nobody [rt 180 forward 1 type "at edge"] 
                                                                  
                                                                   ask patch-ahead 1 [set var1 ptype]
                                                                                      ;; need to check it's not barrier
                                                                                      check-for-barrier 
                                                                                      forward 1 stop
                                                            ;;end of else 
                                                           ] 
  ;;end of if yellow
   ]
]
end  







to do-yellow
 ;;called by chdw when the lynx is on a yellow patch with a choice of neighbors
 ;; first consideration if there are green and yellow patches is to decide whether to 
 ;;return to green dispersal habitat
 ;;in do yellow there is a +1 on Neighbors-yellow because the current patch is yellow
 ;;in do green the current patch is green so the total number of yellow patches will be Neighbors-yellow
  
 set pleave (Neighbors-yellow * pstep-into-matrix)
                              ;; Kramer- Schadt et al said consider whether to stay in dispersal above going in a straight line
                              ;; that's why its the opposite way to the if green.  
                               if pleave < leave-var [  rt random 360
                                                      if patch-ahead 1 = nobody [rt 180 forward 1 type "at edge"] 
                                                                                 ask patch-ahead 1 [set var1 ptype]
                                              
                                                      if-else any? neighbors with [ptype = 2]
                                                                                  [face one-of neighbors with [ptype = 2]
                                                                                  forward 1
                                                                                  stop]
                                                                                  ;;else
                                                                                  [check-for-barrier forward 1 stop]
                                                     ]  
  
  
  ;;If the procedure is still running here the lynx has decided to stay in yellow
  ;; It can either continue in yellow in the same direction or set a new course in the yellow.  
  ;;Decide whether to move on in a straight line
  if pc > random-float 1 [
                         check-for-barrier
                         forward 1
                         stop]  

  ;;again the stop exits back to chdw once a movement choice is made
  ;;final option the lynx has chosen to stay in yellow but to change direction.  
  ;;there is a chance that the random turn may land it back on the original yellow patch ahead.  
  ;; this also stops it getting stuck if there is only one yellow patch in Neighbors-yellow    
  rt random 360
  if patch-ahead 1 = nobody [rt 180 forward 1 type "at edge"] 
  
  ask patch-ahead 1 [set var1 ptype]
                     While [var1 != 1]
                                          [rt random 360 
                                          set var1 ptype
                                          forward 1  stop
                                          ]
  
end




;;-------------------------------- mortality ---------------------------------------------- 

;;These procedures are called above and determine whether a lynx survives or dies.  


;;called by to experiment 
to BasicMortality
  if random-float 1 < base_daily_mort [die ]
end 





to road_cross_mortality
  ;; first get the patch value assigned to the lynx on the patch
  Ask lynx who [set lynxonroad [hasroad] of patch-here]
  
  ;; if the lynx is on a road then road crossing mortality check is run
  Ask lynx who [if random-float 1 < road_cross_mort [  
      ;;print "roadkill"
      die]]
end  





;;---------------------- record results --------------------------------------------


to calibrate
  ;;called by to experiment  to summarise a simulation run on a single patch
  set sum-yellow sum [number-of-visits] of patches with [pcolor = yellow]
  set sum-green sum [number-of-visits] of patches with [pcolor = green]
  
  ;;added this ifelse to avoid div /0 when experiment doesn't run 
  ifelse int (sum-green + sum-yellow) > 0
  [set pattern2 (sum-yellow / (sum-green + sum-yellow))]
  [set pattern2 0] 
end  



to set-summary-patch-variables
  ;;called by visit-every-patch
  ;;sets summary patch variables
  ;;summary variables collected when best release is run
  ;;pvis ;; patch visits resulting from a release at this patch
  ;;dispmean ;; mean dispersal distance from this patch
  ;;dispmax  ;;max dispersal distance from this patch
  ;p2 ;; ratio of yellow to green
  
  ask patch  x-visit-all  y-visit-all [
    set dispmax dispersal-max 
    
    set p2  pattern2 
    set pvis avg-pvisits  
    set patch-pvisits pvisits ;;this should capture the number of times patches visited when a release expt is made from that patch
  ]
  
end  







to patch-summary-to-asc
  ;;called by visit-every-patch
  ;;patch summary to ascii file output

  ;;globals set by inputs on interface
  ;;pvis-ascii-file-name
  ;;disp-max-file-name
  ;;p2-file-name
  
  set raster-out gis:patch-dataset pvis
  gis:store-dataset raster-out pvis-ascii-file-name
 
  set raster-out gis:patch-dataset dispmax
  gis:store-dataset raster-out disp-max-file-name

  set raster-out gis:patch-dataset p2
  gis:store-dataset raster-out p2-file-name   

  ;;show count patches with-max [pvis]
  ;;show count patches with-max [dispmax]
    
end






;;-------- examine results of a simulation experiment on a single patch.  

to do-plot
 ;;called by experiment-1-patch 
 set-current-plot "dispersal"
 set-current-plot-pen "dispersal-max"
 plotxy counter dispersal-max
  
 set-current-plot "patches-visited"
 set-current-plot-pen "patch-visits"
 ;;plotxy counter pvisits
 plotxy counter pvis250718
 
 
 ;; count the surviving lynxes at the end of each iteration
  ifelse count lynxes > 0 [set surviving_lynx count lynxes][set surviving_lynx 0] 
 
 set-current-plot "surviving-lynx"
 set-current-plot-pen "surviving_lynx"
 plotxy counter surviving_lynx
 
end    
  



to show-patches-used
  ;;called by button
  ask patches [if number-of-visits = 0 [set pcolor blue]]
  ask patches [if number-of-visits > 0 and number-of-visits <= 10 [set pcolor brown]]
  ask patches [if number-of-visits > 10 and number-of-visits <= 20 [set pcolor orange]]
  ask patches [if number-of-visits > 20 and number-of-visits <= 30 [set pcolor brown]]
  ask patches [if number-of-visits > 30 [set pcolor green]]  
end  




to show-runs-visited
  ;;called by button
  ask patches [if runs-visited = 0 [set pcolor blue]]
  ask patches [if runs-visited > 0 and runs-visited <= 10 [set pcolor brown]]
  ask patches [if runs-visited > 10 and runs-visited <= 25 [set pcolor orange]]
  ask patches [if runs-visited > 20 and runs-visited <= 40 [set pcolor green]]
  ask patches [if runs-visited > 50 [set pcolor white]]  
end




to send-runs-visited-to-gis
  ;;Exports an .asc file for the runs visited
  ;;this can be used to give a probability of connection
  set raster-out gis:patch-dataset runs-visited
    
  ;gis:store-dataset dataset file 
  ;;Note path may need to be changed here to full path depending on where files installed  
  gis:store-dataset raster-out name-runs-visited-output
end





to send-patch-visits-data-to-gis 
  ;;this exports patch visits data for an experiment on a single patch.  
  ;;gis:load-coordinate-system "WGS_84_Geographic.prj"
  ;; change from ptype to the output value 
  set raster-out gis:patch-dataset number-of-visits 
  gis:store-dataset raster-out name-of-output ;;input box
  
end  

















@#$#@#$#@
GRAPHICS-WINDOW
430
9
1208
988
-1
-1
2.0
1
10
1
1
1
0
0
0
1
0
383
0
473
0
0
1
ticks
30.0

SLIDER
221
224
401
258
max-number-mat
max-number-mat
0
100
9
1
1
NIL
HORIZONTAL

PLOT
175
1038
375
1188
dispersal
itteration
distance
0.0
10.0
0.0
30.0
true
true
"" ""
PENS
"dispersal-max" 1.0 0 -16777216 true "" ""

PLOT
381
1038
581
1188
patches-visited
iteration
pvisits
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""
"patch-visits" 1.0 0 -16777216 true "" ""

BUTTON
5
48
117
81
setup
setup-scotland
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
4
1094
78
1154
release-x
202
1
0
Number

INPUTBOX
81
1094
156
1154
release-y
52
1
0
Number

INPUTBOX
236
101
289
161
years
1
1
0
Number

INPUTBOX
301
101
358
161
iterations
50
1
0
Number

SLIDER
12
168
185
202
pstep-into-matrix
pstep-into-matrix
0
1
0.03
0.01
1
NIL
HORIZONTAL

BUTTON
954
1039
1080
1098
show-patches-used
show-patches-used
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
807
1038
947
1098
name-of-output
patches_used.asc
1
0
String

BUTTON
1086
1039
1281
1099
send patch visits data to GIS
send-patch-visits-data-to-gis
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
10
584
160
612
Name of output has to end with .asc\n
11
0.0
1

SLIDER
10
223
178
256
continue-straight
continue-straight
0
1
0.53
0.01
1
NIL
HORIZONTAL

CHOOSER
221
169
403
214
move-table
move-table
"x2 max dist 40" "x8 max dist 25" "x17 max dist 25" "x11_smax25" "x11_smax45" "normx11smax25" "normx11smax45"
6

TEXTBOX
13
202
163
220
this is Pmatrix
11
0.0
1

TEXTBOX
7
9
157
38
Lynx dispersal model: Test all possible release points in turn
11
0.0
1

TEXTBOX
11
1156
161
1174
Release point co-ordinates
11
0.0
1

TEXTBOX
16
276
416
295
_________________________________________________
14
104.0
1

TEXTBOX
12
357
412
386
_________________________________________________
14
104.0
1

TEXTBOX
3
610
425
639
_________________________________________________
14
104.0
1

TEXTBOX
813
1178
963
1220
Press this after pressing the show patches / runs visited buttons and naming outputs
11
0.0
1

BUTTON
956
1117
1081
1170
show runs visited
show-runs-visited
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
808
1115
946
1175
name-runs-visited-output
runs_visited.asc
1
0
String

BUTTON
1090
1115
1242
1166
send runs data to GIS
send-runs-visited-to-gis
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
124
102
228
162
number-of-lynxes
6
1
0
Number

BUTTON
122
48
223
81
best-release
best-release
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
0
102
50
162
envx
384
1
0
Number

INPUTBOX
64
101
114
161
envy
474
1
0
Number

INPUTBOX
7
428
211
488
pvis-ascii-file-name
paperApvis2normx11smax45m9lynx 6.asc
1
0
String

INPUTBOX
6
495
211
555
disp-max-file-name
paperAdispmax2normx11smax45m9lynx 6.asc
1
0
String

INPUTBOX
227
495
418
555
p2-file-name
paperAp22normx11smax45m9lynx 6.asc
1
0
String

INPUTBOX
227
426
417
486
num-visits-file-name
numvisits6x11mat60_1307.asc
1
0
String

BUTTON
7
711
132
745
sensitivity-test
sensitivity-test
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
364
103
426
163
smax
45
1
0
Number

INPUTBOX
206
303
361
363
base_daily_mort
7.0E-4
1
0
Number

INPUTBOX
13
304
168
364
road_cross_mort
0.0020
1
0
Number

BUTTON
2
1037
164
1071
experiment-1-patch
experiment-1-patch
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
11
1013
198
1037
Test_a_ single_ release_ point 
13
0.0
1

TEXTBOX
8
640
352
695
Test all possible release points in turn, testing test 4 parameter combinations 6 or 32 lynx released and max-number-mat 9 and 60  \n\n
13
0.0
1

PLOT
596
1037
796
1187
surviving-lynx
iteration
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"surviving_lynx" 1.0 0 -7500403 true "" ""

@#$#@#$#@

## WHAT IS IT?

The aim is to simulate Eurasian lynx(Lynx lynx) movement and dispersal in Scotland (and in Kielder Forest  on the England / Scotland border.  
The questions asked of the model are:  How would lynx disperse in Scotland if they were to follow the same movement rules, suffer the same mortality rates and are modelled with the same behavioural parameters as lynx observed in the Swiss Jura? Specifically. How far would Eurasian Lynx (Lynx lynx) disperse in their first year if re-introduced to Scotland? Would they explore enough suitable habitat to suggest that establishing territories is likely? How does the maximum distance a lynx is prepared to travel through sub-optimal matrix habitat affect the results?  


The model has been developed by Ian Philips.  A paper submitted to the Journal Applied Spatial Analysis and Policy describes the model in detail.    


 

## HOW IT WORKS

The rule-set used determines how far lynx will move on a daily basis, the probability that they will venture out of their habitat to cross other ground and the probability that they will keep moving in the same direction during the day.  Explanation of the  model development and justification of the rules is given in the model description section of the paper.  

## HOW TO USE IT



The model first establishes which release points are to be tested.  The model can be run at a single release point by typing in the co-ordinates into the GUI or it can be run in turn for all possible release points.  

There are three ways to run the model:

1) set parameters for lynx movement by typing into the input boxes adjusting sliders and setting the output filenames.  Next press the setup button to load the grid of patches. 
Barrier areas are shown in red  
Matrix areas are shown in yellow  
Dispersal habitat is shown in green  
Next press the best-release button.  This runs the simulation a set number of iterations for every "green" patch 

2) If you want to test four combinations of parameters number-of-lynxes 6 or 32 and max-number-mat 9 or 32. press the sensitivity-test button.  


With options 1 and 2 results are saved as ascii files


3) If you wish to simulate a release from a single release point,
set the desired release point (these are not British National Grid squares.  To get from patch British National Grid patch_x * 1000 + 31197 and patch_y * 1000 + 526469).  Other parameters can be set with inputs and sliders.  
Press the experiment-1-patch button and this will setup and run the simulation for 
the specified number of iterations.  
To export the results from plots:   
File > export > all plots,  results are saved in .csv format   
Pressing the show-patches-used button will display the total number of visits to each patch visited during the experiment as a crude choropleth map.    
By giving a name and pressing the send-to-gis button an ASCII file is exported to the same directory which stores the model.    
The show runs visited button shows the number of iterations in which that patch was reached.  This can also be exported as an ASCII file and can be used to find the probability of connection between a release point and another patch.  


## THINGS TO NOTICE

Results for simulations and explanations of the choice of parameters are given in the paper results section.

## THINGS TO TRY

Parameters can be altered.  

## EXTENDING THE MODEL

The further work section of the paper discusses possible extensions to the model.

## NETLOGO FEATURES

GIS and table extensions were used.  

## RELATED MODELS

This model uses the approach used in the lynx SEPM (Spatially Explicit Population Model) which examined lynx in Germany.  It was programmed in Delphi, 
Kramer-Schadt, Stephanie, Eloy Revilla, Thorsten Wiegand, and Urs Breitenmoser. 2004. “Fragmented Landscapes, Road Mortality and Patch Connectivity: Modelling Influences on the Dispersal of Eurasian Lynx.” Journal of Applied Ecology 41 (4): 711–23. https://doi.org/10.1111/j.0021-8901.2004.00933.x.


And the landscape model is based on work by David Hetherington. 
Hetherington, David Andrew. 2005. “The Feasibility of Reintroducing the Eurasian Lynx, Lynx Lynx to Scotland.” Ph.D., University of Aberdeen. http://ethos.bl.uk/OrderDetails.do?uin=uk.bl.ethos.424959.
  

## CREDITS AND REFERENCES

References and acknowledgements are given in the paper.  For further information contact Ian Philips https://environment.leeds.ac.uk/transport/staff/972/dr-ian-philips
A copy of the model is available from:https://github.com/DrIanPhilips/LynxABM


This model is built using Netlogo 5.2 which was developed by Uri Wilensky(1999)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
