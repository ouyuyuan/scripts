
load "ncl.ncl"

bdate = "0001-01-01 00:00:00"
edate = "0501-01-01 00:00:00"

bsec = ou_string2time (bdate, "seconds since 0001-01-01 00:00:00")
esec = ou_string2time (edate, "seconds since 0001-01-01 00:00:00")

dt = 60

nt = (esec - bsec) / dt

print(nt+0)
