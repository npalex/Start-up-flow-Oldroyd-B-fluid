subroutine src1(meqn,mbc,mx,xlower,dx,q,maux,aux,t,dt)

    ! Called to update q by solving source term equation 
    ! $q_t = \psi(q)$ over time dt starting at time t.
    !
    ! This default version does nothing. 
 
    implicit none
    integer, intent(in) :: mbc,mx,meqn,maux
    real(kind=8), intent(in) :: xlower,dx,t,dt
    real(kind=8), intent(in) ::  aux(maux,1-mbc:mx+mbc)
    real(kind=8), intent(inout) ::  q(meqn,1-mbc:mx+mbc)
	
	integer :: i
	!real(kind=8) :: E,Ma,cc,zz,Wi
	real(kind=8) :: rho,bulk,cc,zz,beta,E,Ma
	real(kind=8) :: a(mx-2,mx-2), identity(mx-2,mx-2)
	
	!common /cparam/ E,Ma,cc,zz,Wi
	common /cparam/ rho,bulk,cc,zz,E,Ma 
	
	! initalize arrays
!	a = 0.
!	identity = 0.
	
	! populate matrices
!	do i = 1, mx-2
		
	
	! loop over physical domain, 1- velocity, 2 - stress
	do i = 1, mx+1
		q(2,i-1) = q(2,i-1)*(1. - dt/(Ma*dsqrt(E)))
	end do
	
end subroutine src1