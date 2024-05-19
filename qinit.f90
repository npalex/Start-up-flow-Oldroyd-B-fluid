subroutine qinit(meqn,mbc,mx,xlower,dx,q,maux,aux)

    c Set initial conditions for the q array.
    c This default version prints an error message since it should
    c not be used directly.  Copy this to an application directory and
    c loop over all grid cells to set values of q(1:meqn, 1:mx).

    implicit none
    
    integer, intent(in) :: meqn,mbc,mx,maux
    real(kind=8), intent(in) :: xlower,dx
    real(kind=8), intent(in) :: aux(maux,1-mbc:mx+mbc)
    real(kind=8), intent(inout) :: q(meqn,1-mbc:mx+mbc)
    
	c stress-free fluid at rest
    q = 0.d0

end subroutine qinit

