url      = "http://test.opendap.org/opendap/data/nc/"
filename = url + "123.nc"

exists = isfilepresent(filename)
if(.not.exists) then 
print("OPeNDAP isfilepresent test unsuccessful.")
print("Either file doesn't exist, or NCL does not have OPeNDAP capabilities on this system")
else
print("OPeNDAP isfilepresent test successful.")
f = addfile(filename,"r")
vars = getfilevarnames(f)
cross = f->cross
print(vars)   ; should be (in any order): "l","j","i","cross","aloan",
delete(f)
; "shot","order","bears"
end if

nc = "download.nc"
f = addfile(nc, "c")
f->data = cross
