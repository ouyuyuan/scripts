
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-12-01 10:52:15 BJT
; Last Change: 2014-12-01 11:01:21 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  img = getenv("NCL_ARG_2")+getenv("NCL_ARG_0_base")

  wks = gsn_open_wks ("eps", img)

  fname = getenv("NCL_ARG_1")+"v_transport.nc"
  f = addfile( fname, "r" )
  y_ex = f->tran_10N(40:)
  year = f->time(40:)
  delete(f)
  fname = getenv("NCL_ARG_1")+"../../exp17_ws_control_cycle_re/post/v_transport.nc"
  f = addfile( fname, "r" )
  y_ctr = f->tran_10N(40:)
  delete(f)
  y = y_ex
  y = y_ex - y_ctr

  res = True
  ; {{{

  res@vpHeightF = 0.56
  res@vpWidthF = 0.72

  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnLeftString = ""
  res@gsnRightString = ""

  res@tiYAxisString = "Sv"
  res@tiXAxisString = "Year"

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

  res@tmXBMode = "Manual"
  res@tmXBTickStartF   = 0
  res@tmXBTickSpacingF = 50
  res@tmXBTickEndF     = 500

  res@tmXMajorGrid = True
  res@tmXMajorGridLineDashPattern = 2
  ; }}}

  plot = gsn_csm_xy(wks, year, y, res)
  draw(plot)

  frame(wks)
  delete(wks)
  system("eps2png_trim "+img)
end
