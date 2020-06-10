
## requirements 

    pip3 install mip numpy

## run the tool

	python3 main.py

## TODO:

### among window-able parameters, fx is now the only which can be windowed. 

It is fine in our case. However, this is wrong in general. Any parameter, 1) which is used for indexing the Inputs (I, W, O) and 2) does not appear in the output (O), while is accompanied by another parameter(s) in an input indexing, can be windowed. 

In our eight-nested loop supermodel, **fx** and **fy** are those candidates. However, windowing both **fx** and **fy** does not make sense in practice. Since a line buffer per dot-product is required. Thus, we decided to make fx the only window-able parameter. (**fy** is not appearing in 1D algorithms). Note, **fx**, **fy** and **fz** are parameters different dimensions of the same characteristics)
