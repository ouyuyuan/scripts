
; http://www.ncl.ucar.edu/Applications/BasicExamples/nclex/contourplot/cn05n.ncl
; Set the range and spacing of the contour levels.
*cnLevelSelectionMode : ManualLevels
*cnMinLevelValF :  200
*cnMaxLevelValF :  5000
*cnLevelSpacingF : 500
; Turn on contour fills.
*cnFillOn : True
; Turn off the contour lines and labels.
*cnLinesOn : False
*cnLineLabelsOn : False
*cnHighLabelsOn : False
*cnLowLabelsOn : False
*cnInfoLabelOn : False
; Turn on the overlay labelbar.
*pmLabelBarDisplayMode : ALWAYS
; Set the labelbar size
*pmLabelBarHeightF : .15
*pmLabelBarWidthF : .6
; Set the location and orientation of the labelbar.
*pmLabelBarSide : bottom
*lbOrientation : horizontal
; Set the lablebar title, font, and color.
;"lbTitleString" : "Day 1"
;"lbTitleFont" : 22  ; Helvetica-bold
;"lbTitleFontColor" : "PaleGreen4"
; Turn off the labelbar perimeter box 
*lbPerimOn : False
; Turn off lines that separate each color in the labelbar.
*lbBoxLinesOn : 0
; Turn off labelbar labels
;"lbLabelsOn" : False

*vpXF : .10                               ; define the viewport location
*vpYF : .80
*vpWidthF : .80                           ; and size
*vpHeightF : .50


;
; set resources of the inherited Title objects
;
*tiMainString        : PCOM topography (m)
*tiXAxisString       : Longitude
;*tiXAxisFont         : helvetica
*tiXAxisFontHeightF  : .02
*tiYAxisString       : Latitude
;*tiYAxisFont         : helvetica
*tiYAxisFontHeightF  : .02
;*tiMainFont          : helvetica
*tiMainFontHeightF   : .03

;
;  Set resources of the inherited TickMark object
;
*tmXBMode : EXPLICIT
*tmXBValues : (/-180.,-120.,-60.,0,60,120,180/)
*tmXBValues : (/0.,60.,120.,180.,240,300,360/)
*tmXBLabels : (/0E,60E,120E,180,120W,60W,0W/)
*tmYLMode : EXPLICIT
*tmYLValues : (/-90, -60,-30,0,30,60,90/)
*tmYLLabels : (/90S,60S,30S,EQ,30N,60N,90N/)
*tmXBLabelFontHeightF :  .016         ; set x axis scale size
*tmYLLabelFontHeightF :  .016         ; set y axis scale size
*tmXBLabelFont        : times-roman
*tmYLLabelFont        : times-roman
*tmXBMinorOn          : False
*tmYLMinorOn          : False
