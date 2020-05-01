import re
import numpy as np
import os
import glob
from datetime import datetime

def report_synth_resource(file_name):

	LUT = Reg = DSP = URAM = RAMB18 = RAMB36 = -1
	try:
		f_temp = open(file_name, "r")
		
		for line in f_temp:
			#print(line)
			m = re.match(r"\|\s+CLB LUTs\*\s+\|\s+(?P<LUT>\d+)", line)
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
			m = re.match(r"^CLK\s+(\d+)\.(\d+)", line)
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


def report_asic_clk(file_name, clk_def_ps):

	clk = -1
	try:
		f_temp = open(file_name, "r")
		
		for line in f_temp:

			m = re.match(r"Timing slack :\s+(\d+)ps", line)
			if m:
				clk = 1000000.0/(clk_def_ps-int(m.groups()[0]))

		f_temp.close() 

		print ('%s is recorded' % (file_name))

	except:
		print ('%s is not available' % (file_name))

	return clk 



def extract_synth_util_file_name(exp_dir):
	loc = exp_dir + "/project.runs/synth/"

	try:
		for exp_dir in np.sort(os.listdir(loc)):
			if exp_dir.endswith("_utilization_synth.rpt"):
				return loc + exp_dir
	except:
		pass

	return loc + "*_utilization_synth.rpt"	


def extract_impl_timing_routed_file_name(exp_dir):
	loc = exp_dir + "/project.runs/impl/"

	try:
		for exp_dir in np.sort(os.listdir(loc)):
			if exp_dir.endswith("_timing_summary_routed.rpt"):
				return loc + exp_dir
	except:
		pass

	return loc + "_timing_summary_routed.rpt"	


def extract_asic_area_file_name(exp_dir):
	loc = "answers/" + exp_dir + "_initialtest_cell.rep"
	return loc

def extract_asic_clk_file_name(exp_dir):
	loc = "answers/" + exp_dir + "_initialtest_timing.rep"
	return loc


if __name__ == "__main__":
	
	now = datetime.now() # current date and time
	date_time = now.strftime("_%Y_%m_%d_%H_%M_%S")

	f = open("tabulate"+date_time+".txt", "w")
	clk_def_ps = 1333
	DSP48E2_area = 7958

	#main_dir_fpga = "./"+arith+"_fpga/"
	main_dir_asic = "./MLBlock_sample_dir/"

	#f.write("#       %20s\t%5s\t%5s\t%5s\t%5s\t\t%5s\t%5s\n" % ("Experiment name", "LUT", "Reg", "DSP", "freq", "area", "freq"))
	f.write("#       %-30s\t\t%5s\t%5s\n" % ("Experiment name", "area", "freq"))
	for exp_dir in np.sort(os.listdir(main_dir_asic)):
		if exp_dir in ["answers", "files"]:
			continue 
		else: 
			# extract resource utilization from synthesis 
			#file_name = main_dir + exp_dir + "/project_1.runs/synth/" + top + "_utilization_synth.rpt"

			#file_name = extract_synth_util_file_name(main_dir_fpga + exp_dir)
			#LUT, Reg, DSP, URAM, RAMB18, RAMB36 = report_synth_resource(file_name)

			#file_name = extract_impl_timing_routed_file_name(main_dir_fpga + exp_dir)
			#clk_fpga = report_impl_wns(file_name, 6)

			file_name = extract_asic_area_file_name(exp_dir)
			area = report_asic_area(main_dir_asic + file_name)

			file_name = extract_asic_clk_file_name(exp_dir)
			clk_asic = report_asic_clk(main_dir_asic + file_name, clk_def_ps)

			#f.write("# arch: %20s\t%5d\t%5d\t%5d\t%5d\t\t%5d\t%5d\n" % (exp_dir, LUT, Reg, DSP, clk_fpga, area, clk_asic))
			if (DSP48E2_area >=  area):
				fit = "\tYes" 
			elif (DSP48E2_area * 1.1 >=  area):
				fit = "\t10%%" 
			else: 
				fit = ""

			f.write(("# arch: %-30s\t\t%5d\t%5d" % (exp_dir, area, clk_asic)) + fit + "\n") 
		
	
	f.close() 
