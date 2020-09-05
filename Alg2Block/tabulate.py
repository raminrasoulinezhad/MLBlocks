import re
import numpy as np
import os
import glob
from datetime import datetime

import argparse

def report_asic_area(file_name):
	area = -1
	try:
		f_temp = open(file_name, "r")
		
		for line in f_temp:

			m = re.match(r"total\s+\d+\s+(\d+)\.(\d+)", line)
			if m:
				area = float(m.groups()[0] + "." + m.groups()[1])

		f_temp.close() 

		print ('%s is recorded' % (file_name))

	except:
		print ('%s is not available' % (file_name))

	return area 


def report_asic_clk(file_name, clk_p):

	clk = -1
	try:
		f_temp = open(file_name, "r")
		
		for line in f_temp:

			m = re.match(r"Timing slack :\s+(\d+)ps", line)
			if m:
				clk = 1000000.0/(clk_p-int(m.groups()[0]))

		f_temp.close() 

		print ('%s is recorded' % (file_name))

	except:
		print ('%s is not available' % (file_name))

	return clk 

def report_asic_power(file_name):

	power_leakage = power_dynamic = power_total = -1
	try:
		f_temp = open(file_name, "r")
		
		for line in f_temp:

			m = re.match(r"[\w\.]+\s+\d+\s+(\-*\d+)\.(\d+)\s+(\-*\d+)\.(\d+)\s+(\-*\d+)\.(\d+)", line)
			if m:
				power_leakage = float(m.groups()[0] + "." + m.groups()[1])
				power_dynamic = float(m.groups()[2] + "." + m.groups()[3])
				power_total   = float(m.groups()[4] + "." + m.groups()[5])
				break

		f_temp.close() 

		print ('%s is recorded' % (file_name))

	except:
		print ('%s is not available' % (file_name))

	return power_leakage, power_dynamic, power_total 

def extract_synth_util_file_name(exp_dir, mode="synth"):
	# modes: "synth", "placed"
	if (mode == "synth"):
		loc = exp_dir + "/project.runs/synth/"
	elif (mode == "placed"):
		loc = exp_dir + "/project.runs/impl/"
	else:
		raise Exception ("file name extractor: mode is wrong")

	try:
		for exp_dir in np.sort(os.listdir(loc)):
			if exp_dir.endswith("_utilization_" + mode + ".rpt"):
				return loc + exp_dir
	except:
		pass

	return loc + "*_utilization_" + mode + ".rpt"	


def extract_impl_timing_routed_file_name(exp_dir):
	loc = exp_dir + "/project.runs/impl/"

	try:
		for exp_dir in np.sort(os.listdir(loc)):
			if exp_dir.endswith("_timing_summary_routed.rpt"):
				return loc + exp_dir
	except:
		pass

	return loc + "_timing_summary_routed.rpt"	


def extract_asic_file_name(exp_dir, file_type="cell"):

	#file_type = "timing", "cell", "power", "area"
	
	loc = exp_dir + "/"
	try:
		for exp_dir in np.sort(os.listdir(loc)):
			if exp_dir.endswith("_initialtest_" + file_type + ".rep"):
				return loc + exp_dir
	except:
		pass

	return loc + "*_initialtest_" + file_type + ".rep"	


def get_asic_results(exps_addr, period=1333):	

	file_name = extract_asic_file_name(exps_addr, "cell")
	area_asic = report_asic_area(file_name)

	file_name = extract_asic_file_name(exps_addr, "timing")
	clk_asic = report_asic_clk(file_name, period)

	file_name = extract_asic_file_name(exps_addr, "power")
	power_leakage, power_dynamic, power_total = report_asic_power(file_name)

	return area_asic, clk_asic, int(power_total)
