
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:43:19 BJT
; Last Change: 2014-12-01 08:06:14 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure do_eof(f, var, patName, tsName)
begin
  an = var
  an = var - conform(var, dim_avg_n(var,0), (/1,2/))
  ;an = where(ismissing(an),0,an)

  ; EOF
  neof   = 2
  optEOF = True       
  optETS = False
  ran    = an(lat|:,lon|:,time|:)                ; convenience, cleaner code
  eof    = eofunc_Wrap(ran, neof, optEOF)      
;  eof = -eof
  ts = eofunc_ts_Wrap (ran, eof, optETS)
  tsStd = dim_stddev_n(ts, 1)
  eof = eof*conform(eof, tsStd, (/0/))
  ts = dim_standardize_n( ts, 0, 1)      ; normalize

  f->$patName$ = eof
  f->$tsName$ = ts
end

latS = -20.5
latN = 20.5

datDir = getenv("NCL_ARG_1")
f = addfile(datDir+"ssh.nc","r")
ssh = f->ssh(40:,:,:)
delete(f)
ssh = smth9(ssh, 0.5, 0.25, False)

f = addfile("/home/ou/archive/data/pcom/basin/basin.nc", "r")
basin = f->basin
delete(f)
lat = basin&lat
basinc = conform(ssh, basin, (/1,2/))
latc = conform(ssh, lat, (/1/))

outfile = datDir+getenv("NCL_ARG_0_base")+".nc"
system("rm -f " + outfile)
f = addfile(outfile, "c")

ssh_Pac = ssh
ssh_Pac = where(basinc.eq.2, ssh, ssh@_FillValue)
do_eof(f, ssh_Pac, "eof_Pac", "ts_Pac")

ssh_Pac_N = ssh_Pac
ssh_Pac_N = where(latc.gt.0 .and. latc.lt.latN, ssh_Pac, ssh@_FillValue)
do_eof(f, ssh_Pac_N, "eof_Pac_N", "ts_Pac_N")

ssh_Pac_S = ssh_Pac
ssh_Pac_S = where(latc.lt.0 .and. latc.gt.latS, ssh_Pac, ssh@_FillValue)
do_eof(f, ssh_Pac_S, "eof_Pac_S", "ts_Pac_S")

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
