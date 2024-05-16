subroutine setprob

    implicit none
    character*25 :: fname
    integer :: iunit
    real(kind=8) :: cc,zz,beta,E,Ma
    common /cparam/ cc,zz,beta,E,Ma 
 
    ! Set the material parameters
    ! Passed to the Riemann solver rp1.f in a common block
    iunit = 7
    fname = 'setprob.data'
	
    ! open the unit with new routine from Clawpack 4.4 to skip over
    ! comment lines starting with #:
    call opendatafile(iunit, fname)
	
    ! Elasticity number
    read(7,*) E

    ! viscoelastic mach number:
    read(7,*) Ma

    ! viscosity ratio: (e.g., for a polymer solution,... 
    ! ...beta is the viscosity of the mixture over that of the solvent)
    read(7,*) beta

    ! shear wave propagation speed:
    cc = 1./Ma

    ! square root of the elasticity number:
    zz = -dsqrt(E)

end subroutine setprob
