subroutine setprob

    implicit none
    character*25 :: fname
    integer :: iunit
    real(kind=8) :: rho,bulk,cc,zz,beta,E,Ma

    common /cparam/ rho,bulk,cc,zz,beta,E,Ma 
    !common /cqinit/ beta
 
    ! Set the material parameters for the acoustic equations
    ! Passed to the Riemann solver rp1.f in a common block
 
    iunit = 7
    fname = 'setprob.data'
    ! open the unit with new routine from Clawpack 4.4 to skip over
    ! comment lines starting with #:
    call opendatafile(iunit, fname)


    ! density:
    !read(7,*) rho
	read(7,*) E

    ! bulk modulus:
    !read(7,*) bulk
	read(7,*) Ma

    ! sound speed:
	cc = 1./Ma
    !cc = dsqrt(bulk/rho)

    ! impedance:
	zz = -dsqrt(E)
    !zz = cc*rho
	
	! density of medium
    read(7,*) rho
	
	! bulk modulus
    read(7,*) bulk
	
    ! viscosity ratio
    read(7,*) beta

end subroutine setprob
