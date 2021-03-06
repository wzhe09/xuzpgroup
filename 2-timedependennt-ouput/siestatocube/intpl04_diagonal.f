C ...........................................................
C
      subroutine intpl04 (func,fintp,mesh0,nrela,drela)
C
C     4-points linear interpolation on a 3-dim. grid.
C     The argument point (drela) falls into the microcell (nrela).
C     0 < drela(i) < 1. Of eight edge points of the microcell,
C     keep the four closest, and perform a linear interpolation
C     over this tetrahedron.
C
C     mesh0(1),
C     mesh0(2),
C     mesh0(3)       : divisions along X-, Y- and Z- box sides
C     nrela(1..3)  : index of microcell
C     drela(1..3)  : relative coordinates of point in the microcell
C     func         : function to be interpolated 
C     fintp        : interpolation result
C
      integer mesh0(3),nrela(3),inear(3),id(3),
     .        igrid0(3),igrid1(3),igrid2(3),igrid3(3), igrid4(3)
      integer ii,ix
      double precision drela(3),xx(3)
      real   F0,F1,F2,F3, F4
      real   func(mesh0(1),mesh0(2),mesh0(3)),fintp  ! NB! single precision
C
C     select 4 interpolation points:
        inear=nint(drela)   ! inear(1,2,3): closest corner of mcrocell
        xx = drela - float(inear)
C       xx(1..3) are coordinates of interpolation point in its microcell,
C            relatvely to the closest microcell corner. Therefore
C            xx(1..3) can be between -1 and 1.

      id = int(sign(1.d0,xx))
C       id(1..3) are values of xx(1..3) extended to the next integer 
C       value, i.e. either -1 or 1. Therefore the nearest grid point 
C       inear() and its three next ones displaced by id() do hopefully
C       make the tetrahedron which contains the mesh point xx().
C     Now we want to address function values in four grid points,
C     igrid0(), igrid1(), igrid2(), igrid3(). They may correspond to
C     a displacement beyond the initial grid booundaries. Take care
C     of this introducing mod():
      igrid0(1) = modulo(nrela(1)+inear(1)-1,mesh0(1))+1
      igrid0(2) = modulo(nrela(2)+inear(2)-1,mesh0(2))+1 
      igrid0(3) = modulo(nrela(3)+inear(3)-1,mesh0(3))+1
	  
      igrid1(1) = modulo(nrela(1)+inear(1)-1+id(1),mesh0(1))+1
      igrid1(2) = modulo(nrela(2)+inear(2)-1,mesh0(2))+1
      igrid1(3) = modulo(nrela(3)+inear(3)-1,mesh0(3))+1
	  
      igrid2(1) = modulo(nrela(1)+inear(1)-1,mesh0(1))+1
      igrid2(2) = modulo(nrela(2)+inear(2)-1+id(2),mesh0(2))+1
      igrid2(3) = modulo(nrela(3)+inear(3)-1,mesh0(3))+1
	  
      igrid3(1) = modulo(nrela(1)+inear(1)-1,mesh0(1))+1
      igrid3(2) = modulo(nrela(2)+inear(2)-1,mesh0(2))+1
      igrid3(3) = modulo(nrela(3)+inear(3)-1+id(3),mesh0(3))+1

C     opposite vertice
      igrid4(1) = modulo(nrela(1)+inear(1)-1+id(1),mesh0(1))+1
      igrid4(2) = modulo(nrela(2)+inear(2)-1+id(2),mesh0(2))+1
      igrid4(3) = modulo(nrela(3)+inear(3)-1+id(3),mesh0(3))+1

      
      F0 = func( igrid0(1),igrid0(2),igrid0(3) )
      F1 = func( igrid1(1),igrid1(2),igrid1(3) )
      F2 = func( igrid2(1),igrid2(2),igrid2(3) )
      F3 = func( igrid3(1),igrid3(2),igrid3(3) )
	  
      F4 = func( igrid4(1),igrid4(2),igrid4(3) )	  
	  
C     recover interpolated function value:
      fintp = (F0 + (F1-F0)*abs(xx(1)) + 
     +             (F2-F0)*abs(xx(2)) + 
     +             (F3-F0)*abs(xx(3)) )*0.95

      fintp = fintp+(F0 + (F4-F0)*abs(xx(1)) + 
     +             (F4-F0)*abs(xx(2)) + 
     +             (F4-F0)*abs(xx(3)) )*0.05

      
      return

      end 
