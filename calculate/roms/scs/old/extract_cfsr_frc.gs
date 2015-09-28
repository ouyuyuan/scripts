'reinit'

'open /media/CFSR_2/CFSR/6hourly/pgbhnl/3d/2006/04/pgbhnl.gdas.2006043000.ctl'
'set t 1 last'
'set e 1 last'

'define slp = presmsl'
'set sdfwrite /home/ou/archive/data/roms/scs/cfsr_200604.nc'
'sdfwrite slp'

'quit'
