# **Shear-driven start-up flow of an Oldroyd-B fluid between parallel plates**

&emsp; This program solves conservation of linear momentum

$$ Re \frac{\partial u}{\partial t}=\frac{\partial \tau}{\partial x} $$

and the Oldroyd-B constitutive model

$$ Wi \frac{\partial \tau}{\partial t}=\frac{\partial u}{\partial x} \
        - \tau + \beta \frac{Wi}{Re} \frac{\partial^2 \tau}{\partial x^2}, $$

where $\tau$ and $u$ are the local shear stress and fluid velocity, respectively. The Reynolds number $Re$ , the Wiessenberg number $Wi$, and the viscosity ratio $\beta$ are defined according to

$$ Re = \frac{\rho U h}{\eta} , $$

$$ Wi = \lambda \frac{U}{h}, $$

and

$$ \beta = \frac{\eta_s}{\eta} .$$

Here $\eta$, $\eta_s$, $\rho$, $U$, $h$, and $\lambda$ are the solution viscosity, solvent visocosity, density, upper plate velocity, gap width, and viscoelastic relaxation time, respectively, and the time scale $\bar t$ for this problem is defined by the characteristic shear rate according to $\bar t = \frac{h}{U}$. The boundary conditions are no flux: $\frac{\partial \tau}{\partial x}|_{x=0} =$ $\frac{\partial \tau}{\partial x}|_{x=1} = 0$ and no slip: $u|_{x=0} = 0$ and $u|_{x=1} = 1$ with uniform initial condtions corresponding to a fluid a rest.

&emsp; In order to view the influence of elasticity in this problem, it is useful to define the elasticity number $E$, given by

$$ E = \frac{Wi}{Re} = \frac{\lambda}{t_{diff}} ,$$
    
which is the ratio of the viscoelastic relaxation time scale $\lambda$ over the momentum diffusion time scale $t_{diff} = \frac{h^2}{\nu}$, where $\nu = \frac{\eta}{\rho}$ is the kinematic viscosity. 

> In this problem, momentum transfer across the gap occurs via two mechanisms: 1) diffusion and 2) shear wave propagation. The value of $E$ indicates the relative importance of these mechanisms.
    
<font size = 3>**<u> Limits:**<u></font>

&emsp; In the limit $E<<1$, viscoelastic relaxation is very fast on the time scale $t_{diff}$ and elasticity effects are negligible. Here, momentum spreads through the fluid via diffusion in response to an imposed shear stress at the wall and eqn (2) reduces to: $\tau = \frac{\partial u}{\partial x}$, corresponding to a Newtonian fluid. In this limit, the conservation equations are parabolic.
    
Alternatively, in the limit $E >> 1$, viscoelastic relaxation is very slow on the time scale $t_{diff}$ and the fluid behaves as an elastic solid. Here, momentum spreads through the fluid via a shear wave in response to a shear stress at the wall. In this case, the conservation equations are hyperbolic.

## **Numerical Scheme:**

The problem described above is a coupled *linear* system of equations of the form:

$$ \frac{\partial q}{\partial t} + A \cdot \frac{\partial q}{\partial x} =  \psi, $$ 

where 

$$ q = \begin{bmatrix} u \\\ \tau \end{bmatrix}, $$

$$ A = \begin{bmatrix} 0 & -\frac{1}{Re} 
                                \\\ -\frac{1}{Wi} & 0 
                                \end{bmatrix}, $$

and
                                
$$ \psi = \begin{bmatrix} 0
                                \\\ \frac{1}{Wi} \tau - \beta E \frac{\partial^2 \tau}{\partial x^2} 
                                \end{bmatrix}. $$

A fractional step approach is used to split the problem into simpler 1D convection and 1D diffusion problems that are solved sequentially each time step. The convective terms are discretized via a second order flux limiter method, which updates $q$ for convection according to

$$q_i^* = q^n_i - \frac{\Delta t}{\Delta x} \left(\lambda_1 W_{i-\frac{1}{2}}
				+ \lambda_2 W_{i+\frac{1}{2}}
                                + F_{i-\frac{1}{2}}
                                + F_{i+\frac{1}{2}}\right). $$

