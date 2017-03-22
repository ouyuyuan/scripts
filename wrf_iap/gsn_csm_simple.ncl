
;***********************************************************************;
; Function : gsn_csm_contour_map_ce_modified                                     ;
;                   wks: workstation object                             ;
;                  data: 2-dimensional data                             ;
;               resources: optional resources                           ;
;                                                                       ;
; This function creates and draws a contour plot over a map plot to the ;
; workstation "wks" (the variable returned from a previous call to      ;
; "gsn_open_wks").  "data" is the 2-dimensional data to be contoured,   ;
; and "resources" is an optional list of resources. The Id of the map   ;
; plot is returned.                                                     ;
;                                                                       ;
; This function behaves differently from gsn_contour in that it will    ;
; create a special kind of plot if certain attributes are set.          ;
;                                                                       ;
;    1. The lat/lon grid is labeled with tickmarks.                     ;
;    2. If any of the special GSUN resources "gsnLeftString,"           ;
;       "gsnCenterString," and/or "gsnRightString" are set, then they   ;
;       are used to title the top left, center, and right of the plot   ;
;       (in addition, the regular resource "tiMainString" can be set to ;
;       create a regular title).                                        ;
;    3. If the special GSUN resource "gsnZonalMean" is set to True,     ;
;       then a zonal mean XY plot is drawn.                             ;
;   3a. In addition, if "gsnZonalMeanYRefLine" is set, then a vertical  ;
;       line is drawn at this value. Otherwise, a line is drawn at 0.   ;
;    4. If the resource "cnFillOn" is set to True, then a labelbar is   ;
;       drawn and line labels are turned off.                           ;
;    5. If data has an attribute called "long_name," and "gsnLeftString";
;       hasn't explicitly been set, then the value of this attribute    ;
;       is used for the left string title.                              ;
;    6. If data has an attribute called "units," and "gsnRightString"   ;
;       hasn't explicitly been set, then the value of this attribute    ;
;       is used for the right string title.                             ;
;***********************************************************************;
undef("gsn_csm_contour_map_ce_modified")
function gsn_csm_contour_map_ce_modified(wks:graphic,data:numeric,resources:logical)
local i, contour_object, labelbar_object, xy_object, map_object, \
calldraw, callframe, old_lbar_on, zonal_mean_plot, min_lat, max_lat, datanew, \
res, res2, lbres, xy_res, mpres, cnres, levels, colors, \
lbar_zone, lbar_orient, lbar_side, lbar_height, lbar_width, lbar_just, \
map_vpwf, map_vphf, vphf, contour_plot, zonal_zone
begin
;
; Make sure input data is 1D or 2D
;
    if(.not.is_data_1d_or_2d(data)) then
      print("gsn_csm_contour_map_ce_modified: Fatal: the input data array must be 1D or 2D")
      return
    end if

; Initialize.
    old_lbar_on    = False    ; Default is no labelbar.
    new_lbar_on    = False    ; Default is no labelbar.
    mpres          = True

    infolabel_zone = 2        ; Zone for info label (may change later)
    lbar_zone      = 2        ; Zone for labelbar (may change later)
    zonal_zone     = 2        ; Zone for zonal means plot

    res2 = get_resources(resources)
;
; Write data and plot resource information to a file so we can 
; reconstruct plot if desired, without all the computational
; code beforehand.
;
    if(isatt(res2,"gsnDebugWriteFileName")) then
      gsnp_write_debug_info(data,new(1,float),new(1,float),\
                       "gsn_csm_contour_map_ce_modified",res2,1)
    end if

; Default is no zonal mean plot.
    zonal_mean_plot = get_res_value(res2,"gsnZonalMean",False)

; Check for cyclic point (default is True if we are not setting both
; lon2d/lat2d attributes and data is not 1D).

    set_cyclic = .not.(isatt(data,"lat2d").and.isatt(data,"lon2d"))
    if(get_res_value(res2,"gsnAddCyclic",set_cyclic)) then
        datanew = gsn_add_cyclic_point(data)
    else
        datanew = data
    end if

