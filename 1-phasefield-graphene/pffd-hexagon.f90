!!-------------------------------------------------------------------------------------
!!------------------------------------------------------------------------------------- 
!     program to simulate phase field models
!     using finite difference methods
!     serial version
!     Wanzhen He, 2017, Tsinghua University, Beijing
!!-------------------------------------------------------------------------------------
!!-------------------------------------------------------------------------------------

PROGRAM pffd

  IMPLICIT NONE 

  INTEGER :: i,j,nx,ny,iter,temp,im,ip,jm,jp,isum
!   INTEGER,DIMENSION(8) :: values
  DOUBLE PRECISION :: c1,c2,x,y,r,dphi,D,ts,F,psi,tphi,xi_eq,xi_inf,k,n,g,tmp,sump,&
          &pi = 4.D0*DATAN(1.D0),dx,dy,t,dt
  DOUBLE PRECISION, DIMENSION(:,:), ALLOCATABLE :: phi,phi0,dphidt,xi,dxidt,grad_phi_x,&
          &grad_phi_y,angle,ax,ay,kappa2,kappa_prime,&
          &kappa,dxdy,dydx,grad_kappa2_x,grad_kappa2_y,lap_phi,lap_xi,&
          &term1,term2,term3
  DOUBLE PRECISION, DIMENSION(:) :: sump_done(20)
  CHARACTER(LEN = 512) :: cFile
!   CHARACTER(8)  :: date
!   CHARACTER(10) :: time
!   CHARACTER(5)  :: zone

     open(10,file='input',action='read')
     read(10,*)xi_eq
     read(10,*)F    
     read(10,*)nx    
     read(10,*)ny    
     read(10,*)dx    
     read(10,*)dy    
     read(10,*)dt 
     read(10,*)D
     read(10,*)n    
     read(10,*)g    
     read(10,*)tphi 
     read(10,*)psi  
     read(10,*)r 
     close(10)

  ALLOCATE(phi(nx,ny),phi0(nx,ny),dphidt(nx,ny),xi(nx,ny),dxidt(nx,ny),grad_phi_x(nx,ny),&
          &grad_phi_y(nx,ny),ax(nx,ny),ay(nx,ny),kappa2(nx,ny),angle(nx,ny),&
          &kappa_prime(nx,ny),kappa(nx,ny),dxdy(nx,ny),dydx(nx,ny),&
          &grad_kappa2_x(nx,ny),grad_kappa2_y(nx,ny),lap_phi(nx,ny),&
          &lap_xi(nx,ny),term1(nx,ny),term2(nx,ny),term3(nx,ny))

!!--------------------------------------------------------------------------
! parameter delaration:
! D   : diffusion coefficient
! tphi: arrival time of carbon species (set to 1 for normalization)
! ts  : life time of carbon species
! F   : flux
! phi : coupling coefficient
! c   : coordinates of center
!!--------------------------------------------------------------------------

  k=SQRT(2D0)
  xi_inf=xi_eq*3D0
  ts=xi_inf/F;
  sump_done=nx*ny*(-1d0)+2*nx*ny/20* &
    & (/ 1d0,2d0,3d0,4d0,5d0,6d0,7d0,8d0,9d0,1d1,1.1d1,1.2d1,1.3d1,1.4d1,1.5d1,1.6d1,1.7d1,1.8d1,1.9d1,1.9999d1 /)
   ! & (/ 1d0/1024,1d0/512,1d0/256,1d0/128,1d0/64/)
!   c1 = dble(nx)*dx/2D0
!   c2 = dble(nx)*dx/2D0

! !!! Write time when program starts
!   call date_and_time(date,time,zone,values)
!   call date_and_time(DATE=date,ZONE=zone)
!   call date_and_time(TIME=time)
!   call date_and_time(VALUES=values)
!   OPEN (1, FILE = 'timerecord_fds', STATUS='UNKNOWN', ACCESS='APPEND')
!       WRITE(1,"(a,2x,a,2x,a)") date, time, zone
! !!! Completed

!!--------------------------------------------------------------------------
!  Setup model (geometry, initial field values, ...)
!!--------------------------------------------------------------------------

