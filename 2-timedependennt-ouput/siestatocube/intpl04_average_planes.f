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
C     mesh01,
C     mesh02,
C     mesh03       : number of original grid points along X-, Y- and Z- box sides
C     nrela(1..3)  : index of microcell
C     drela(1..3)  : relative coordinates of point in the microcell
C     func         : function to be interpolated 
C     fintp        : interpolation result
c     igrid - poryadkovye nomera 8 vershin
C

      integer mesh0(3),nrela(3)
      real    func(mesh0(1),mesh0(2),mesh0(3)),fintp  ! NB! single precision
      double precision drela(3)
	  
	  
      double precision distance(8), distance_sum
      integer igrid(8,3), wrapped_grid(8,3)
      integer ii,ix,nx,ny,nz
      real    F(8), Faver(3,2)

	  
	  
c      write(6,*)'============================================'
c      write(6,*)'nrela=',(nrela(ix),ix=1,3),'drela=',(drela(ix),ix=1,3)

      ii=0
C      distance_sum=0
	  
      do nx=0,1
      do ny=0,1
      do nz=0,1		
        ii=ii+1
c        write(6,*) 'ii=',ii
		
c       relative coordinates of all vertices to origin of the cell		  
        igrid(ii, 1)=nx
        igrid(ii, 2)=ny
        igrid(ii, 3)=nz
c        write(6,*) 'igrid',(igrid(ii,ix), ix=1,3)

c       distance should be taken without wraping the grid (nx, not igrid(x))
C        distance(ii)=sqrt(
C     .  (nx-drela(1))**2+(ny-drela(2))**2+(nz-drela(3))**2)
C        distance_sum=distance_sum+distance(ii) 
C        distance_sum=distance_sum + 1/distance(ii)**3
c        write(6,*) distance(ii)

		  
c       transform them to real mesh numbers, taking into account periodicity of the mesh
        do ix=1,3
c         mesh is from 1 to mesh0 starting from 0+step, ending on the right boundary!		
       wrapped_grid(ii,ix)=modulo(nrela(ix)+igrid(ii,ix)-1, mesh0(ix))+1
        end do
c        write(6,*) 'real grid',(igrid(ii,ix), ix=1,3)
		  
        F(ii)=func( wrapped_grid(ii,1), 
     .               wrapped_grid(ii,2), wrapped_grid(ii,3) )
c        write(6,*) 'F(ii)', F(ii)
		
      end do
      end do
      end do		  

C     recover interpolated function value:
      Faver=0 
      do ix=1,3
        do ii=1,8
c         average over 4 vertices in bottom and top planes
          if(igrid(ii,ix).eq.0) Faver(ix,1)=Faver(ix,1)+F(ii)/4.		  		
          if(igrid(ii,ix).eq.1) Faver(ix,2)=Faver(ix,2)+F(ii)/4.
        end do
      end do
	  

      fintp=0	
      do ix=1,3
C       linear interpolation between top nad bottom plane averages
c       and averaging over 3 directions
      fintp = fintp+(Faver(ix,1)*(1-drela(ix))+Faver(ix,2)*drela(ix))/3.
      end do
	  
      return

      end 
