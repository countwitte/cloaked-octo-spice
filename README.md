# cloaked-octo-spice
Small project to visualise in real-time sensor readings from tmotes deployed in a house.

Temperature is read from each node every 5mins and then communicated over serial to a laptop (base node attached)

A python script listens on the serial port for incoming readings and then writes these to a file in a vizualisation friendly format.

Then the google charts API is used to visualise the readings over time.
e.g. 

![myimage](https://www.dropbox.com/s/j6rbryovpuwhsal/Screenshot%20from%202015-05-04%2011%3A57%3A09.png?dl=1)

Issues:
The base node temp is quite high, is this effected by the laptop (have read something about USB voltage inflating temp?)
Communication is very basic and time dependent if more nodes were introduced this would get messy?! 
