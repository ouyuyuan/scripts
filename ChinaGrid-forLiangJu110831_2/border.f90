
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
      
      open(11,file='border.dat')
      npoint=4039
      nprov=0
      do j=1,nj
        do i=1,ni
          if(gridmark(i,j)==0.and.(gridmark(i+1,j)+gridmark(i-1,j)+gridmark(i,j+1)+gridmark(i,j-1))/=0)then
            write(11,'(2i10,2f10.5)')npoint,nprov,gridlat(i,j),gridlon(i,j)
            npoint=npoint+1
          endif
        enddo
      enddo
      close(11)
      
      end