; Check for coordinate variables. These values will determine where to 
; overlay contour on map.

    check_for_y_lat_coord(datanew,res2,"contour_map")
    check_for_lon_coord(datanew,res2,"contour_map")

    if(.not.(isatt(res2,"sfXArray")))
      set_attr(res2,"sfXCStartV",-180.)
      set_attr(res2,"sfXCEndV",   180.)
    end if

    if(.not.(isatt(res2,"sfYArray")))
      set_attr(res2,"sfYCStartV",-90.)
      set_attr(res2,"sfYCEndV",   90.)
    end if

; Check if a zonal mean plot is desired. First make sure data
; is not all missing and that we have valid lat/lon coords.
    if(zonal_mean_plot) then
      if(all(ismissing(datanew))) then
        zonal_mean_plot = False
      end if
      if(.not.(is_valid_latlon_coord(datanew,"y","lat",res2).and. \
               is_valid_latlon_coord(datanew,"x","lon",res2))) then
        print("gsn_csm_contour_map_ce_modified: Warning: The resource gsnZonalMean can only be set to True")
        print("if the data has one of the coordinate variables " + get_allowed_latnames() + "and " + get_allowed_lonnames())
        zonal_mean_plot = False
      end if
    end if

; Create some contour plot resources.

    res2 = True
    set_attr(res2,"cnLineLabelBackgroundColor", "transparent")

; This section tests for more special resources: those that start
; with "gsn."

    if(isatt(res2,"gsnMajorLonSpacing"))
      mpres@gsnMajorLonSpacing = res2@gsnMajorLonSpacing
      delete(res2@gsnMajorLonSpacing)
    end if
    if(isatt(res2,"gsnMajorLatSpacing"))
      mpres@gsnMajorLatSpacing = res2@gsnMajorLatSpacing
      delete(res2@gsnMajorLatSpacing)
    end if

    if(isatt(res2,"gsnMinorLonSpacing"))
      mpres@gsnMinorLonSpacing = res2@gsnMinorLonSpacing
      delete(res2@gsnMinorLonSpacing)
    end if
    if(isatt(res2,"gsnMinorLatSpacing"))
      mpres@gsnMinorLatSpacing = res2@gsnMinorLatSpacing
      delete(res2@gsnMinorLatSpacing)
    end if
    mpres@gsnTickMarksPointOutward = get_res_value(res2, \
                                     "gsnTickMarksPointOutward",True)

; Check for left/right titles at top. Use valid "long_name" type attributes
; and "units" if they exist.

    set_right_subtitle(datanew,res2,mpres)
    set_left_subtitle(datanew,res2,mpres)

; Check if frame and/or draw are not supposed to be called.

    calldraw  = get_res_value(res2,"gsnDraw", True)
    callframe = get_res_value(res2,"gsnFrame",True)
    maxbb     = get_bb_res(res2)
;
; Tickmarks.
;
    display_mode = get_display_mode(res2,"pmTickMarkDisplayMode","nocreate")
    if(display_mode.eq.1.or.display_mode.eq.2) then
      mpres@gsnTickMarksOn = get_res_value(res2,"gsnTickMarksOn",False)
    else
      mpres@gsnTickMarksOn = get_res_value(res2,"gsnTickMarksOn",True)
    end if

; Check for subtitles at top and add to mpres if exist.
    set_subtitles_res(res2,mpres)
;
; By default, mpOutlineOn is False, unless cnFillOn is set to True
; or mpFillOn is set to False, then it is set back to True.
;
    if(check_attr(res2,"cnFillOn",True,False).or.\
       check_attr(res2,"mpFillOn",False,False))
      set_attr(res2,"mpOutlineOn",True)
    end if

; This section tests for regular resources.
    lbres = get_res_eq(res2,(/"lb","pm"/))
    mpres = get_res_eq(res2,(/"mp","vp","tm","ti","tx","am","pmA","pmO","pmT"/))
    cnres = get_res_ne(res2,(/"mp","vp","tm","lb","tx","am","pm","gsnZonal"/))

    if(cnres)
      if(check_attr(cnres,"cnFillOn",True,False))
        if(.not.check_attr(lbres,"lbLabelBarOn",False,False))
          old_lbar_on = get_res_value(cnres,"gsnOldLabelBar",GSN_OLD_LABELBAR)
          new_lbar_on = .not.old_lbar_on
          if(new_lbar_on) then