!!! Ceate initial condions
  DO i = 1,nx
    DO j = 1,ny
      phi0(i,j)=-1.d0
    ENDDO
  ENDDO
  DO i = 1,nx
    DO j = 1,ny  
        x = DBLE(i)*dx
        y = DBLE(j)*dy
      IF (DSQRT((x-1)**2+(y-1)**2) .LT. r) THEN
        phi0(i,j) =  1.D0
      ENDIF
      IF (DSQRT((x-nx)**2+(y-1)**2) .LT. r) THEN
        phi0(i,j) =  1.D0
      ENDIF
      IF (DSQRT((x-(nx+1)/2)**2+(y-ny)**2) .LT. r) THEN
        phi0(i,j) =  1.D0
      ENDIF
    ENDDO
  ENDDO
  DO i = 1,nx
    DO j = 1,ny
      phi(i,j) = phi0(i,j)
      xi(i,j) = xi_inf 
    ENDDO
  ENDDO
!!! Completed
       
  iter = 0 
  isum = 1  

!!-------------------------------------------------------------------------- 
! Start evolution of phase field variables (Main loop)
!!--------------------------------------------------------------------------

  DO WHILE (.true.)
    iter = iter + 1

!  DO i = 1, nx
!    DO j = 1, ny
!      IF(phi(i,j)>=0.9) THEN
!        xi(i,j) = 0;
!      ENDIF
!    ENDDO
!  ENDDO

!!! Periodic boundary condition 
    DO i = 1, nx
      DO j = 1, ny
        ip = i+1; 
        im = i-1;
        IF (im==0) THEN
          im=nx;
        ELSEIF (ip==nx+1) THEN
          ip=1;
        ENDIF
        IF (j==1) THEN
          IF (i<(nx+1)/2) THEN
             grad_phi_x(i,j) = ((phi(ip,j) - phi(im,j))/(2d0*dx));
             grad_phi_y(i,j) = ((phi(i,j+1) - phi(i+nx/2,ny))/(2d0*dx));
             lap_phi(i,j) = (4.0*(phi(ip,j)+phi(im,j)+phi(i,j+1)+phi(i+nx/2,ny)) &
                     & +  phi(im,j+1)+phi(ip,j+1)+phi(i+nx/2-1,ny)+phi(i+nx/2+1,ny) &
                     & -  20.0*phi(i,j))/(6.0*dx**2);
             lap_xi(i,j) = (4.0*(xi(ip,j)+xi(im,j)+xi(i,j+1)+xi(i+nx/2,ny)) &
                     & +  xi(im,j+1)+xi(ip,j+1)+xi(i+nx/2-1,ny)+xi(i+nx/2+1,ny) &
                     & -  20.0*xi(i,j))/(6.0*dx**2);
          ELSE
             grad_phi_x(i,j) = ((phi(ip,j) - phi(im,j))/(2d0*dx));
             grad_phi_y(i,j) = ((phi(i,j+1) - phi(i-nx/2,ny))/(2d0*dx));
             lap_phi(i,j) = (4.0*(phi(ip,j)+phi(im,j)+phi(i,j+1)+phi(i-nx/2,ny)) &
                     & +  phi(im,j+1)+phi(ip,j+1)+phi(i-nx/2-1,ny)+phi(i-nx/2+1,ny) &
                     & -  20.0*phi(i,j))/(6.0*dx**2);
             lap_xi(i,j) = (4.0*(xi(ip,j)+xi(im,j)+xi(i,j+1)+xi(i-nx/2,ny)) &
                     & +  xi(im,j+1)+xi(ip,j+1)+xi(i-nx/2-1,ny)+xi(i-nx/2+1,ny) &
                     & -  20.0*xi(i,j))/(6.0*dx**2);
          ENDIF  
        ELSEIF (j==ny) THEN
          IF (i<=(nx+1)/2) THEN
             grad_phi_x(i,j) = ((phi(ip,j) - phi(im,j))/(2d0*dx));
             grad_phi_y(i,j) = ((phi(i+nx/2,1) - phi(i,j-1))/(2d0*dx));
             lap_phi(i,j) = (4.0*(phi(ip,j)+phi(im,j)+phi(i,j-1)+phi(i+nx/2,1)) &
                     & +  phi(ip,j-1)+phi(im,j-1)+phi(i+nx/2-1,1)+phi(i+nx/2+1,1) &
                     & -  20.0*phi(i,j))/(6.0*dx**2);
             lap_xi(i,j) = (4.0*(xi(ip,j)+xi(im,j)+xi(i,j-1)+xi(i+nx/2,1)) &
                     & +  xi(ip,j-1)+xi(im,j-1)+xi(i+nx/2-1,1)+xi(i+nx/2+1,1) &
                     & -  20.0*xi(i,j))/(6.0*dx**2);
          ELSE
             grad_phi_x(i,j) = ((phi(ip,j) - phi(im,j))/(2d0*dx));
             grad_phi_y(i,j) = ((phi(i-nx/2,1) - phi(i,j-1))/(2d0*dx));
             lap_phi(i,j) = (4.0*(phi(ip,j)+phi(im,j)+phi(i,j-1)+phi(i-nx/2,1)) &
                     & +  phi(ip,j-1)+phi(im,j-1)+phi(i-nx/2-1,1)+phi(i-nx/2+1,1) &
                     & -  20.0*phi(i,j))/(6.0*dx**2);
             lap_xi(i,j) = (4.0*(xi(ip,j)+xi(im,j)+xi(i,j-1)+xi(i-nx/2,1)) &
                     & +  xi(ip,j-1)+xi(im,j-1)+xi(i-nx/2-1,1)+xi(i-nx/2+1,1) &
                     & -  20.0*xi(i,j))/(6.0*dx**2);
          ENDIF
        ELSE
          jp = j+1;
          jm = j-1; 
          grad_phi_x(i,j) = ((phi(ip,j) - phi(im,j))/(2d0*dx));
          grad_phi_y(i,j) = ((phi(i,jp) - phi(i,jm))/(2d0*dx));
          lap_phi(i,j) = (4.0*(phi(ip,j)+phi(im,j)+phi(i,jp)+phi(i,jm)) &
                     & +  phi(ip,jp)+phi(im,jm)+phi(im,jp)+phi(ip,jm) &
                     & -  20.0*phi(i,j))/(6.0*dx**2);
          lap_xi(i,j) = (4.0*(xi(ip,j)+xi(im,j)+xi(i,jp)+xi(i,jm)) &
                     & +  xi(ip,jp)+xi(im,jm)+xi(im,jp)+xi(ip,jm) &
                     & -  20.0*xi(i,j))/(6.0*dx**2);           
        ENDIF
      ENDDO
    ENDDO
