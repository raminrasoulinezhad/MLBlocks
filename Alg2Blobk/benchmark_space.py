from Param import Param
from Space import Space

my_space = Space("space",
				{	"d":	Param("IWO"),
					"b":	Param("IO"),
					"k":	Param("WO"),
					"c":	Param("IW"),
					"y":	Param("IO"),
					"x":	Param("IO", 	window_accompany=True),
					"fy":	Param("IW"),	# logically can be windowed as well
					"fx":	Param("IW",		windowed=True)			
				})

print ("\n-- The space is loaded\n")
