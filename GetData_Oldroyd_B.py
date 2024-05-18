#*************************************************************************** 
#
# created by: Nathan Alexander (March 2024)
#
# The purpose of this program is to extract numerical data for visualization
#
#***************************************************************************
     
import numpy as np
from io import StringIO
import matplotlib.pyplot as plt
from matplotlib import animation
from IPython.display import HTML

#-- extract constants from fort.q000
#f = np.genfromtxt("fort.q0000", usecols=np.arange(0,1))
f = np.genfromtxt(r'/home/npalex/Start-up-flow-Oldroyd-B-fluid/_output/fort.q0000', usecols=np.arange(0,1))

#-- define constants
mx = int(f[2])                # total number of cells 
xlow = f[3]                   # lower limit of spatial domain
dx = f[4]                     # grid spacing

#-- extract the number of output times from claw.data
g = np.genfromtxt(r'/home/npalex/Start-up-flow-Oldroyd-B-fluid/_output/claw.data', usecols=np.arange(0,1))
steps = int(g[9])                                 # number of time steps
meqn = 2                                          # number of governing equations

#-- print parameters
with open(r'/home/npalex/Start-up-flow-Oldroyd-B-fluid/_output/setprob.data', 'r') as f:
    print(f.read())

#-- initialize arrays 
q = np.zeros((meqn, steps+1, mx))                  

#-- exract data from files for each time step
for k in range(0, meqn):
    for i in range(0, steps+1):
        #f = np.genfromtxt("fort.q0001", usecols=np.arange(k,k+1))
        if i<10:
            f = np.genfromtxt(r'/home/npalex/Start-up-flow-Oldroyd-B-fluid/_output/fort.q000' + str(i), usecols=np.arange(k,k+1))
    
        elif i<100:
            f = np.genfromtxt(r'/home/npalex/Start-up-flow-Oldroyd-B-fluid/_output/fort.q00' + str(i), usecols=np.arange(k,k+1))

        else:
            f = np.genfromtxt(r'/home/npalex/Start-up-flow-Oldroyd-B-fluid/_output/fort.q0' + str(i), usecols=np.arange(k,k+1))
        q[k, i, :] = f[5:]

#-- define array of cell centers
x = np.arange(xlow + dx/2, 1-dx/2 + dx, dx)


#*************************************************************************** 
#
# created by: Nathan Alexander (March 2024)
#
# The purpose of this program is to plot/animate the results for start-
#    up flow of an Oldroyd-B fluid between parallel plates
#
#***************************************************************************

#------------------------------------------------
#-- plot results as an animation using matplotlib
#------------------------------------------------
mult = 1
fig = plt.figure(figsize=(6,6))
ax = plt.axes(xlim=(-0.02, 1.02), ylim=(-0.02, 1.1))            # creates axes at specifed limits, (gca() not required)

#-- initialize object that will contain plot data
line1, = ax.plot(np.array([]), np.array([]), linewidth = 2, color = "black", label = "$u$")  #-- the rhs is a LIST containing an object. "line1, =" extracts the object from the list. 
line2, = ax.plot(np.array([]), np.array([]), linewidth = 2, color = "red", label = "$\u03C4$")  #-- the rhs is a LIST containing an object. "line1, =" extracts the object from the list. 

#-- define function, which is an argument for the method animation.FuncAnimation() and is called for each frame
def fplot(frame_number):

    #-- store plot data for new frame (ensure first farme is IC)
    if frame_number == 0:
        line1.set_data(x, q[0, frame_number, :])
        line2.set_data(x, q[1, frame_number, :])

    else:
        line1.set_data(x, q[0, mult*frame_number, :])
        line2.set_data(x, q[1, mult*frame_number, :])

    return(line1)

#-- configure legend font and location
ax.legend(fontsize = 16, loc = "upper left")
ax.set_xlabel('$x$', fontsize = 16)

#-- generate animation
anim = animation.FuncAnimation(fig = fig, func = fplot, frames=int(steps/mult), interval=30, repeat=False)
plt.close()                        #-- removes residual plot at final time
#HTML(anim.to_jshtml())             #-- print animation in jupyter notebook
#HTML(anim.to_html5_video(embed_limit=None)) #-- create mp4 video

with open("Results.html", "w") as f:
    print(anim.to_html5_video(), file=f)