before here make sure the verilog models are placed in `repo/out` directory in folders.

then run the vivado process (Synthesis in parallel):
```
./script_exps.sh
```
then capture the results:
```
python3 tabulate.py --dir==projects_VUS+_6n/
```

