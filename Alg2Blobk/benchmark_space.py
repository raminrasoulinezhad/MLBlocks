from Param import Param
from Space import Space

my_space = Space("space",
				{	"d":	Param("IWO",	window_en=False),
					"b":	Param("IO",		window_en=False),
					"k":	Param("WO",		window_en=False),
					"c":	Param("IW",		window_en=False),
					"y":	Param("IO",		window_en=False),
					"x":	Param("IO",		window_en=False),
					"fy":	Param("IW",		window_en=False),	# logically True
					"fx":	Param("IW",		window_en=True)			
				})

