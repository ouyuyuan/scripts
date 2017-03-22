*
*         #################################################
*         ###                                           ###
*         ###         Draw the track of typhoon         ###
*         ###              Version 1.1                  ###
*         ###                                           ###
*         ###        Developed by Huang Xiaogang        ###
*         ###                                           ###
*         ###      Department of Atmosphere Science,    ###
*         ###      Institute of Meteorology, PLAUST     ###
*         ###         Nanjing 211101, P.R.China         ###
*         ###             2002/9/27/08:00               ###
*         ###                                           ###
*         ###   =====================================   ###
*         ###    modified by Ou to draw visual points   ###
*         ###            May/15/2010                    ###
*         #################################################

'reinit'
'open track1.ctl'
 starlat=15
 endlat=55
 starlon=70
 endlon=140
 
'set lon 'starlon' 'endlon''
'set lat 'starlat' 'endlat''
'set cmin 10000'
'set grads off'
'set mpdset cnworld3000'
*'set mpdset hires'
 mpchoice=1
 if (mpchoice=2)
    'set mproj lambert'
    'set xlint 5'
    'set ylint 5'
*   'set grid on 1'
    'set grid off'
    'd latt'
    'set line 1 1 2'
     i=0
     a=starlat
     b=endlat
     c=starlon
     d=endlon
     ii=1
     aa=a
     cc=c 
     while(cc<=endlon)
     
         i=i+1
        'q w2xy 'c' 'starlat''

         xms1.i=subwrd(result,3)
         yms1.i=subwrd(result,6)
        'q w2xy 'd' 'endlat''
         xms3.i=subwrd(result,3)
         yms3.i=subwrd(result,6)

        if (i=ii)
           'set string 1 l 2 0'
           'set strsiz 0.15 0.15'
            mark2=''cc''%' E'
           'draw string 'xms1.i-0.3' 'yms1.i-0.2' 'mark2''
           'draw mark 2 'xms1.i+0.2' 'yms1.i-0.1' 0.08'
*       draw the grid
           if (i>1)
         
               a_1=starlat
               i_1=0
               while (a_1<=endlat)
                  i_1=i_1+1
                  'q w2xy 'cc' 'a_1''
                  xms_1.i_1=subwrd(result,3)
                  yms_1.i_1=subwrd(result,6)
                  if (i_1>1)
                      j_1=i_1-1
                      'draw line 'xms_1.j_1' 'yms_1.j_1' 'xms_1.i_1' 'yms_1.i_1''
                  endif
                  a_1=a_1+0.1
               endwhile
            endif       
            ii=ii+50
            cc=cc+5
         endif
         if (i>1)
     
             j=i-1
            'draw line 'xms1.j' 'yms1.j' 'xms1.i' 'yms1.i''
            'draw line 'xms3.j' 'yms3.j' 'xms3.i' 'yms3.i''

         endif
         d=d-0.1
         c=c+0.1      
     endwhile
     i=0
     ii=1
     while(aa<=endlat)
         i=i+1
        'q w2xy 'starlon' 'a''
         xms2.i=subwrd(result,3)
         yms2.i=subwrd(result,6)

        'q w2xy 'endlon' 'b''
         xms4.i=subwrd(result,3)
         yms4.i=subwrd(result,6)

         if (i=ii)
           'set string 1 l 2 0'
           'set strsiz 0.15 0.15'
            mark1=''aa''%' N'
           'draw string 'xms2.i-0.6' 'yms2.i' 'mark1''
           'draw mark 2 'xms2.i-0.25' 'yms2.i+0.1' 0.08'

           if (i>1)
         
               a_1=starlon
               i_1=0
               while (a_1<=endlon)
                  i_1=i_1+1
                  'q w2xy 'a_1' 'aa''
                  xms_1.i_1=subwrd(result,3)
                  yms_1.i_1=subwrd(result,6)
                  if (i_1>1)
                      j_1=i_1-1
                      'draw line 'xms_1.j_1' 'yms_1.j_1' 'xms_1.i_1' 'yms_1.i_1''
                  endif
                  a_1=a_1+0.1
               endwhile
            endif       

            ii=ii+50
            aa=aa+5
         endif

         if (i>1)
             j=i-1
            'draw line 'xms2.j' 'yms2.j' 'xms2.i' 'yms2.i''
            'draw line 'xms4.j' 'yms4.j' 'xms4.i' 'yms4.i''
         endif
         a=a+0.1
         b=b-0.1      
     endwhile
 else
    'set mproj latlon'

    'set xlint 5'
    'set ylint 5'
    'set grid on 1'
    'd latt'
 endif    

  
 
  'set line 2 1 1'
  i=0
 dummy=0
 while (dummy<2)
 dummy=read('LatLonOld.dat')
   if(dummy<2)
     i=i+1
     if(i>0)
   res=sublin(dummy,2)

    lat1=subwrd(res,3)
    lon1=subwrd(res,4)
    iprov=subwrd(res,2)
    icolor=iprov
    if(icolor>28)
        icolor=icolor-28
    endif
    if(icolor>14)
        icolor=icolor-14
    endif
    if(icolor<2)
        icolor=icolor+2
    endif
    'q w2xy 'lon1' 'lat1''
     xms.i=subwrd(result,3)
     yms.i=subwrd(result,6)
    if(iprov=2100) 
        icolor=9
    endif
    if(iprov=7)
        icolor=3
    endif
    if(iprov=15)
        icolor=7
    endif
    if(iprov=21)
        icolor=2
    endif
    if(iprov=23)
        icolor=3
    endif
    if(iprov=5)
        icolor=4
    endif
    if(iprov=31)
        icolor=2
    endif
    if(iprov=7)
        icolor=9
    endif
    if(iprov=19)
        icolor=2
    endif
    if(iprov=10|iprov=24)
        icolor=4
    endif
    'set line 'icolor' 1 1'
  imark=3
  if(iprov=16|iprov=25|iprov=18)
       imark=9
  endif
*  if(iprov=1|iprov=11|iprov=14|iprov=17|iprov=18|iprov=10|iprov=9|iprov=21|iprov=13|iprov=12|iprov=15|iprov=16|iprov=25)
    'draw mark 'imark' 'xms.i' 'yms.i' 0.04'
*    'draw mark 'imark' 'xms.i' 'yms.i' 0.01'
*  endif
 endif
 endif
 endwhile
 
'printim ChinaGrid.png x2000 y1500 white'
'reinit'
'quit'
