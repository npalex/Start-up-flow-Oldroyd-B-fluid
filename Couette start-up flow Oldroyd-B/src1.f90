!*************************************************************************** 
!
! created by: Nathan Alexander (March 2024)
!
! The purpose of this subroutine is to update q by solving the source term 
!         equation tau_t = (beta*Wi/Re)*tau_yy via the Crank-Nicolson method
!         over time dt at time t.
!
! Inputs:
!     meqn   - number of equations
!     mbc    - number of ghost cells per side of spatial domain
!     mx     - number of grid cells
!     xlower - lower bound of spatia domain
!     dx     - grid spacing
!     q      - solution vector q = [v, tau]
!     maux   - not used
!     aux    - not used
!     t      - current time
!     dt     - time interval
!
! Outputs:
!     q      - updated solution vector
!
!***************************************************************************

subroutine src1(meqn,mbc,mx,xlower,dx,q,maux,aux,t,dt)
 
    implicit none
    integer, intent(in) :: mbc,mx,meqn,maux
    real(kind=8), intent(in) :: xlower,dx,t,dt
    real(kind=8), intent(in) ::  aux(maux,1-mbc:mx+mbc)
    real(kind=8), intent(inout) ::  q(meqn,1-mbc:mx+mbc)
	
    integer :: i
    real(kind=8) :: cc,zz,beta,E,Ma
    common /cparam/ cc,zz,beta,E,Ma 
	
    ! allocate memory for local variables and arrays
    integer :: j, info, lda, ldb, nrhs
    integer :: ipiv(mx)
    real(kind=8) :: a(mx-2,mx-2), a1(mx-2,mx-2), a2(mx-2,mx-2), identity(mx-2,mx-2), b(mx-2), alpha, theta
    real(kind=8) :: du(mx-3), dl(mx-3), d(mx-2), du2(mx-4)
	
    ! initialize parameters
    lda = mx-2
    ldb = mx-2
    nrhs = 1
    ipiv = 0
    a = 0.
    a1 = 0.
    a2 = 0.
    b = 0.
    identity = 0.
    dl = 0.
    du = 0.
    d = 0.
    du2 = 0.
	
    ! Crank-Nicolson parameters
    alpha = dt*beta/(dx**2)*dsqrt(E)/Ma
    theta = 0.5

    ! check if maxwell fluid
    if(beta == 0.) then 
        go to 900
    end if
	
    ! construct the identity matrix
    do i = 1, mx-2
        identity(i,i) = 1.
    enddo
		
    ! define tri-diagonal matrix a
    a(1,1) = 1.  				
    a(1,2) = -1.
    a(mx-2, mx-3) = -1.
    a(mx-2, mx-2) = 1.          ! why is there a 1 here and not a 2? because the BC's are Neumann

    do i = 2, mx-3
        a(i,i+1) = -1.  ! elements along upper diagonal
        a(i,i) = 2.
        a(i,i-1) = -1.  ! elemetents along lower diagonal
    enddo
	
    ! define matrix a1 = (I - alpha*theta*a)
    a1 = identity + alpha*theta*a
	
    ! define matrix a2 = [(1 - dt/Wi)*I - alpha*(1 - theta)*a]
    a2 = (1. - dt/(Ma*dsqrt(E)))*identity - alpha*(1.-theta)*a
	
    ! calculate b = [(1-dt/Wi)*I - alpha*(1-theta)*a]*q
    !dgemv (trans, m, n, alpha, a, lda, x, incx, beta, y, incy)
    !evaluates b := alpha*a2*q + beta*b
    call dgemv('n', mx-2, mx-2, 1.d0, a2, mx-2, q(2,2:mx-1), 1, 0.d0, b, 1)
	
    ! extract upper diagonal (du), diagonal (d), and lower diagonal (dl) from matrix a1
    du(1) = a1(1,2)
    dl(1) = a1(mx-2, mx-3)
    d(1) = a1(1,1) 
    d(mx-2) = a1(mx-2, mx-2)

    do i = 2, mx-3
        du(i) = a1(i, i+1)
        d(i) = a1(i,i)
        dl(i) = a1(i, i-1)
    enddo
	
    !SUBROUTINE DGTTRF( N, DL, D, DU, DU2, IPIV, INFO )
    !DGTTRF computes an LU factorization of a real tridiagonal matrix A
    call dgttrf(mx-2, dl, d, du, du2, ipiv, info)
	
    ! SUBROUTINE DGTTRS( TRANS, N, NRHS, DL, D, DU, DU2, IPIV, B, LDB, INFO )
    ! DGTTRS solves A*X = B with a tridiagonal matrix A using the LU factorization computed
    ! by DGTTRF.
    call dgttrs('n', mx-2, nrhs, dl, d, du, du2, ipiv, b, mx-2, info)
	
    ! update q, exclude ghost cells and boundaries
    q(2,2:mx-1) = b

    go to 1000

    900 continue
	
    ! Maxwell fluid src1(), loop over physical domain, 1- velocity, 2 - stress
    do i = 1, mx+1
        q(2,i-1) = q(2,i-1)*(1. - dt/(Ma*dsqrt(E)))
    end do
	
    1000 continue
	
end subroutine src1
