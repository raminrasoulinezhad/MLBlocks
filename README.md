# MLBlocks

## Requeirements:
	
Mount RTL Synthesis tools: 

	yum install sshfs
	sshfs -o allow_other dtru2002@research-data-ext.sydney.edu.au:/rds/PRJ-edausers /mnt/edausers
	sshfs -o allow_other dtru2002@research-data-ext.sydney.edu.au:/rds/PRJ-edatools /mnt/edatools

Load the RTL compiler environment
	
	cd ~/setup/setup_working_dir_130nm/
	source .cshrc_hcmos9a_v1 
	cd ~/workspace/MLBlocks/Alg2Block

Creat python3 environment (CentOS):

	scl enable rh-python36 bash
	python3.6 -m venv venv36 

Activate python environment (CentOS): 
	
	scl enable rh-python36 bash
	source ../venv36/bin/activate	

### install python3 on CentOS:
	
	https://www.2daygeek.com/install-python-3-on-centos-6/

### virtual environment on centOS:

	https://developers.redhat.com/blog/2018/08/13/install-python3-rhel/#create-env
	

