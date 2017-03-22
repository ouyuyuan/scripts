
      parameter(ni=145,nj=112)

      integer stainf(740,10)
      real lat_ob(740),lon_ob(740)
      real lat_grid(ni,nj),lon_grid(ni,nj)
      integer x_grid(740),y_grid(740)
      
      stainf=0
      lat_ob=0
      lon_ob=0
      x_grid=145
      y_grid=112

      open(11,file='/home/ou/gd/data/proc/station_inf.dat')
      read(11,*)
      do i=1,740
        read(11,'(10i10)')(stainf(i,j),j=1,10)
      enddo
      close(11)
      open(11,file='/home/ou/gd/data/proc/station_inf.dat')
      read(11,*)
      do i=1,740
        read(11,'(10x,2(i8,i2))')ilata,ilatb,ilona,ilonb
        lat_ob(i)=ilata+real(ilatb)/60.0
        lon_ob(i)=ilona+real(ilonb)/60.0
      enddo
      close(11)

      open(12,file='/home/ou/gd/data/bs/zlat.dat')
      open(13,file='/home/ou/gd/data/bs/zlon.dat')
      do j=1,nj
        read(12,'(145f10.5)')(lat_grid(i,j),i=1,ni)
        read(13,'(145f10.5)')(lon_grid(i,j),i=1,ni)
      enddo
      close(12)
      close(13)

      do k=1,740
        do j=1,nj
            do i=1,ni
                if(abs(lat_grid(i,j)-lat_ob(k))<1.0.and.abs(lon_grid(i,j)-lon_ob(k))<1.0)then
                    dist1=(lat_grid(i,j)-lat_ob(k))**2+(lon_grid(i,j)-lon_ob(k))**2
                    m=x_grid(k)
                    n=y_grid(k)
                    dist2=(lat_grid(m,n)-lat_ob(k))**2+(lon_grid(m,n)-lon_ob(k))**2
                    if(dist1<dist2)then
                        x_grid(k)=i
                        y_grid(k)=j
                    endif
                 endif
             enddo
         enddo
      enddo

      open(21,file='/home/ou/gd/data/proc/station_inf_neibor.dat')
      write(21,'(12a10)')'sta_id','lat','lon','altitude','mercury',&
'bgn_yr','bgn_mon','end_yr','end_mon','index','x_PRECIS','y_PRECIS'
      do i=1,740
        write(21,'(12i10)')(stainf(i,j),j=1,10),x_grid(i),y_grid(i)
        !if(x_grid(i)==145)print *,'increment too small!!!!'
      enddo
      close(21)

      end
        

      


