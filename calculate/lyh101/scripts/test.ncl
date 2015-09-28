
; Description: cal. barotropic stream function
;              ref. licom_wfc.ncl
;              UU = sum( u(x,y,z)*delta(z) ), definite integration from 
;                   sea bottom to surface.
;              phi = int( UU(x,y) dy ), indefinte integration, 
;                    from north to south.
;
;       Usage: run_ncl this.ncl licom/pcom/pcom_r/soda
;              or ./bsf.sh to cal. all models at one time.
;
;              New model added in should change two place: nc file path and
;                variable field in nc files
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-03-29 11:20:52 BJT
; Last Change: 2015-04-28 09:20:38 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/snfs01/lyh/ou/scripts/pcom.ncl"

; dirs, files <<<1

datDir   = getenv("NCL_ARG_1")
nc       = getenv("NCL_ARG_2")
fname    = datDir+nc
outfile  = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
; field <<<1
f   = addfile(fname, "r")
u = f->u(0, :, :, :)
delete(f)

phi = pcom_bsf(u)

system("rm -f " + outfile)
f = addfile(outfile, "c")
f->bsf = phi(:,:)
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
