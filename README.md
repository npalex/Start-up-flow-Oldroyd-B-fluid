# **Shear-driven start-up flow of an Oldroyd-B fluid between parallel plates**

&emsp; This program solves the following system of equations:

$$ Re \frac{\partial u}{\partial t}=\frac{\partial \tau}{\partial x} $$

and

$$ Wi \frac{\partial \tau}{\partial t}=\frac{\partial u}{\partial x} \
        - \tau + \beta \frac{Wi}{Re} \frac{\partial^2 \tau}{\partial x^2}, $$

where $\tau$ and $u$ are the local shear stress and fluid velocity, respectively. The Reynolds number $Re$ , the Wiessenberg number $Wi$, and the viscosity ratio $\beta$ are defined according to

$$ Re = \frac{\rho U h}{\eta} , $$

$$ Wi = \lambda \frac{U}{h}, $$

and

$$ \beta = \frac{\eta_s}{\eta} .$$

Here $\eta$, $\eta_s$, $\rho$, $U$, $h$, and $\lambda$ are the solution viscosity, solvent visocosity, density, upper plate velocity, gap width, and viscoelastic relaxation time, respectively, and the time scale $\bar t$ for this problem is defined by the characteristic shear rate according to $\bar t = \frac{h}{U}$. The boundary conditions are no flux (stress) and no slip (velocity) at $x = 0$ and $x = 1$ with uniform initial condtions.

&emsp; In order to view the influence of elasticity in this problem, it is useful to define the elasticity number $E$, given by

$$ E = \frac{Wi}{Re} = \frac{\lambda}{t_{diff}} ,$$
    
which is the ratio of the viscoelastic relaxation time scale $\lambda$ over the momentum diffusion time scale $t_{diff} = \frac{h^2}{\nu}$, where $\nu = \frac{\eta}{\rho}$ is the kinematic viscosity. 

> In this problem, momentum transfer across the gap occurs via two mechanisms: 1) diffusion and 2) shear wave propagation. The value of $E$ indicates the relative importance of these mechanisms.
    
<font size = 3>**<u> Limits:**<u></font>

&emsp; In the limit $E<<1$, viscoelastic relaxation is very fast on the time scale $t_{diff}$ and elasticity effects are negligible. Here, momentum spreads through the fluid via diffusion in response to an imposed shear stress at the wall and eqn (2) reduces to: $\tau = \frac{\partial u}{\partial x}$, corresponding to a Newtonian fluid. In this limit, the conservation equations are parabolic.
    
Alternatively, in the limit $E >> 1$, viscoelastic relaxation is very slow on the time scale $t_{diff}$ and the fluid behaves as an elastic solid. Here, momentum spreads through the fluid via a shear wave in response to a shear stress at the wall. In this case, the conservation equations are hyperbolic.

For a description of the numerical scheme, see GetData_Oldroyd_B.ipynb

## **Numerical Scheme:**

The problem above is a *linear* system of equations of the form:

$$ \frac{\partial q}{\partial t} + A \cdot \frac{\partial q}{\partial x} =  \psi $$ 

where 

$$ q = \begin{bmatrix} u \\\ \tau \end{bmatrix}, $$

$$ A = \begin{bmatrix} 0 & -\frac{1}{Re} 
                                \\\ -\frac{1}{Wi} & 0 
                                \end{bmatrix} $$
                                
$$ \psi = \begin{bmatrix} 0
                                \\\ \frac{1}{Wi} \tau - \beta E \frac{\partial^2 \tau}{\partial x^2} 
                                \end{bmatrix}. $$

The convective terms are discretized via the Godunov method and flux limiters are used to achieve second order accuracy where the solution is smooth. The diffusive source term is evaluated using the Crank-Nicolson method.

The numerical result is advanced forward in time via operator splitting according to:

$$ q^{*}_i = q^n_i - \frac{\Delta t}{\Delta x} \left(\lambda_1  W<sub>i-\frac{1}{2}</sub> \right)  $$

and

$$ q^{n+1}_i = q^{*}_i + \Delta t \psi \left(q^{*}_i\right), $$


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