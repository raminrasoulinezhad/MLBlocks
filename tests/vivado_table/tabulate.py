import re
import numpy as np
import os
import glob
from datetime import datetime

import argparse

def get_args():
	parser = argparse.ArgumentParser(description='')
	parser.add_argument('--dir', type=str, default="./projects_VUS+_6n/", help='directory to explore')

	args = parser.parse_args()
	return args


def report_synth_resource(file_name, mode="synth"):

	LUT = Reg = DSP = URAM = RAMB18 = RAMB36 = -1
	try:
		f_temp = open(file_name, "r")
		
		for line in f_temp:
			#print(line)
			if (mode == "synth"):
				m = re.match(r"\|\s+CLB LUTs\*\s+\|\s+(?P<LUT>\d+)", line)
			else:
				m = re.match(r"\|\s+CLB LUTs\s+\|\s+(?P<LUT>\d+)", line)
			if m:
				LUT = int(m.groups("LUT")[0])


			m = re.match(r"\|\s+CLB Registers\s+\|\s+(?P<Reg>\d+)", line)
			if m:
				Reg = int(m.groups("Reg")[0])


			m = re.match(r"\|\s+DSPs\s+\|\s+(?P<DSP>\d+)", line)
			if m:
				DSP = int(m.groups("DSP")[0])


			m = re.match(r"\|\s+URAM\s+\|\s+(?P<URAM>\d+)", line)
			if m:
				URAM = int(m.groups("URAM")[0])


			m = re.match(r"\|\s+RAMB18\s+\|\s+(?P<RAMB18>\d+)", line)
			if m:
				RAMB18 = int(m.groups("RAMB18")[0])


			m = re.match(r"\|\s+RAMB36\/FIFO\*\s+\|\s+(?P<RAMB36>\d+)", line)
			if m:
				RAMB36 = int(m.groups("RAMB36")[0])


		f_temp.close() 

		print ('%s is recorded' % (file_name))

	except:
		print ('%s is not available' % (file_name))

	return LUT, Reg, DSP, URAM, RAMB18, RAMB36


def report_impl_wns(file_name, clk_p):
	clk = -1
	try:
		f_temp = open(file_name, "r")
		for line in f_temp:
			# Please check the name of the clock which here is CLK. in many cases it can be clk.
			#print(line)
			m = re.match(r"^clk\s+(\-*\d+)\.(\d+)", line)
			if m:
				clk = (1000 / (clk_p - float(m.groups()[0] + "." + m.groups()[1])))
		f_temp.close() 
		print ('%s is recorded' % (file_name))

	except:
		print ('%s is not available' % (file_name))

	return clk


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


if __name__ == "__main__":
	
	args = get_args()

	now = datetime.now() # current date and time
	date_time = now.strftime("_%Y_%m_%d_%H_%M_%S")

	file_save = "tabulate"+date_time+".txt"
	f = open(file_save, "w")

	main_dir = args.dir 	#"./projects/"
	print (main_dir)
	f.write("%-45s\t%4s %4s %3s %5s\t%5s %5s %10s\n" % ("Experiment name", "LUT", "Reg", "DSP", "freq", "area", "freq", "Pow(nW)"))
	for exp_dir in np.sort(os.listdir(main_dir)):
		if exp_dir in ["answers", "files"]:
			continue 
		else: 
			
			if main_dir.endswith("6n/") or main_dir.endswith("6n"):
				clk_p = 6
			elif main_dir.endswith("4n/") or main_dir.endswith("4n"):
				clk_p = 4
			else: 
				raise Exception ("clock constraints is not identified")


			# extract resource utilization from synthesis 
			#file_name = main_dir + exp_dir + "/project_1.runs/synth/" + top + "_utilization_synth.rpt"

			#file_name = extract_synth_util_file_name(main_dir + exp_dir, mode="synth")
			#LUT, Reg, DSP, URAM, RAMB18, RAMB36 = report_synth_resource(file_name, mode="synth")
			
			file_name = extract_synth_util_file_name(main_dir + exp_dir, mode="placed")
			LUT, Reg, DSP, URAM, RAMB18, RAMB36 = report_synth_resource(file_name, mode="placed")

			file_name = extract_impl_timing_routed_file_name(main_dir + exp_dir)
			clk_fpga = report_impl_wns(file_name, clk_p)

			file_name = extract_asic_file_name(main_dir + exp_dir, "cell")
			area_asic = report_asic_area(file_name)

			file_name = extract_asic_file_name(main_dir + exp_dir, "timing")
			clk_asic = report_asic_clk(file_name, clk_p * 1000)
	
			file_name = extract_asic_file_name(main_dir + exp_dir, "power")
			power_leakage, power_dynamic, power_total = report_asic_power(file_name)

			f.write("%-45s\t%4d %4d %3d %5d\t%5d %5d %10d\n" % (exp_dir, LUT, Reg, DSP, clk_fpga, area_asic, clk_asic, int(power_total)))
		
	f.close() 

	os.system('cat ' + file_save) 
