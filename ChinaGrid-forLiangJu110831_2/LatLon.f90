
      parameter(ngrid=5374,ni=219,nj=183)
      real gridlat(ngrid)
      real gridlon(ngrid)
      integer gridmark(ni,nj)
      
      open(11,file='mark.dat')
      do j=1,nj
        read(11,'(219i3)')(gridmark(i,j),i=1,ni)
      enddo
      close(11)

      open(11,file='Clat.txt')
      open(12,file='Clon.txt')
      do i=1,ngrid
        read(11,'(f10.5)')gridlat(i)
        read(12,'(f10.5)')gridlon(i)
      enddo
      close(11)
      close(12)

      open(13,file='LatLon.dat')
      npoint=1
      do i=1,ni
        do j=1,nj
            if(gridmark(i,j)/=0)then
                write(13,'(2i10,2f10.5)')npoint,gridmark(i,j),gridlat(npoint),gridlon(npoint)
                npoint=npoint+1
            endif
        enddo
      enddo
      close(13)

      end

