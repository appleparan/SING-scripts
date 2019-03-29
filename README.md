# singularity-py-and-jl
Simple singularity recipe for Keras(python3) & Flux(julia) (personal use)

# How to build 
## Keras
```
$ sudo singularity build /opt/singularity/keras-mine.sif keras-py3.def
```

## Flux
```
$ sudo singularity build /opt/singularity/flux-mine.sif flux-julia.def
```

# How to setup executable files 
```
$ mkdir -p ~/usr/bin
$ cp keras ~/usr/bin
$ cp flux ~/usr/bin
$ chmod +x keras
$ chmod +x flux
```

* Assume `~/usr/bin` has been add to your PATH

# How to run script in singularity with output directory (${HOME}/data/'output')

## Keras

```
$ keras -b some_case_name my_code.py
```

## Flux

```
$ flux -b some_case_name my_code.jl
```

# TODO

1. better docs
2. better usage (`-h` option)

