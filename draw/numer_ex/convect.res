
! Title <<<1

*tiMainFontHeightF:        0.018
*tiXAxisFontHeightF:       0.018
*tiYAxisFontHeightF:       0.018
*plot_5p_slow*tiMainString : u = 0.1 m/s, 5 volumes
*plot_5p_fast*tiMainString : u = 2.5 m/s, 5 volumes
*plot_20p_slow*tiMainString : u = 0.1 m/s, 20 volumes
*plot_20p_fast*tiMainString : u = 2.5 m/s, 20 volumes

! Numerical solution prop. <<<1

*xyMarkLineMode: MarkLines
*xyMarkerSizeF : 0.02
*xyMarkerThicknessF: 2
*xyDashPattern : 1
*xyMarkerColor : red
*xyMarker : 9

! exact solution prop. <<<1

*data_exact_slow*xyLineThicknessF: 2
*data_exact_fast*xyLineThicknessF: 2
*data_exact_slow*xyDashPattern: 0
*data_exact_fast*xyDashPattern: 0
*data_exact_slow*xyMarkLineMode: Lines
*data_exact_fast*xyMarkLineMode: Lines

! other prop. <<<1

*wkFormat : eps
*tmLabelAutoStride : True
