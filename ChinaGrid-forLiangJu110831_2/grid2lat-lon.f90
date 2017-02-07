
      parameter(ni=145,nj=112)
      real gridlat(ni,nj)
      real gridlon(ni,nj)
      integer gridmark(ni,nj)

      open(11,file='zlat.dat')
      open(12,file='zlon.dat')
      open(13,file='mark_grid.dat')
      do j=1,nj
        read(11,'(145f10.5)')(gridlat(i,j),i=1,ni)
        read(12,'(145f10.5)')(gridlon(i,j),i=1,ni)
        read(13,'(145i3)')(gridmark(i,j),i=1,ni)
      enddo
      close(11)
      close(12)
      close(13)

      open(21,file='lat_lon.dat')
      npoint=1
      do j=1,nj
        do i=1,ni
           !if(gridmark(i,j)==1.or.gridmark(i,j)==11.or.gridmark(i,j)==14.or.gridmark(i,j)==17.or.gridmark(i,j)==18.or.gridmark(i,j)==10.or.gridmark(i,j)==9.or.gridmark(i,j)==21.or.gridmark(i,j)==13.or.gridmark(i,j)==12.or.gridmark(i,j)==15.or.gridmark(i,j)==16.or.gridmark(i,j)==25)then
            if(gridmark(i,j)/=0)then
                write(21,'(2i10,2f10.5)')npoint,gridmark(i,j),gridlat(i,j),gridlon(i,j)
                npoint=npoint+1
            endif
        enddo
      enddo
      close(21)

      end

