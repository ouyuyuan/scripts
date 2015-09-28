
; other prop.

;*vpYF: 0.9
*tmLabelAutoStride : True
;*pmLegendDisplayMode: conditional
*lgPerimOn: True
*lgAutoManage: False
*lgLabelFontHeightF: 0.02

; Title

;*tiMainFontHeightF:        0.018
;*tiXAxisFontHeightF:       0.018
;*tiYAxisFontHeightF:       0.018

; exact solution prop.

*plot.data_exact.xyDashPatterns: (/0,1,2/)
*plot.data_exact.xyLineThicknesses: (/1.0,2.0,3.0/)
*plot.data_exact.xyLineColors: (/black, blue, red/)
*plot.data_exact.xyExplicitLegendLabels: (/40s exact, 80s exact, 120s exact/)

*plot.data_numer.xyMarkerColors: (/black, blue, red/)
*plot.data_numer.xyExplicitLegendLabels: (/40s numer, 80s numer, 120s numer/)
*plot.data_numer.xyMarkLineMode: Markers
*plot.data_numer.xyMarkers: (/3,6,7/)
*plot.data_numer.xyMarkerThicknessF: 2
*plot.data_numer.xyMarkerSizeF: 0.018
