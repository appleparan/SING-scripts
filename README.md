# singularity-py-and-jl
Simple singularity recipe for Keras (Python 3) & Flux (Julia) (personal use)
Base image: nvidia/cuda + julia at Dockerhub

# How to build 

## Flux (Julia)
```
$ sudo singularity build /opt/singularity/flux-jskim.sif flux-julia.def
```

## Keras (Python)
```
$ sudo singularity build /opt/singularity/keras-jskim.sif keras-py3.def
```

## Torch (Python)
```
$ sudo singularity build /opt/singularity/torch-jskim.sif torch-py3.def
```

## Setting up Julia
```
$ julia
```

* press `]`

```
(v1.4) pkg> up
```

## Setting up Python
* Install python via [pyenv](https://github.com/pyenv/pyenv) and [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv)

```
$ pyenv install 3.8.2
$ pyenv virtualenv 3.8.2 env
$ pyenv local env
(env) $ pip install package_name
```

# How to setup executable files 

* If you have changed sif file name, change corresponding name in `keras` and `flux` script

## add files to your home directory

```
$ mkdir -p ~/usr/bin
$ chmod +x keras
$ chmod +x flux
$ cp keras ~/usr/bin
$ cp flux ~/usr/bin
```

or you can make symbolic link (`ln -s src dest` to your `bin` directory)

* Assume `~/usr/bin` has been added to your PATH

# How to run script in singularity 

* assume we have `some_case_name` and save code results to `${HOME}/data/some_case_name`


## Flux

```
$ flux -b some_case_name my_code.jl
```

## PyTorch

```
$ torch -b some_case_name my_code.py
```

## Keras

```
$ keras -b some_case_name my_code.py
```

# How to access shell inside singularity image

## Flux (Julia)

```
$ flux -s
```

## PyTorch (Python 3)

```
$ torch -s
```


## Keras (Python 3)

```
$ keras -s
```

# Important Things

1. Use envionments in `Pkg` because host and guest system share `~/.julia` so there would be build issue
    * Link : https://julialang.github.io/Pkg.jl/v1/environments/#Creating-your-own-projects-1

2. Shell script may not be work in specific order. 


# Jupyter & Flux

* run following command
```
    flux -b "name" -n
```

* connect local machine via SSH tunneling using following command, then open web browser by this address, localhost:8157`.
```
ssh "remoteId"@"remoteIP" -p "remoteSSHPort" -NL 8157:localhost:8889 "remoteId"@"remoteIP"
```

# TODO

1. Better docs
2. Better usage (`-h` option)
3. Better command line arguments handling in shell script

