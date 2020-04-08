import re
import numpy as np
import os
import glob

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
	f_temp = open(file_name, "r")

	for line in f_temp:
		m = re.match(r"^clk\s+(\d+)\.(\d+)", line)
		clk = (1000 / (clk_p - float(m.groups()[0] + "." + m.groups()[1]))) if m else 0
	f_temp.close() 

	return clk

def extract_synth_util_file_name(exp_dir):
	loc = exp_dir + "/project_1.runs/synth/"

	try:
		for exp_dir in np.sort(os.listdir(loc)):
			if exp_dir.endswith("_utilization_synth.rpt"):
				return loc + exp_dir
	except:
		pass

	return loc + "*_utilization_synth.rpt"	

if __name__ == "__main__":
	
	f = open("tabulate.txt", "w")

	main_dir = "./workspace/"
	top = "ram_mlut"

	f.write("#       %20s\t%5s\t%5s\t%5s\t%5s\t%6s\t%6s\n" % ("Experiment name", "LUT", "Reg", "DSP", "URAM", "RAMB18", "RAMB36"))
	for exp_dir in np.sort(os.listdir(main_dir)):
		
		# extract resource utilization from synthesis 
		#file_name = main_dir + exp_dir + "/project_1.runs/synth/" + top + "_utilization_synth.rpt"

		file_name = extract_synth_util_file_name(main_dir + exp_dir)

		LUT, Reg, DSP, URAM, RAMB18, RAMB36 = report_synth_resource(file_name)
	


		f.write("# arch: %20s\t%5d\t%5d\t%5d\t%5d\t%6d\t%6d\n" % (exp_dir, LUT, Reg, DSP, URAM, RAMB18, RAMB36))
		
	
	f.close() 