!!! Completed

!!! Field variables
    angle=datan2(grad_phi_y,grad_phi_x)
    kappa=k*(1d0+g*dcos(n*angle))
    kappa_prime=-k*n*g*dsin(n*angle)
    ay=-kappa*kappa_prime*grad_phi_y
    ax=kappa*kappa_prime*grad_phi_x
    kappa2=kappa**2
!!! Completed

!!! Periodic boundary condition and get the gradient
    DO i = 1, nx
      DO j = 1, ny
        ip = i+1; 
        im = i-1;
        IF (im==0) THEN
          im=nx;
        ELSEIF (ip==nx+1) THEN
          ip=1;
        ENDIF
        IF (j==1) THEN
          IF (i<(nx+1)/2) THEN
            dxdy(i,j) = (ay(ip,j) - ay(im,j))/(2d0*dx);
            dydx(i,j) = (ax(i,j+1) - ax(i+nx/2,ny))/(2d0*dx);
            grad_kappa2_x(i,j) = (kappa2(ip,j) - kappa2(im-1,j))/(2d0*dx);
            grad_kappa2_y(i,j) = (kappa2(i,j+1) - kappa2(i+nx/2,ny))/(2d0*dx);
          ELSE
            dxdy(i,j) = (ay(ip,j) - ay(im,j))/(2d0*dx);
            dydx(i,j) = (ax(i,j+1) - ax(i-nx/2,ny))/(2d0*dx);
            grad_kappa2_x(i,j) = (kappa2(ip,j) - kappa2(im,j))/(2d0*dx);
            grad_kappa2_y(i,j) = (kappa2(i,j+1) - kappa2(i-nx/2,ny))/(2d0*dx);
          ENDIF  
        ELSEIF (j==ny) THEN
          IF (i<=(nx+1)/2) THEN
            dxdy(i,j) = (ay(ip,j) - ay(im,j))/(2d0*dx);
            dydx(i,j) = (ax(i+nx/2,1) - ax(i,j-1))/(2d0*dx);
            grad_kappa2_x(i,j) = (kappa2(ip,j) - kappa2(im,j))/(2d0*dx);
            grad_kappa2_y(i,j) = (kappa2(i+nx/2,1) - kappa2(i,j-1))/(2d0*dx);
          ELSE
            dxdy(i,j) = (ay(ip,j) - ay(im,j))/(2d0*dx);
            dydx(i,j) = (ax(i-nx/2,1) - ax(i,j-1))/(2d0*dx);
            grad_kappa2_x(i,j) = (kappa2(ip,j) - kappa2(im,j))/(2d0*dx);
            grad_kappa2_y(i,j) = (kappa2(i-nx/2,1) - kappa2(i,j-1))/(2d0*dx);
          ENDIF
        ELSE
          jp = j+1;
          jm = j-1; 
          dxdy(i,j) = (ay(ip,j) - ay(im,j))/(2d0*dx);
          dydx(i,j) = (ax(i,jp) - ax(i,jm))/(2d0*dx);
          grad_kappa2_x(i,j) = (kappa2(ip,j) - kappa2(im,j))/(2d0*dx);
          grad_kappa2_y(i,j) = (kappa2(i,jp) - kappa2(i,jm))/(2d0*dx);         
        ENDIF
      ENDDO
    ENDDO
