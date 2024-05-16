<font size = 8>**<u> Start-up, shear-driven flow of a Oldroyd-B fluid between parallel plates**<u></font>

&emsp; This program solves the following system of equations:

$$ Re \frac{\partial v_x}{\partial t}=\frac{\partial \tau_{xy}}{\partial y} $$

and

$$ Wi \frac{\partial \tau_{xy}}{\partial t}=\frac{\partial v_x}{\partial y} \
        - \tau_{xy} + \beta \frac{Wi}{Re} \frac{\partial^2 \tau_{xy}}{\partial y^2}, $$

where the Reynolds $Re$ and Wiessenberg $Wi$ numbers and the viscosity ratio $\beta$ are defined according to

$$ Re = \frac{\rho U h}{\eta} , $$

$$ Wi = \lambda \frac{U}{h}, $$

and

$$ \beta = \frac{\eta_s}{\eta} .$$

Here $\eta$, $\eta_s$, $\rho$, $U$, $h$, and $\lambda$ are the solution viscosity, solvent visocosity, density, upper plate velocity, gap width, and viscoelastic relaxation time, respectively, and the time scale $\bar t$ of this problem is defined by the characteristic shear rate according to $\bar t = \frac{h}{U}$.

&emsp; The boundary conditions are no flux (stress) and no slip (velocity) at $y = 0$ and $y = 1$ with uniform initial condtions. The numerical scheme employs the Godulov (generalized upwind) method and monontenized centeral flux limiter functions.

&emsp; In order to view the influence of elasticity in this problem, it is useful to define the elasticity number $E$, given by

$$ E = \frac{Wi}{Re} = \frac{\lambda}{t_{diff}} ,$$
    
which is the ratio of the viscoelastic relaxation time scale $\lambda$ over the momentum diffusion time scale $t_{diff} = \frac{h^2}{\nu}$, where $ \nu = \frac{\eta}{\rho}$ is the kinematic viscosity, also known as the momentum diffusivity. 

> In this problem, momentum transfer across the gap occurs via two mechanisms: 1) diffusion and 2) shear wave propagation. The value of $E$ indicates the relative importance of these mechanisms.
    
<font size = 3>**<u> Limits:**<u></font>

&emsp; In the limit $E<<1$, viscoelastic relaxation is very fast on the time scale $t_{diff}$ and elasticity effects are negligible. Here, momentum spreads through the fluid via diffusion in response to an imposed shear stress at the wall and eqn (2) reduces to: $\tau_{xy} = \frac{\partial v_x}{\partial y}$, corresponding to a Newtonian fluid. In this limit, the conservation equations are parabolic.
    
Alternatively, in the limit $E >> 1$, viscoelastic relaxation is very slow on the time scale $t_{diff}$ and the fluid behaves as an elastic solid. Here, momentum spreads through the fluid via a shear wave in response to a shear stress at the wall. In this case, the conservation equations are hyperbolic.

<font size = 3>**<u> Numerical Scheme:**<u></font>

The problem above is a *linear* system of hyperbolic equations of the form:
$$ \frac{\partial \boldsymbol q}{\partial t} + \boldsymbol A \cdot \frac{\partial \boldsymbol q}{\partial x} =  \boldsymbol\psi $$ 

where 
$$ \boldsymbol q = \begin{bmatrix} v 
                                \\ \tau 
                                \end{bmatrix}, $$

$$ \boldsymbol A = \begin{bmatrix} 0 & -\frac{1}{Re} 
                                \\ -\frac{1}{Wi} & 0 
                                \end{bmatrix}, $$

and

$$ \boldsymbol \psi = \begin{bmatrix} 0
                                \\ \frac{1}{Wi} \tau - \beta E \frac{\partial^2 \tau}{\partial y^2} 
                                \end{bmatrix}. $$

The system of equations is discretized via the Godunov method (generalized upwind), fractional splitting to handle the source term, and monotenized central flux limiter functions to achieve second order accuracy where the solution is smooth.

The equations used to advance the solution forward in time by one time step are given by:
$$ \boldsymbol q^{*}_i = \boldsymbol q^n_i - \frac{\Delta t}{\Delta x} \left(\lambda_1 \boldsymbol W_{i-\frac{1}{2}} 
                                + \lambda_2 \boldsymbol W_{i+\frac{1}{2}}
                                + \boldsymbol F_{i-\frac{1}{2}}
                                + \boldsymbol F_{i+\frac{1}{2}}\right) $$
                                
and

$$ \boldsymbol q^{n+1}_i = q^{*}_i + \Delta t \boldsymbol \psi \left(\boldsymbol q^{*}_i\right), $$

the latter of which is evaluated using the Crank-Nicolson method. 
The waves are given by 

$$ \boldsymbol W_{i-\frac{1}{2}} = \boldsymbol \alpha_{1,i-\frac{1}{2}}\boldsymbol r_1$$
and
$$ \boldsymbol W_{i+\frac{1}{2}} = \boldsymbol \alpha_{2,i+\frac{1}{2}}\boldsymbol r_2$$ 

the eigenvalues  are
$$\lambda_1  = \frac{1}{Ma}$$
and
$$\lambda_2 = -\frac{1}{Ma},$$

where the viscoelastic Mach number is $Ma = \sqrt{Re Wi} = \frac{U}{c}$  and $c = \sqrt{\frac{\nu}{\lambda}}$ is the shear wave propagation speed.

The eigenvectors are
$$ \boldsymbol r_1 = \begin{bmatrix} -\sqrt{E}
                                \\ 1 
                                \end{bmatrix}, $$
                                
and
$$ \boldsymbol r_2 = \begin{bmatrix} \sqrt{E} 
                                \\ 1 
                                \end{bmatrix}, $$

where $E = \frac{Wi}{Re}$ is the elasticity number.

The eigenmode wave amplitudes are

$$ \alpha_{1, i-\frac{1}{2}} = w_{1,i} - w_{1,i-1} $$

and

$$ \alpha_{2, i+\frac{1}{2}} = w_{2,i+1} - w_{2,i} $$

and the eigenmodes are

$$ w^n_{1,i} = \frac{1}{2\sqrt{E}}\left(\sqrt{E}q^n_{2,i}-q^n_{1,i}\right) $$

and

$$ w^n_{2,i} = \frac{1}{2\sqrt{E}}\left(q^n_{1,i}+\sqrt{E}q^n_{2,i}\right) $$

Finally, flux $ F_{i-\frac{1}{2}}$ is defined via:

$$ F_{i-\frac{1}{2}} = \frac{1}{2} \sum_{p=1}^{2}\left|\lambda_p\right| \left(1-\frac{\Delta t}{\Delta x}\left|\lambda_p\right| \right) \alpha_{p, i-\frac{1}{2}} \phi(\theta_{p,i-\frac{1}{2}})$$

where

$$ \theta_{p,i-\frac{1}{2}} = \frac{\alpha_{p, I-\frac{1}{2}}}{\alpha_{p, i-\frac{1}{2}}}, $$

$$ I = \left\{ \begin{matrix} i-1, & \lambda_p > 0 
                                \\  i+1, &\lambda_p < 0  
                                \end{matrix} \right. ,$$
                                
and the flux limiter function is defined according to

$$ \phi(\theta) = max\left(0, min\left(\frac{(1+\theta)}{2},2,2\theta \right)\right). $$
                                
Note, the CFL condition for numerical stability requires:

$$ \frac{\Delta t}{\Delta x Ma} \leq 1 .$$
