
; Description: drake transport trend
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-09 18:54:19 BJT
; Last Change: 2014-10-09 18:54:19 BJT

; Description: global average potential temperature
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-04-10 16:41:49 BJT
; Last Change: 2014-12-04 07:37:01 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;  basename = "drake_transport_exp28"
;  basename = "drake_transport_exp_spinup"
;  basename = "drake_transport_soda_1871-2007"
;  basename = "drake_transport_exp26_101"
;  basename = "drake_transport_exp27_6001-6304"
;  basename = "drake_transport_exp28_6001-7010"
  basename = "drake_transport_exp30_1-120"
  fname = "/home/ou/archive/data/pcom/acc/"+basename+".nc"
  img = "/home/ou/archive/drawing/pcom/acc/"+basename

  wks = gsn_open_wks ("eps", img)

  f = addfile( fname, "r" )
  y = f->y
  x = f->x
  delete(f)
  y = runave_n_Wrap(y, 12, 1, 0)
  year = x/12.0 + 1871

  res = True

  res@vpHeightF = 0.45
  res@vpWidthF = 0.8
  res@vpXF = 0.16

  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnLeftString = ""
  res@gsnRightString = ""

  res@tiYAxisString = "Sv"
  res@tiXAxisString = "month"

  res@xyMonoLineColor = False
  ;   res@xyMarkLineMode = "MarkLines"
  res@xyMarkLineMode = "Lines"
  res@xyLineColor = "red"
  res@xyLineThicknessF = 3
  res@xyDashPattern = 0

  res@tmYROn = False
  res@tmXTOn = False
  res@tmYMajorGrid = True
  res@tmYMajorGridLineDashPattern = 2

;  res@tmXBMode = "Manual"
;  res@tmXBTickStartF   = 0
;  res@tmXBTickSpacingF = 50
;  res@tmXBTickEndF     = 500

  res@tmXMajorGrid = True
  res@tmXMajorGridLineDashPattern = 2

  plot = gsn_csm_xy(wks, year, y, res)
  draw(plot)

  txres               = True
  txres@txFontHeightF = 0.025
  text = "Drake Passage transport"
  gsn_text_ndc(wks, text, 0.5, 0.85, txres)

  frame(wks)

  delete(wks)
  system("eps2png_trim "+img)

end
