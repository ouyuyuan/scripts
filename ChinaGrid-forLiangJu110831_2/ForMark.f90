      parameter(ngrid=5374,ni=219,nj=183)
      
      integer mark(ni,nj)
      open(11,file='corrected_grid.txt')
      do j=1,nj
        read(11,*)(mark(i,j),i=1,ni)
      enddo
      close(11)
      
      open(11,file='mark.dat')
      do j=1,nj
        write(11,'(219i3)')(mark(i,j),i=1,ni)
      enddo
      close(11)
      
      end
