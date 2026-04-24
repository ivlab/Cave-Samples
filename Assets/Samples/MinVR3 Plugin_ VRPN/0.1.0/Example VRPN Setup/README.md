# Example VRPN Setup

This example contains a simple scene that demonstrates the capabilities of this VRPN unity client.

The example assumes that you have a VRPN server already running with the following config, or similar:

```
################################################################################
# Example Button server. This is a "device" that reports on and off for
# each of its buttons at the specified rate. It can be used to verify connections
# are working and for other tests of VRPN. There are three arguments:
#	char	name_of_this_device[]
#	int	number_of_buttons
#	float	rate_at_which_the_buttons_toggle		(transitions/second)

vrpn_Button_Example	Button0	1	1.0

################################################################################
# Spin Tracker. This is a "device" that reports a spinning rotation at the
# origin for each of its sensors at the specified rate.  It can be used to
# provide smooth motion to debug rendering systems.
# There are seven arguments:
#	char	name_of_this_device[]
#	int	number_of_sensors
#	float	rate_at_which_to_report_updates
#	float	x_of_axis_to_spin_around
#	float	y_of_axis_to_spin_around
#	float	z_of_axis_to_spin_around
#	float	rotation_rate_around_axis_in_Hz

vrpn_Tracker_Spin	Tracker0	1	10.0  0.0 1.0 0.0  0.1


################################################################################
# Open the mouse as an analog and button devices.  There is an implementation
# under Windows and another under Linux (using GPM).  There are two analog
# channels, reporting in the range [0..1] as the mouse moves across the screen.
# There are 3 button channels: left, middle, right.
#
# There is one argument:
#	char	name_of_this_device[]

vrpn_Mouse	Analog0
```