;---Make sure we keep the labelbar resources as part of cnres resources
            delete(cnres)
            cnres = get_res_ne(res2,(/"mp","vp","tm","tx","am","pm","gsnZonal"/))
            set_labelbar_res(cnres,"ce")
          else
            if(check_attr(lbres,"lbOrientation","vertical",True).or.\
               check_attr(lbres,"lbOrientation",1,True))
              set_attr(mpres, "vpWidthF",0.8)   ; Make room for labelbar
              set_attr(mpres,"vpHeightF",0.5)   ; on the side.
              set_attr(mpres,     "vpXF",0.08)
              set_attr(mpres,     "vpYF",0.90)
            end if
          end if
          set_attr(cnres,"cnLineLabelsOn",False)
        end if
        set_attr(cnres,"cnInfoLabelOn",False)
      end if
    end if
;
; Compute zones for zonal means plot, info label, and labelbar if
; they are supposed to get drawn.
;
    infolabel_on = get_res_value_keep(cnres,"cnInfoLabelOn",True)

    if(zonal_mean_plot) then
      if(infolabel_on) then
        infolabel_zone = zonal_zone + 1
        lbar_zone      = zonal_zone + 2
      else
        lbar_zone      = zonal_zone + 1
      end if
    else
      if(infolabel_on)
        lbar_zone      = infolabel_zone + 1
      end if
    end if

    if(infolabel_on)
      if(.not.isatt(cnres,"cnInfoLabelOrthogonalPosF").and.infolabel_zone.eq.2)
        cnres@cnInfoLabelOrthogonalPosF = 0.13
      end if
      cnres@cnInfoLabelZone = infolabel_zone
    end if

; Before we create the objects, turn off draw and frame for them.
    cnres           = True
    mpres           = True
    cnres@gsnDraw   = False
    cnres@gsnFrame  = False
    mpres@gsnDraw  = False
    mpres@gsnFrame = False

    contour_object = gsn_contour(wks,datanew,cnres) ; Create contours.
    map_object = gsn_csm_map_ce(wks,mpres)             ; Create map.
    overlay(map_object,contour_object)              ; Overlay contours on map.

; Retrieve some font heights and make the X/Y axis labels the same
; size, and the info label size the same as the tick mark label size.

    getvalues map_object@tickmarks
      "tmXBLabelFontHeightF" : xbfontf
    end getvalues

    getvalues map_object
      "tiXAxisFontHeightF"   : xfontf
      "tiYAxisFontHeightF"   : yfontf
    end getvalues

    font_height = min((/xfontf,yfontf/))  ; Make label sizes a function of
                                          ; the size of the X/Y axis labels.
;
; Check if user setting own font heights.
;
    main_font_height = get_res_value_keep(res2,"tiMainFontHeightF", \
                                          1.3*font_height)
    setvalues map_object
        "tiMainFontHeightF"    : main_font_height  ; main title size
    end setvalues

; Set font heights only if they haven't been set explicitly by user.

    contour_plot = check_class_name(contour_object,"contour")

    if(.not.isatt(cnres,"cnLineLabelFontHeightF"))
      setvalues contour_plot
        "cnLineLabelFontHeightF"    : xbfontf
      end setvalues
    end if

    if(.not.isatt(cnres,"cnInfoLabelFontHeightF"))
      setvalues contour_plot
        "cnInfoLabelFontHeightF"    : xbfontf
      end setvalues
    end if

;---Create a labelbar, or fix an existing one.
    if(old_lbar_on) then
      add_labelbar(wks,contour_object,lbar_zone,xbfontf,"ce",lbres)
    end if
    if(new_lbar_on) then
      fix_labelbar(contour_object,xbfontf,cnres)
    end if

; Draw all this stuff: map plot, subtitles, and tick marks.

    draw_and_frame(wks,map_object,calldraw,callframe,0,maxbb)

; Return plot object and data object (as attribute of plot object).

    map_object@data    = contour_object@data
    map_object@contour = contour_object
    return(map_object)
end

