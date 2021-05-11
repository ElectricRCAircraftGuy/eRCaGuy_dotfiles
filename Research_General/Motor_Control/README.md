Motor control notes:

Modes:
1. Throttle control
1. Speed control
1. Current control (is: torque control, since current is proportional to torque)
1. FOC (Field Oriented Control--I think basically just means uses real, PWMed sine waves
Instead of just trapezoidal waves?

Assuming you have a throttle controlled controller, you can manually close the outer loop and 
Control speed or current, but this is NOT the same as speed control or current control, which are lower level and more direct.

I hypothesize speed control is done by varying current to get a desired speed. And 
What about current? Varying lead phase angle??

Concepts:
1. phase
1. Y vs Delta termination
1. Half H bridge (each of the 3 phases must connect to a high/low driver Half H-bridge).                         
1. Sensored vs sensorless control
    1. Sensored uses hall sensors, encoders, etc for feedback. Halls are good but high jitter.
    1. Sensorless uses back EMF
1. Phase lead angle: how far ahead the driving phase is from the motors actual location. Eg: 12 deg. Large 
Phase angles are like higher gears in a car: higher power, less torque, more speed. Small Phase angles are like
Lower gears: lower speed and higher torque.
1. Commutation
1. PWM