!!! Completed

!!! Update xi and phi
    term1=grad_kappa2_x*grad_phi_x+grad_kappa2_y*grad_phi_y
    term2=dsin(pi*phi)+psi*(xi-xi_eq)*(1d0+dcos(pi*phi))
    term3=dxdy+dydx+kappa2*lap_phi
    dphidt=(term1+term2+term3)*dt/tphi


    xi=xi+(D*lap_xi+(F-xi/ts)*(1d0-phi)/2d0)*DT-0.5d0*dphidt

  !  xi=xi+(D*lap_xi+(F-xi/ts)*(1d0-phi)/2d0)*DT-0.5d0*dphidt
  ! xi=(xi+(D*lap_xi+(F-xi/ts)*(1d0-phi)/2d0)*DT-0.5d0*dphidt)/tphi

    phi=phi+dphidt
!!! Completed

!!--------------------------------------------------------------------------
!   write out a cut through the core for both fields
!!--------------------------------------------------------------------------
    sump=sum(phi)
    IF(sump>=sump_done(isum)) then
    temp = iter
!!! phi
    write( cFile , * ) temp+100000000
    cFile = 'data.' // Trim(AdjustL(cFile)) // ''
    OPEN (1, FILE = cFile, STATUS='UNKNOWN')
      DO i = 1, ny
        DO j = 1, nx
        tmp = dabs(phi(j,i))
        WRITE(1,"(1x,F10.5,$)") phi(j,i)
        ENDDO
        WRITE(1,"(1x,F10.5,/)")
      ENDDO
    CLOSE(1)
!!! xi
    write( cFile , * ) temp+100000000
    cFile = 'xidata.' // Trim(AdjustL(cFile)) // ''
    OPEN (1, FILE = cFile, STATUS='UNKNOWN')
      DO i = 1, ny
        DO j = 1, nx
        tmp = dabs(xi(j,i))
        WRITE(1,"(1x,F10.5,$)") xi(j,i)
        ENDDO
        WRITE(1,"(1x,F10.5,/)")
      ENDDO
    CLOSE(1)
!!! End write
    isum=isum+1
    IF(isum>size(sump_done))EXIT
  ENDIF
  print*,iter
 END DO
!!-------------------------------------------------------------------------- 
! End main loop
!!--------------------------------------------------------------------------

! !!! Write time when program starts
!   call date_and_time(date,time,zone,values)
!   call date_and_time(DATE=date,ZONE=zone)
!   call date_and_time(TIME=time)
!   call date_and_time(VALUES=values)
!   OPEN (1, FILE = 'timerecord_fds', STATUS='OLD', ACCESS='APPEND')
!     WRITE(1,"(a,2x,a,2x,a/)") date, time, zone
! !!! Completed

END PROGRAM pffd