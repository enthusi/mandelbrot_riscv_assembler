# bare metal mandelbrot RV32
A simple example of a mandelbrot fractal for RISCV RV32I CPUs in assembly language.\
![screenshot](http://martinwendt.de/mandelbrot_enthusi.jpg)

mandelbrot.asm is a bare metal assembly example for the Longan Nano.\
It computes a standard mandelbrot fractal in fixpoint math on the 160x80 LCD.\
*size 918 Bytes (1234 Bytes without C extension).*

The code assembles well with the wonderful [bronzebeard](https://github.com/theandrew168/bronzebeard).\
Another bare metal example is here: [lz4 decoder](https://github.com/enthusi/lz4_rv32i_decode).
### usage
```
make
make flash
```

Licensed under the 3-Clause BSD License
Copyright 2021, Martin Wendt