$q$ is then updated for diffusion using the Crank-Nicolson method via

$$ q_i^{n+1} = q_i^* + \Delta t \psi \left(q_i^*,q_i^{n+1}\right). $$

Here, the waves are given by 

$$ W_{i-\frac{1}{2}} = \alpha_{1,i-\frac{1}{2}} r_1$$

and

$$ W_{i+\frac{1}{2}} = \alpha_{2,i+\frac{1}{2}} r_2,$$ 

the eigenvalues of matrix $A$ are

$$\lambda_1  = \frac{1}{Ma}$$

and

$$\lambda_2 = -\frac{1}{Ma},$$

where the viscoelastic Mach number is defined by $Ma = \sqrt{Re Wi} = \frac{U}{c}$ and $c = \sqrt{\frac{\nu}{\lambda}}$ is the shear wave propagation speed. The eigenvectors of matrix $A$ are

$$ \boldsymbol r_1 = \begin{bmatrix} -\sqrt{E}
                                \\\ 1 
                                \end{bmatrix}, $$
                                
and

$$ \boldsymbol r_2 = \begin{bmatrix} \sqrt{E} 
                                \\\ 1 
                                \end{bmatrix}. $$

The eigenmode wave amplitudes are

$$ \alpha_{1, i-\frac{1}{2}} = w_{1,i} - w_{1,i-1} $$

and

$$ \alpha_{2, i+\frac{1}{2}} = w_{2,i+1} - w_{2,i} $$

and the eigenmodes are

$$ w^n_{1,i} = \frac{1}{2\sqrt{E}}\left(\sqrt{E}q^n_{2,i}-q^n_{1,i}\right) $$

and

$$ w^n_{2,i} = \frac{1}{2\sqrt{E}}\left(q^n_{1,i}+\sqrt{E}q^n_{2,i}\right) $$

Finally, the second-order correction flux $F_{i-\frac{1}{2}}$ is defined via:

$$ F_{i-\frac{1}{2}} = \frac{1}{2} \sum_{p=1}^{2}\left|\lambda_p\right| \left(1-\frac{\Delta t}{\Delta x}\left|\lambda_p\right| \right) \alpha_{p, i-\frac{1}{2}} \phi(\theta_{p,i-\frac{1}{2}})$$

where

$$ \theta_{p,i-\frac{1}{2}} = \frac{\alpha_{p, I-\frac{1}{2}}}{\alpha_{p, i-\frac{1}{2}}}, $$

$$ I = \left\{ \begin{matrix} i-1, & \lambda_p > 0 
                                \\\  i+1, &\lambda_p < 0  
                                \end{matrix} \right. ,$$
                                
and the monotenized central flux limiter function is defined according to

$$ \phi(\theta) = max\left(0, min\left(\frac{(1+\theta)}{2},2,2\theta \right)\right). $$
                                
The final result is second order accurate where the solution is smooth and the CFL condition for numerical stability for the convective portion of this problem requires:

$$ \frac{\Delta t}{\Delta x Ma} \leq 1 .$$

## **Results**:

Velocity and shear stress profiles with  
$E = 1$, $Ma = 0.5$, and $\beta = 0.1$

https://github.com/npalex/Start-up-flow-Oldroyd-B-fluid/assets/169947150/94e1ee13-5c25-4a36-a490-f5d3d61007cc

Velocity and shear stress profiles for a Maxwell fluid with  
$E = 1$, $Ma = 0.5$, and $\beta = 0$

https://github.com/npalex/Start-up-flow-Oldroyd-B-fluid/assets/169947150/01d4359d-dd2a-4115-a78c-ea67d4e46edb

**References**:

Clawpack Development Team (2023), Clawpack Version 5.9.2,
    http://www.clawpack.org, doi: 10.5281/zenodo.10076317

R. J. LeVeque, 1997. Wave propagation algorithms for multi-dimensional 
    hyperbolic systems. J. Comput. Phys. 131, 327–353.

R. J. LeVeque. Finite Volume Methods for Hyperbolic Problems. Cambridge 
    University Press, Cambridge, UK, 2002.